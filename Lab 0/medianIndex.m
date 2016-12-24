function [ indices ] = medianIndex( V )
% V assumed to be a vector of all integers

Vwork = abs(V-median(V));
indices = find(Vwork==min(Vwork));

end

