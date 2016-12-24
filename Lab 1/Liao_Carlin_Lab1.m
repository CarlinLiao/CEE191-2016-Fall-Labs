%% A. Establish initial constraints

maxHardness = 1200; % kg/ML

demand = [30 10 50 20 40]; % ML

% col is src
wc = [
    15 10 60 80     % supplyLimit in ML
    250 200 2300 700];  % hardness in ML

costWater = [
    450 460 440 445 455
	495 500 505 510 490
	900 915 885 920 920
    1800 1815 1795 1785 1820];
costWater = reshape(costWater',[20,1]);

maxSrc1and2 = 20; % ML

%% B. Create matrix A and vector b

% row is source
% col is destin

% c = costWater linearized [1x20]
% x = minimaized flow linearized [1x20]
%     flows = [...
%         f1A f1B...
%         f2A f2B...
%     linearizes to
%     x = [f1A f1B f1C... f4G f4M];

A = [];
b = [];

% structural constraint
% sum(src(1)) + sum(src(2)) <= 20 MG
A = [A; 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 ];
b = [b; maxSrc1and2];

% hardness constraint per city x
% sum(flowCity(x)*hardnessCity(x)) <= maxHardness
A = [A; [wc(2,1) 0 0 0 0 wc(2,2) 0 0 0 0 wc(2,3) 0 0 0 0 wc(2,4) 0 0 0 0] ];
A = [A; [0 wc(2,1) 0 0 0 0 wc(2,2) 0 0 0 0 wc(2,3) 0 0 0 0 wc(2,4) 0 0 0] ];
A = [A; [0 0 wc(2,1) 0 0 0 0 wc(2,2) 0 0 0 0 wc(2,3) 0 0 0 0 wc(2,4) 0 0] ];
A = [A; [0 0 0 wc(2,1) 0 0 0 0 wc(2,2) 0 0 0 0 wc(2,3) 0 0 0 0 wc(2,4) 0] ];
A = [A; [0 0 0 0 wc(2,1) 0 0 0 0 wc(2,2) 0 0 0 0 wc(2,3) 0 0 0 0 wc(2,4)] ];
b = [b; demand'*maxHardness];

% demand constraint per city x
% sum(fcty(x)) == neededWater(x)
Aeq = [];
Aeq = [Aeq; 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 ];
Aeq = [Aeq; 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 ];
Aeq = [Aeq; 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 ];
Aeq = [Aeq; 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 ];
Aeq = [Aeq; 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 ];
beq = demand';

% supply limit constraint per source n
% sum(fsrc(i)) <= supplyLimit(x)
A = [A; 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];
A = [A; 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 ];
A = [A; 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 ];
A = [A; 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 ];
b = [b; wc(1,:)'];

% all greater than 0
% fsrccity(i,x) >= 0
% -fscrcity(i,x) <= 0
A = [A; diag(-1*ones(1,20))];
b = [b; zeros(20,1)];

%% 2. 

% Run prior two sections
x_10yrs = linprog(costWater,A,b,Aeq,beq);
cost10yrs = sum((x_10yrs).*costWater);
x_10yrs_r = round(reshape(x_10yrs,[5 4])',3);

%% 3a. 5% lower forecast
beq_3a = beq.*.95;
b_3a = b;
b_3a(2:6) = b_3a(2:6)*.95;
x_3a = linprog(costWater,A,b_3a,Aeq,beq_3a);
x_3a_r = round(reshape(x_3a,[5 4])',3);

%% 3b. 5% higher forecast
beq_3b = beq.*1.05;
b_3b = b;
b_3b(2:6) = b_3b(2:6)*1.05;
x_3b = linprog(costWater,A,b_3b,Aeq,beq_3b);
x_3b_r = round(reshape(x_3b,[5 4])',3);

%% 3c. increased supply limits for sources 3 and 4
b_3c = b;
b_3c(9:10) = [95; 75];
x_3c = linprog(costWater,A,b_3c,Aeq,beq);

%% 4. Kiwi, Inc.

% Effectively adding 1 ML more demand to Berrytown demand
beq_4 = beq;
beq_4(2) = beq(2)+1;
x_4 = linprog(costWater,A,b,Aeq,beq_4);
% vectorize costWater by rows and monetize flows including Kiwi water
kiwiWaterExpense = sum((x_4 - x_10yrs).*costWater);
% check if expense delta is greater than the proposed $1,500/day payment
shouldCountyAccept = 1500 > kiwiWaterExpense;

%% 5. Added structure at Source 1

% increased supply limit for source 1
b_5 = b;
b_5(7) = b(7)+2;
x_5 = linprog(costWater,A,b_5,Aeq,beq);
% vectorize costWater by rows and monetize change in flow
costChangeWithStructure1 = sum((x_5 - x_10yrs).*costWater);
% check if expense delta less daily cost is net zero (a cost savings)
shouldCountyBuild = costChangeWithStructure1 + 10 < 0;

%% 6. Increase supply from Source 3

% increased supply limits for 3 and 4
b_6 = b;
b_6(9) = b(9)+2; % assume same as Problem 5, given on Piazza
x_6 = linprog(costWater,A,b_6,Aeq,beq);
% vectorize costWater by row and monetize change in flow to find max cost
maxCostForStructure3 = -sum((x_10yrs - x_6).*costWater);


%% 7. Replacement pipe

Aeq_7 = [Aeq; 0 0 0 0 0 0 0 0 0 0 ((wc(2,3)-1340).*ones(1,5)) ((wc(2,4)-1340).*ones(1,5)) ];
beq_7 = [beq; 0 ];
x_7 = linprog(costWater,A,b,Aeq_7,beq_7);
shouldCountyCombinePipe = sum((x_7 - x_10yrs).*costWater) - 700000 < 0; 
