% Carlin Liao
% CEE 191 Lab 2

M = 10^6;
%% Problem 8

% min -T_paint
c = [zeros(1,3),-1];
% x = [t_1, t_2, d_2,1, T_paint]
intcon = 3;
%
A = [ -1  0  0  0;
       1  0  0  0;
       0 -1  0  0;
       0  1  0  0;
       1 -1 -M  1;
      -1  1  M  1 ];
b = [ -8 11 -(1+12) 3+12 0 M]';
lb = [ 0 0 0 0 ];
ub = [ inf inf 1 inf];

intlinprog(c,intcon,A,b,[],[],lb,ub)

%% Problem 10 Initialization

% min -T_paint
c = [zeros(1,59) -1];
% x = [t_1 ... t_8,         8
%      x_1,1 ... x_1,(4-1)  3       starts	9       
%      ... x_2,5            5               12                
%      ... x_3,3            3               17      
%      ... x_4,3            3               20      
%      ... x_5,3            3               23
%      ... x_6,3            3               26
%      ... x_7,1            1               29
%      ... x_8,2,           2               30
%      d_2,1 ... d_8,1      7               32
%      d_3,2 ... d_8,2      6               39
%      ...                  5+4+3+2         45,50,54,57
%      ... d_8,7            1               59
%      T_paint ]            1 totals to 60
intcon = linspace(1,51,51)+8;
lb = zeros(1,60);
ub = [ ones(1,8)*inf ones(1,51) inf];
A = zeros(87,60);
b = zeros(87,1);

%% Problem 10 Constraint t_i >= thing
% A
tempA = cell(8,1);
tempA{1} = [1 zeros(1,9-2) 10-8 12+2-10 3-2]; % difference, not real time
tempA{2} = [zeros(1,1) 1 zeros(1,12-3) 9.5-8 12+2-9.5 4-2 6-4 8-6 ];
tempA{3} = [zeros(1,2) 1 zeros(1,17-4) 9-7 12+3-9 5-3 ];
tempA{4} = [zeros(1,3) 1 zeros(1,20-5) 12+2-8 4-2 6-4 ];
tempA{5} = [zeros(1,4) 1 zeros(1,23-6) 12+2-8.5 3-2 5-3 ];
tempA{6} = [zeros(1,5) 1 zeros(1,26-7) 12+2-8 3-2 7-3 ];
tempA{7} = [zeros(1,6) 1 zeros(1,29-8) 10.5-8 ];
tempA{8} = [zeros(1,7) 1 zeros(1,30-9) 3-2 4-3 ];

for n = 1:8
    A(n,:) = -1*[tempA{n} zeros(1,60-length(tempA{n}))];
end

% b
b(1:8) = -1*[3 8 5 6 5 7 -1.5 4]-12; %pm to 24 hr

%% Problem 10 Constraint t_i <= thing
% A
tempB = cell(8,1);
tempB{1} = [1 zeros(1,9-2) 10.5-9 12+2.5-10.5 5-2.5]; % difference, not real time
tempB{2} = [zeros(1,1) 1 zeros(1,12-3) 10.5-9 12+3-10.5 5-3 7-5 9-7 ];
tempB{3} = [zeros(1,2) 1 zeros(1,17-4) 12-8 4 7-4 ];
tempB{4} = [zeros(1,3) 1 zeros(1,20-5) 15-9 5-3 7-5 ];
tempB{5} = [zeros(1,4) 1 zeros(1,23-6) 14.5-9.5 3.5-2.5 5.5-3.5 ];
tempB{6} = [zeros(1,5) 1 zeros(1,26-7) 12+2.5-9.5 4-2.5 7.5-4 ];
tempB{7} = [zeros(1,6) 1 zeros(1,29-8) 11-10 ];
tempB{8} = [zeros(1,7) 1 zeros(1,30-9) 3.5-2.5 5-3.5 ];

for n = 1:8
    A(n+8,:) = [tempB{n} zeros(1,60-length(tempB{n}))];
end

% b
b(9:16) = [5 9 7 7 5.5 7.5 -1 5]'+12; %pm to 24 hr

%% Problem 10 x_i,j <= x_i,j+1

%      x_1,1 ... x_1,(4-1)  3       starts	9       
%      ... x_2,5            5               12                
%      ... x_3,3            3               17      
%      ... x_4,3            3               20      
%      ... x_5,3            3               23
%      ... x_6,3            3               26
%      ... x_7,1            1               29
%      ... x_8,2,           2               30
%      d_2,1 ... d_8,1      7               32

q = [1 -1];

A(17,9:10) = q;
A(18,10:11) = q;

A(19,12:13) = q;
A(20,13:14) = q;
A(21,14:15) = q;
A(22,15:16) = q;

A(23,17:18) = q;
A(24,18:19) = q;

A(25,20:21) = q;
A(26,21:22) = q;

A(27,23:24) = q;
A(28,24:25) = q;

A(29,26:27) = q;
A(30,27:28) = q;

% no x for i = 7

A(31,30:31) = q;

b(17:31) = 0; % redundant as b has already been declared, for clarity

%% 

currentRow = 32;
counter = 0;
for i = 2:8
    for j = 1:i-1
        counter = counter + 1;
        locDij = 31 + counter;
        A(currentRow  , [i j locDij 60]) = [-1 1 -M 1];
        A(currentRow+1, [i j locDij 60]) = [1 -1 M 1];
        b(currentRow+1) = M; % b has already been initialized as 0
        currentRow = currentRow+2;
    end
end

%% Problem 10 intlinprog

% I got 1.75 on the first run and was amazed
intlinprog(c,intcon,A,b,[],[],lb,ub)


%% Problem 11

A_11 = A;
b_11 = b;
A_11(8,30) = -(3-1);
A_11(16,30) = 3.5-1.5;

intlinprog(c,intcon,A_11,b_11,[],[],lb,ub)
