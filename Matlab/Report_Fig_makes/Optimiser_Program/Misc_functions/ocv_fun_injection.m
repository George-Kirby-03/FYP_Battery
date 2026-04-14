function sim_handler = ocv_fun_injection(sim_handler,ocv_curve)
%OCV_FUN_INJECTION undefined
%   undefined
arguments (Input)
    sim_handler struct
    ocv_curve
end
if isfield(sim_handler.ocv_curve_dat,'curvefun')
    message('Supplied OCV function already used')
else
    sim_handler.ocv_curve_dat.curvefun = ocv_curve;
    temp.ocv_curve = sim_handler.ocv_curve_dat.curvefun;
    sim_handler.ocv_curve = @(x1) polymodel(temp,0,x1,1);
end

end