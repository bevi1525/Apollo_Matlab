%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Benjamin Vidaurre for ASEN 4057 Assignment 2
% Collaborator: Barbara de Figuereido Vera
%
% Created: 1/22/20
% Last modified: 2/4/20
%
% Purpose: Governs investigation of methods for returning Apollo 13 craft
% to earth via optimizing a numerical integration of the 3-body problem 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Housekeeping
    clear
    close all
    clc

%% Defining variables & quantities
    % Gravitational constant
        G = 6.674e-11; % [(N m^2)/kg^2]
    % Mass of the moon
        mass_M = 7.34767309e22; % [kg]
    % Mass of the earth
        mass_E = 5.97219e24; % [kg]
    % Mass of the spacecraft
        mass_S = 2.8833e4; % [kg]
    % Radius of the moon
        rad_M = 1.7371e6; % [m]
    % Radius of the earth
        rad_E = 6.371e6; % [m]

%% Objective 1: Minimum delta V for Earth return
% Initial search: Along the axes w/ *10 m/s* resolution
    % Along x axis (y = 0)
    [del_V_vec_O1x,del_V_O1x,Time_O1x] = Grid([-100,100],[1,1],[11,1],1);
    % Along y axis (x = 0)
    [del_V_vec_O1y,del_V_O1y,Time_O1y] = Grid([1,1],[-100,100],[1,11],1);

    % Initialise best delta V
        Best_O1_1 = [];
        
    % Check variation along x axis
    if isempty(del_V_O1x) == 0
        [min_del_V_O1x,Index] = min(del_V_O1x);
        Best_O1_1 = [del_V_vec_O1x,del_V_O1x,Time_O1x];
    end

    % Check variation along y axis
        if isempty(del_V_O1y) == 0
            [min_del_V_O1y,Index] = min(del_V_O1y);

        % Check whether x sweep returned solution
            if isempty(Best_O1_1) == 1
                Best_O1_1 = [del_V_vec_O1y,del_V_O1y,Time_O1y];

        % If x sweep returned solution, compare both solutions
            elseif del_V_O1y < Best_O1_1(2)
                Best_O1_1 = [del_V_vec_O1y,del_V_O1y,Time_O1y];
            end
        end
        
    % If neither axis sweep returned result, start spiral sweep from origin
    % step size 10 m/s
        if isempty(Best_O1_1) == 1
            [del_V_vec_O1S1,del_V_O1S1,Time_O1S1] = Spiral([0,0],10,11,1);
        
    % Else spiral outward from first sweep result, step size 2
        else
            [del_V_vec_O1S1,del_V_O1S1,Time_O1S1] =...
                Spiral([Best_O1_1(1),Best_O1_1(2)],2,8,1);
        end
        
    % Grab best result from spiral 1
        [~,index_O1_1] = min(del_V_O1S1);
      
    % Spiral 2 centered about best result from spiral 1, Step size 0.5
        [del_V_vec_O1S2,del_V_O1S2,Time_O1S2] =...
                    Spiral(del_V_vec_O1S1(index_O1_1,:),0.5,9,1);
    
    % Grab best result from spiral 2
        [~,index_O1_2] = min(del_V_O1S2);
        
    % Input to optimizer
        Optim_In_O1 = del_V_vec_O1S2(index_O1_2,:);
        
    % Feeding to fminsearch
    % Set options 
        Opt_min_O1 = optimset('TolX',1e-4,'TolFun',1e-4);
    % Optimize
        [Opt_out_O1,mag_Opt_out_O1] = ...
            fminsearch(@Opt_O1,Optim_In_O1,Opt_min_O1);
    % Print reults to command line
    fprintf('\nSolution for Objective 1:\n');
    fprintf('Delta V x-component: %f m/s\n',Opt_out_O1(1));
    fprintf('Delta V y-component: %f m/s\n',Opt_out_O1(2));
    fprintf('Delta V magnitude: %f m/s\n',mag_Opt_out_O1);
        
%% Plotting solution for objective 1
    % Compute solution with optimal ICs
    [t_O1,Out_O1,te_O1,ye_O1,ie_O1] = Integrator(Opt_out_O1);
    
    figure
    % Craft path
    plot(Out_O1(:,1),Out_O1(:,2))
    hold on
    % Craft initial position
    scatter(Out_O1(1,1),Out_O1(1,2),'filled')
    % Moon path
    plot(Out_O1(:,5),Out_O1(:,6))
    % Moon initial position
    scatter(Out_O1(1,5),Out_O1(1,6),'filled')
    % Plot Earth if craft doesn't hit the moon
    if ie_O1 ~= 1
        viscircles([0,0],rad_E,'Color','b');
    end
    % Plot Moon
    viscircles([ye_O1(5),ye_O1(6)],rad_M,'Color','k');
    legend('Craft path','Craft Initial Position','Moon path',...
        'Moon Initial Position','Location','Best')
    xlabel('X Position [m]')
    ylabel('Y Position [m]')
    title('Trajectories: Objective 1')

%% Objective 2: Minimum return time w/ max delta V constraint
    % Initial search: 10 m/s resolution
        % Use lower bound on delta V_y from Obj 1
            [del_V_vec_O2_1,del_V_O2_1,Time_O2_1] =...
                Grid([-100,100],[Optim_In_O1(2),100],[21,10],2);
            
    % Grab best result from grid
        [~,index_O2_1] = min(Time_O2_1);
      
    % Spiral 1 Step size 2.5
        [del_V_vec_O2S1,del_V_O2S1,Time_O2S1] =...
                    Spiral(del_V_vec_O2_1(index_O2_1,:),2.5,5,2);
                
    % Grab best result from spiral 1
        [~,index_O2S1] = min(Time_O2S1);
        
    % Input to optimizer
        Optim_In_O2 = del_V_vec_O2S1(index_O2S1,:);
        
    % Feeding to fminsearch
    % Set options 
        Opt_min_O2 = optimset('TolX',1e-4,'TolFun',1e-4);
    % Optimize
        [Opt_out_O2,ToFS] = fminsearch(@Opt_O2,Optim_In_O2,Opt_min_O2);
        ToF = sqrt(ToFS);
    % Print reults to command line
    fprintf('\nSolution for Objective 2:\n');
    fprintf('Delta V x-component: %f m/s\n',Opt_out_O2(1));
    fprintf('Delta V y-component: %f m/s\n',Opt_out_O2(2));
    fprintf('Time of Flight: %f hours\n',ToF);
        
%% Plotting solution for objective 1
    % Compute solution with optimal ICs
    [t_O2,Out_O2,te_O2,ye_O2,ie_O2] = Integrator(Opt_out_O2);
    
    figure
    % Craft path
    plot(Out_O2(:,1),Out_O2(:,2))
    hold on
    % Craft initial position
    scatter(Out_O2(1,1),Out_O2(1,2),'filled')
    % Moon path
    plot(Out_O2(:,5),Out_O2(:,6))
    % Moon initial position
    scatter(Out_O2(1,5),Out_O2(1,6),'filled')
    % Plot Earth if craft doesn't hit the moon
    if ie_O2 ~= 1
        viscircles([0,0],rad_E,'Color','b');
    end
    % Plot Moon
    viscircles([ye_O2(5),ye_O2(6)],rad_M,'Color','k');
    legend('Craft path','Craft Initial Position','Moon path',...
        'Moon Initial Position','Location','Best')
    xlabel('X Position [m]')
    ylabel('Y Position [m]')
    title('Trajectories: Objective 2')