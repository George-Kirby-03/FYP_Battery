function [dx, y] = tempReversable_dynamics(t, x, u, R0, R1, C, Q, Cp, A, c0, c1, c2, c3, c4, c5, varargin)
%Temp ir+rev

% Output equation.
y = x(1);                                     

% State equations.
dx = [u.^2*R0 + u.*x(3) - u.*x(1).*(1/Cp).*(c0 + c1*x(2) + c2*(x(2).^2) + c3*(x(2).^3) + c4*(x(2).^4) + c5*(x(2).^5)) - A.*x(1)*(1/Cp);   
      u./Q;
      u./C - x(3)./(R1.*C)
     ];