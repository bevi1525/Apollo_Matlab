function [value,isterminal,direction] = SC_Events(~,y)
%SC_Events Houses the termination conditions for integration of 3B problem

%% Defining position vectors for each body
    pos_S = [y(1),y(2)];
    pos_E = [0,0];
    pos_M = [y(5),y(6)];

%% Defining event values
    % Lunar impact: SC position goes nearer to the lunar center than the
    % lunar radius
        LI = norm(pos_S - pos_M) - 1.7371e6;

    % Earth Impact: SC position goes nearer to the earth center than the
    % earth radius
        EI = norm(pos_S - pos_E) - 6.371e6;

    % Lost in Space: SC distance from Earth is twice that of the distance
    % between the Moon and Earth
        LiS = 2.*norm(pos_M - pos_E) - norm(pos_S - pos_E);

%% Defining outputs
    value = [LI; EI; LiS];
    % Each event terminates the sim
    isterminal = [1; 1; 1];
    % Evaluate each event only on reducing values
    direction  = [-1; -1; -1];
end