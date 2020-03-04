function [f] = Opt_O2(In)
%Opt_O2 Function fed to fminsearch to minimize ToF
%   Input:
%       In: vector of delta V applied to craft
%   Output:
%       f: quantity being minimised (Time of Flight)

% Run integrator
    [~,~,te,~,ie] = Integrator(In);

% Return usable results only for earth impact
    if ie == 2
        f = (te/3600).^2;
    else
        f = inf;
    end

end

