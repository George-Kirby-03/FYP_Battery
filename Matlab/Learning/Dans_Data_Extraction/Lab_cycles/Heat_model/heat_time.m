function fmatrix = heat_time(location,state,q_fun)
q = q_fun(state.time);
n1 = 1;
nr = numel(location.y);
fmatrix = zeros(n1,nr);
fmatrix(1,:) = q.*location.y;
end