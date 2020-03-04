function [del_V_vec,del_V,Time] = Grid(X_b,Y_b,Reso,Obj)
%Grid Sets a grid search about zero defined by the inputs
%  Inputs:
%       X_b: 2x1 vector, bounds for search on the x-component of delta V
%       X_b: 2x1 vector, bounds for search on the y-component of delta V
%       Reso: 2x1 vector, sets the number of steps on each axis
%       Obj: Numeric, '1' for objective 1, '2' for objective 2
%  Outputs:
%       del_V_vec: Matrix, rows contain the components of delta V applied
%       del_V: Vector, magnitude of delta V applied
%       Time: Vector, time of flight on return to earth (seconds)

% Defining vectors for each component
    x_axis = linspace(X_b(1),X_b(2),Reso(1));
    y_axis = linspace(Y_b(1),Y_b(2),Reso(2));

% Looping through delta v components
%   i: x component
%   j: y component

% Initialising output vectors
    del_V_vec = [];
    del_V = [];
    Time = [];

% Looping
    for i = 1:Reso(1)
        for j = 1:Reso(2)
            In = [x_axis(i),y_axis(j)];
                % Attenuate delta V values greater than max capability
                if norm(In) > 100
                    In = 100.*(In./norm(In));
                end
                
            if Obj == 1 % Objective 1
                if isempty(del_V) == 1 || norm(In) < del_V

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
        end
    end
end
