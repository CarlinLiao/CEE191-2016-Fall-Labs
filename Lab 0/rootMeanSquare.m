function [ y ] = rootMeanSquare( n )
%RMS Summary of this function goes here
%   Detailed explanation goes here

syms y k
y = sqrt(1/n * symsum(1/k^2, k, 1, n))
y = double(y);

end

