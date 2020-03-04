function [out] = Spacecraft(~,inputs)
%Spacecraft Houses EoMs for spacecraft motion wrt Earth and the Moon
%   Tracks motion of the spacecraft and the Moon with respect to the Earth
%   which defines the origin for the frame used

%% Parsing inputs
    x_S = inputs(1);
    y_S = inputs(2);
    Vx_S = inputs(3);
    Vy_S = inputs(4);
    x_M = inputs(5);
    y_M = inputs(6);
    Vx_M = inputs(7);
    Vy_M = inputs(8);
    
%% Calculating forces
    % Defining constants
        % Mass of the moon
            mass_M = 7.34767309e22; % [kg]
        % Mass of the earth
            mass_E = 5.97219e24; % [kg]
        % Mass of the spacecraft
            mass_S = 2.8833e4; % [kg]
        % Position of Earth (stationary)
            x_E = 0;
            y_E = 0;
            
    % Running calcs
        % Force between Moon & Spacecraft
            F_MS = Gravitation(mass_M,mass_S,[x_M,y_M],[x_S,y_S]);
        % Force between Earth & Spacecraft
            F_ES = Gravitation(mass_E,mass_S,[x_E,y_E],[x_S,y_S]);
        % Force between Earth & Moon
            F_EM = Gravitation(mass_E,mass_M,[x_E,y_E],[x_M,y_M]);

%%  Assigning values to outputs 
    % Position
        % Spacecraft
            dx_S = Vx_S;
            dy_S = Vy_S;
        % Moon
            dx_M = Vx_M;
            dy_M = Vy_M;
        
    % Velocity
        % Spacecraft
            dV_S = (F_MS + F_ES)./mass_S;
        % Moon
            dV_M = (F_EM - F_MS)./mass_M;
        
%% Formatting output
    out = [dx_S,dy_S,dV_S(1),dV_S(2),dx_M,dy_M,dV_M(1),dV_M(2)]';

end

