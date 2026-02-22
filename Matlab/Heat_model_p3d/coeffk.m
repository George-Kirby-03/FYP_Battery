function cmatrix = coeffK(location,state,cx,cy)

n1 = 2;
nr = numel(location.y);
cmatrix = zeros(n1,nr);
cmatrix(1,:) = cx.*location.y;
cmatrix(2,:) = cy.*location.y;

end