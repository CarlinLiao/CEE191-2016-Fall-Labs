%% CE 191 - Systems Analysis
%   Lab 4 : Snow depth sensor placement

% Edit of skeleton code provided by instructors

%%
clear
fs = 16;

%% Problem 3
% Input problem parameters
load density;
R_max = 0.3;

x0_vec = 0:0.1:1;
y0_vec = 0:0.1:1;

f_mat = zeros(11);
for ii = 1:11
    for jj = 1:11
        z = [ x0_vec(ii) y0_vec(jj) R_max ]; % COMPOSE X0, Y0, R INTO VECTOR Z
        f_mat(ii,jj) = coverage(z,rho);
    end
end

%% Plot of density
figure(1)
surf(1:100,1:100,rho)
xlabel('x location')
ylabel('y location')
zlabel('probability density')
title('Probability density at x,y location found using kernel density estimation')

%% PLOT OBJECTIVE AS FUNCTION OF (X0,Y0), GIVEN R = RMAX
figure(2)
surf(x0_vec, y0_vec, f_mat)
xlabel('x_0')
ylabel('y_0')
zlabel('Cumulative density')
title('Cumulative density of area covered given R = 0.3')

%% Problem 4
% Inequality constraints
A = [];
b = [];

% Upper and lower bounds
lb = [0 0 0];
ub = [1 1 R_max];

% Initial Guess
z0 = [0.5 0.4 R_max-1e-6];

% Optimization Options
opts = optimset('Display','iter','TolFun',5e-6);

% Nonlinear Optimizer
[zstar,fstar,exitflag,~,lambda] = ...
    fmincon(@(z) coverage(z,rho), z0, A, b,[],[],lb,ub,[],opts);

% Parse Optimal Solution
x0star = zstar(1);
y0star = zstar(2);
Rstar = zstar(3);

% Compute Geocode. You can plug this into Google Maps
% to see where the optimal sensor location would be!
lat = 39.1223 + x0star*(39.1315 - 39.1223);
lon = -120.2314 + y0star*(-120.2222 - (-120.2314));
fprintf(1,'(latitude,longitude) = (%3.6f,%3.6f)\n',lat,lon);
