function poly = polymaker(polycount, range, lower_bound, use_bound, predict_Q, temp)
%POLYMAKER Quick Function To Produce the Polynomial Coefficent & indexes
%NOTE: R0, R1, C, Q in that order AFTER
 arguments
        polycount
        range
        lower_bound
        use_bound
        predict_Q
        temp = 0   % Default value
    end
poly.xl = -ones(1,polycount)*range;
poly.xe = rand(1,polycount);
poly.xu = ones(1,polycount)*range;
if use_bound == 1
    poly.xl(1) = lower_bound - 0.4;
    poly.xe(1) = poly.xl(1);
    poly.xu(1) = poly.xe(1) + 0.4; 
end
if predict_Q == 1
poly.R0 = polycount+3;
poly.R1 = polycount+4;
poly.C  = polycount+2;
poly.Q = polycount+1;

else
poly.R0 = polycount+2;
poly.R1 = polycount+3;
poly.C  = polycount+1;
end
if temp == 1
poly.R0 = polycount+3;
poly.R1 = polycount+4;
poly.C  = polycount+2;
poly.CP = polycount+6;
poly.A = polycount+5;
end
end