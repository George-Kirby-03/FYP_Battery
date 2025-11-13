function [outputArg1,outputArg2] = cc3(param_struct,problem_struct,c1,c2,c3,t_vec)
%CC3 Creates the 3 custom chargin segments, done to reach 80% soc
stage1_time = 0.2*param_struct.(problem_struct.data.poly.Q)/c1;
stage2_time = 0.2*param_struct.(problem_struct.data.poly.Q)/c2;
stage3_time = 0.2*param_struct.(problem_struct.data.poly.Q)/c3;
end