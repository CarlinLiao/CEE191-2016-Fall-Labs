function [ res ] = greaterThan100( V )

V(find(V<=100)) = [];

if isempty(V)
    res = 0;
else
    res = min(V);
end

end

