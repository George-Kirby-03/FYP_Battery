function k = pekernal(dim, a0, alpha, x, xprime)
    % dim: input dimension
    % a0: output scale (like alpha_0)
    % alpha: per-dim weight or length scale
    % x, xprime: vectors of length dim

    if length(alpha) == 1
        alpha = alpha * ones(dim,1); % same weight in all dimensions
    end

    ecu = 0;
    for i = 1:dim
        ecu = ecu + alpha(i)*(x(i)-xprime(i))^2;  % weighted squared distance
    end

    k = a0 * exp(-ecu);
end
