% Completed skeleton code

function f = coverage(z,rho)

% Parse design variables
x0 = z(1);
y0 = z(2);
R = z(3);

% Vectors for integration variables r and \theta
N = 25;
r_vec = linspace(0,R,N); % VECTOR OF r FROM r = 0 TO r = R
theta_vec = linspace(0,2*pi,N); % VECTOR OF theta FROM theta = 0 TO theta = 2*pi

% Domain of density function, rho
xx = linspace(0,1,size(rho,1));
yy = linspace(0,1,size(rho,2));

% Integrate over \theta
rho_r_int = zeros(N,1);
for ii = 1:N

    % Integrate over r, given \theta
    rho_r = zeros(N,1);
    for jj = 1:N

        % Calculate x and y coordinates for each ii, jj
        x = x0 + r_vec(jj)*cos(theta_vec(ii));
        y = y0 + r_vec(jj)*sin(theta_vec(ii));

        % Use interp2 to compute integrand. The last parameter assigns 0
        % outside the feasible domain. Read documentation.
        rho_r(jj) = interp2(xx,yy,rho,x,y,'linear*',0) * r_vec(jj);
    end

    % Use trapz to integrate over r numerically
    rho_r_int(ii) = trapz(rho_r);

end

% Use trapz to integrate over theta numerically
f = -trapz(rho_r_int);
