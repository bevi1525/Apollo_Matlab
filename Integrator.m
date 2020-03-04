function [t,Out,te,ye,ie] = Integrator(del_V)
%Integrator Receives delta V for Apollo and calculates trajectory result
%   Input:
%       del_V: 1x2 vector with x & y components of impulse burn resultant
%              velocity
%   Output:
%       t: time vector
%       Out: function values
%       te: time of termination event
%       ye: function values at termination
%       ie: termination case

%% Defining variables & quantities
    % Gravitational constant
        G = 6.674e-11; % [(N m^2)/kg^2]
    % Mass of the moon
        mass_M = 7.34767309e22; % [kg]
    % Mass of the earth
        mass_E = 5.97219e24; % [kg]

%% Integration
    % Defining initial conditions
        dES = 340e6; % [m]
        dEM = 384.403e6; % [m]
        V_S = 1e3; % [m/s]
        V_M = sqrt((G.*mass_E.^2)./((mass_E + mass_M).*dEM)); % [m/s]
        theta_M = deg2rad(42.5); % [rad]
        theta_S = deg2rad(50); % [rad]
        
        % Spacecraft initials
        x_S = dES.*cos(theta_S);
        y_S = dES.*sin(theta_S);
        Vx_S = V_S.*cos(theta_S);
        Vy_S = V_S.*sin(theta_S);
        
        % Moon initials
        x_M = dEM.*cos(theta_M);
        y_M = dEM.*sin(theta_M);
        Vx_M = -V_M.*sin(theta_M);
        Vy_M = V_M.*cos(theta_M);
        
    % Input to ode45
        In = [x_S,y_S,Vx_S+del_V(1),Vy_S+del_V(2),x_M,y_M,Vx_M,Vy_M]';
        
    % Defining options
        options = odeset('RelTol',1e-8,'Events',@SC_Events);

    % Calling ode45
        [t,Out,te,ye,ie] =...
            ode45(@Spacecraft,[0 1e10],In,options);

end

