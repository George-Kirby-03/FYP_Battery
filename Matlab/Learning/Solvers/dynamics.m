function dx = dynamics(t, y, solution, current)
R1 = solution(end);
R0 = solution(end-1);
C = solution(end-2);
Q = solution(end-3);
    dx = (1/(R1*C)) * (Vin - y*(1 + R1/R2)) ;
end
