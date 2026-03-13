function poly = polymaker(polycount, range, predict_Q, predict_temp, lower_bound,dynamics)
%POLYMAKER Quick Function To Produce the Polynomial Coefficent & indexes
 arguments
        polycount 
        range = 0
        predict_Q = 0
        predict_temp = 0  
        lower_bound = 0
        dynamics struct = 0
 end

poly.poly_length = polycount;
poly.xl = -ones(1,polycount)*range;
poly.xe = rand(1,polycount);
poly.xu = ones(1,polycount)*range;
if lower_bound ~= 0
    poly.xl(1) = lower_bound - 0.05;
    poly.xe(1) = lower_bound;
    poly.xu(1) = poly.xe(1) + 0.05; 
end
poly.R0 = polycount+1;
poly.R1 = polycount+2;
poly.C  = polycount+3;
poly.dynams = [dynamics.R0, dynamics.R1, dynamics.C];
if predict_Q == 1 && predict_temp == 1
    poly.Q = polycount+4;
    poly.Cp = polycount+5;
    poly.h = polycount+6;
    poly.dynams = [poly.dynams, dynamics.Q, dynamics.Cp, dynamics.h];
elseif predict_Q == 0 && predict_temp == 1
    poly.Cp = polycount+4;
    poly.h = polycount+5;
    poly.dynams = [poly.dynams, dynamics.Cp, dynamics.h];
elseif predict_Q == 1 %predict_temp must be not getting predicted then
    poly.Q = polycount+4;
    poly.dynams = [poly.dynams, dynamics.Q];
end %if not q or predict_temp, neither added

end