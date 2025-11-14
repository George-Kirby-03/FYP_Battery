function dx = dynamics(t, y, solution, current_fun)

R1 = solution(end);
C = solution(end-2);
Q = solution(end-3);
current = current_fun(t);

if y(1) <=0.01 && current< 0
    y(1) =0;
    current =0;
end

if y(1) >=1 && current> 0
    y(1) =1;
    current =0;
end

dx = zeros(2,1);
dx(1) = current./Q;
dx(2) = -y(2)./(R1.*C) + current./C;
end
