%##########################################################################
%% M2_parameters.m : crfeate gfile with all parameters of M2          #
%       Valentin Bernard, 17/05/2018, Internship GeePs/LadHyX             #
%                                                                         #
%                                                                         #
%   The following additional files are needed:                            #
%   + M2_femm.m                                                         #
%   + Square_coeff_data                                                   #
%                                                                         #
%##########################################################################
clear;

%% Obtain ke and L data
% If the data exists in a file, load it. if not run the femm 
if exist('M2_femm_data.mat', 'file') ~= 2
    run('M2_femm.m');
end
load('M2_femm_data.mat'); position = position/1000;
pos0 = find(position==0); StaticForceY(pos0) = 0;
%% Define variables for Simulink model
% Circuit properies
Ri = 2*266; Rl = 500;
% Aerodynamic parameters (for square section)
load('Square_coeff_data.mat'); Cy_data = -Cl.*cos(angles)-Cd.*sin(angles);
Cy_data = Cy_data(10:40); angles_data = angles(10:40);
Cy_poly= polyfit(angles_data, Cy_data, 7);
angles = linspace(angles_data(1), angles_data(end), 50);
Cy = polyval(Cy_poly, angles);
A = Cy_poly(end-1); % derivatice of Cy-curve in 0
clear('angles_data', 'Cy_data');

Diameter = 0.0171; span = 0.170; angle0 = 0;       % Prism properties
mass = 0.32; f = 5.875; w = 2*pi*f; k = w^2*mass; eta = 0.0019;   % Mass spring damper system
rho = 1.2;
% Non-dimensional parameters
mass_ratio = rho*Diameter^2*span/(2*mass);
Ucrit = 2*eta/mass_ratio/A;   % Critical reduced velocity
Beta = L*w/(Ri+Rl); % Reduced time scale

save('M2_parameters.mat')
