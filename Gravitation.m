function [F12] = Gravitation(M1,M2,pos1,pos2)
%Gravitation Computes force exterted between two bodies
%   Inputs:
%       G: gravitational parameter
%       M1: mass of body 1
%       M2: mass of body 2
%       pos1: position vector for body 1
%       pos2: position vector for body 2
%   Ouput:
%       F12: attractive force vector

% Defining gravitational constant
    G = 6.674e-11; % [(N m^2)/kg^2]
% Parsing input
    d12 = norm(pos1-pos2);
% Calculate force
    F12 = (G.*M1.*M2.*(pos1-pos2))./d12.^3;
end
