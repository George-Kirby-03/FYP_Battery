function dx = dynamics(t, y, C, R1, R2, func_lut)
    if t < 10
        Vin = 5;
    else
        Vin = 20;
    end
    
    dx = (1/(R1*C)) * (Vin - y*(1 + R1/R2)) ;
end
