function [f] = Opt_O1(In)
%Opt_O1 Summary of this function goes here
%   Input:
%       In: vector of delta V applied to craft
%   Output:
%       f: quantity being minimised (delta V)

% Run integrator
    [~,~,~,~,ie] = Integrator(In);

% Return usable results only for earth impact
    if ie == 2
        f = (norm(In));
    else
        f = inf;
    end

end

