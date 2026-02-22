function bcMatrix = Newman_BC(location,state,a,b)
n1 = 1;
nr = numel(location.y);
bcMatrix = zeros(n1,nr);
bcMatrix(1,:) = a*b.*location.y;
end