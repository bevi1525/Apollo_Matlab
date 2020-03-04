function [del_V_vec,del_V,Time] = Spiral(Center,Step,Num,Obj)
%Spiral Sets a outward search about zero defined by the inputs
%  Inputs:
%       Center: 2x1 vector, Initial delta V for search
%       Step: Step size for each of x and y
%       Num: Number of steps on each axis
%  Outputs:
%       del_V_vec: Matrix, rows contain the components of delta V applied
%       del_V: Vector, magnitude of delta V applied
%       Time: Vector, time of flight on return to earth (seconds)

% Initialising output vectors
    del_V_vec = [];
    del_V = [];
    Time = [];
    
% Initialising spiral arm beginning
    Node = Center;
    
% Check solution for spiral center
    [~,~,te,~,ie] = Integrator(Center);
        if ie == 2
            del_V_vec = vertcat(del_V_vec,Center);
            del_V = vertcat(del_V,norm(Center));
            Time = vertcat(Time,te);
        end
%% Looping through delta v components
    for i = 1:Num
        s_vec = linspace(1.*Step,i.*Step,i);
        
        % Indices travers in the negative direction
            if mod(i,2) == 0
                s_vec = - s_vec;
            end
            
        % Generate step vectors
            dx = horzcat(s_vec',zeros(i,1));
            dy = horzcat(zeros(i,1),s_vec');
            
        %% Traverse x direction
            for j = 1:i
                In = Node + dx(j,:);
                
                % Attenuate delta V values greater than max capability
                if norm(In) > 100
                    In = 100.*(In./norm(In));
                end
                
            % Differentiate between search objectives
                if Obj == 1 % Objective 1
                    if isempty(del_V) == 0 || norm(In) < del_V

                    % Integrating
                        [~,~,te,~,ie] = Integrator(In);

                    % Assign answer if soln reaches Earth
                        if ie == 2
                            del_V_vec = vertcat(del_V_vec,In);
                            del_V = vertcat(del_V,norm(In));
                            Time = vertcat(Time,te);
                        end
                    end

                else % Objective 2 (Filtering capability is less)

                    % Integrating
                        [~,~,te,~,ie] = Integrator(In);

                    % Assign answer if soln reaches Earth
                        if ie == 2
                            del_V_vec = vertcat(del_V_vec,In);
                            del_V = vertcat(del_V,norm(In));
                            Time = vertcat(Time,te);
                        end
                end
                    
            % Assign new node for next iteration
                if j == i
                    Node = In;
                end
            end
         
        %% Traverse y direction
            for k = 1:i
                In = Node + dy(k,:);
                
                % Attenuate delta V values greater than max capability
                    if norm(In) > 100
                        In = 100.*(In./norm(In));
                    end
                
            % Checking for redundant calc
                if Obj == 1
                    if isempty(del_V) == 0 || norm(In) < del_V 

                        [~,~,te,~,ie] = Integrator(In);

                        if ie == 2
                            del_V_vec = vertcat(del_V_vec,In);
                            del_V = vertcat(del_V,norm(In));
                            Time = vertcat(Time,te);
                        end

                    end
                end

            % Assign new node for next iteration
                if k == i
                    Node = In;
                end
            end
        
    end
    
end