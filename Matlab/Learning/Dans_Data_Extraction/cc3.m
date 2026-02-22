function [tout_vec] = cc3(solution,c1,c2,c3,t_vec)
%% Use time based vector (seconds)
%CC3 Creates the 3 custom charging segments till 80% (20% each)
%Starts from t_vec(0)

Q = solution(end-3);
stage1_time = 0.2*Q/c1;
[~, stage1_rel] = min(abs(t_vec-stage1_time));
stage2_time = 0.2*Q/c2;
[~, stage2_rel] = min(abs(t_vec-stage2_time-stage1_time));
stage3_time = 0.2*Q/c3;
last_time_to_find = t_vec-stage3_time-stage2_time-stage1_time;
[~, stage3_rel] = min(abs(last_time_to_find));

tout_vect = [c1*ones(stage1_rel,1)', c2.*ones(stage2_rel-stage1_rel,1)', c3.*ones(stage3_rel-stage2_rel,1)', zeros(length(t_vec)-stage3_rel,1)'];
tout_vec = tout_vect';
end