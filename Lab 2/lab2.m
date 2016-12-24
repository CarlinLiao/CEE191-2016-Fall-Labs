% Carlin Liao
% CEE 191 Lab 2

%% initialize and construct

currentGeneration = 199; % MWh
expectedPrice =     [140 68 90 103 96 45 160 100];  % $/MWh
sigmaPrice =        [23 20 10 6 20 7 32 35];        % $/MWh
maxCost =           80; % $ / MWh

H = diag(2*sigmaPrice.^2,0);
f = zeros(8,1);
A = diag(ones(1,8),0).*-1; % mix proportion has to be greater than 0
A = [A; expectedPrice]; % proportions have to be below price max
b = [zeros(8,1); maxCost];
Aeq = ones(1,8); % mix proportions have to sum to 1
beq = 1;

%% 2

[mix2022,risk2022] = quadprog(H,f,A,b,Aeq,beq);
cost2022 = sum(mix2022.*expectedPrice');

%% 3

currentMix = [6 5.4 44 9.2 2.6 4.4 6.0 8.2]'./100; % percentages, sum!=100
risk3 = (1/2)*currentMix'*H*currentMix;
cost3 = sum(currentMix.*expectedPrice');

%% 4

x4 = linspace(50,250,100);
b4temp = b;
risk4 = x4.*0;
risk4min = risk2022;
mix4min = mix2022;
for i = 1:length(x4)
    b4temp(9) = x4(i);
    [mix4temp,risk4(i)] = quadprog(H,f,A,b4temp,Aeq,beq);
    if risk4(i) < risk4min
        risk4min = risk4(i);
        mix4min = mix4temp;
    end
end
plot(x4,risk4)
xlabel('Max price (USD/MWh)')
ylabel('Risk (USD/MWh)^2')
title('Max Price vs. Risk')
cost4min = sum(mix4min.*expectedPrice');

%% 5

peakFutureGen = 250; % MWh

A5 = A;
b5 = b;

A5 = [A5; [0 0 0 0 1 1 1 1]*-1 ]; % 33% renewable constraint
b5 = [b5; -0.33];
A5 = [A5; diag(ones(1,8),0).*peakFutureGen ]; % new maximum constraints
b5 = [b5; [40 50 150 35 30 40 240 60]' ];
[mix5,risk5] = quadprog(H,f,A5,b5,Aeq,beq);
