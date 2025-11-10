function dx = dynamics(t, y, solution, current_fun)
R1 = solution(end);
R0 = solution(end-1);
C = solution(end-2);
Q = solution(end-3);
current = current_fun(t);
dx = zeros(2,1);
dx(1) = current./Q;
dx(2) = -y(2)./(R1.*C) + current./C;
end
