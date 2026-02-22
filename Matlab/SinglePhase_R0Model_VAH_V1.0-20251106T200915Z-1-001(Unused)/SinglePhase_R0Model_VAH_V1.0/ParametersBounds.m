function [pl,pu,guess] = ParametersBounds(poly_bound_pl, poly_bound_pu,decvar_bound_pl, decvar_bound_pu,vdat)
%rc_pair_pl,rc_pair_pu,


% Inputs:
%   decVar_Np       - No. of decision variable parameters.
%   poly_bound_pl   - Lower bound for polynomial parameters.
%   poly_bound_pu   - Upper bound for polynomial parameters.
%   decvar_bound_pl - Lower bound for decision variable parameters.
%   decvar_bound_pu - Upper bound for decision variable parameters.
%
% Outputs:
%   pl    - Lower bounds for the parameters.
%   pu    - Upper bound for the parameters.
%   guess - Guess parameters.
%
% Example usage:
%   [pl, pu, guess] = ParametersBounds(-200, 200, 0, 12000,vdat);
% Paing Ko @ University of Sheffield

%------------- BEGIN CODE --------------

% Compute guess values (midpoint) for each block.
poly_guess   = (poly_bound_pl + poly_bound_pu) / 2;
decvar_guess = (decvar_bound_pl + decvar_bound_pu) / 2;
%rc_pair_guess = (rc_pair_pl+rc_pair_pu)/2;

% Create the arrays by concatenating the blocks.
pl    = [0,poly_bound_pl * ones(1, vdat.Np_poly-1),  decvar_bound_pl * ones(1, vdat.DecVar_Np-1),0];
pu    = [5,poly_bound_pu *ones(1, vdat.Np_poly-1),  decvar_bound_pu * ones(1, vdat.DecVar_Np-1),0.1];
guess = [3.2,poly_guess * ones(1, vdat.Np_poly-1),  decvar_guess * ones(1, vdat.DecVar_Np-1), 0.002];


end

