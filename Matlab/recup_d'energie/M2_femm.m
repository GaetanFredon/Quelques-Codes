%##########################################################################
%% MLHX_femm.m : FEMM model for first new harvester proposed              #
%       Valentin Bernard, 24/04/2018, Internship GeePs/LadHyX             #
%                                                                         #
%   This code characterizes a magnet-coil-assembly that could be used     #
%   in a galloping energy harvester in terms of its ke(y) characteristic  #
%                                                                         #
%   The following additional function files are needed:                   #
%   + drawRectangle.m                                                     #
%                                                                         #
%   A working installation of femm must exist to run this model           #
%                                                                         #
%##########################################################################


%% Define variables -------------------------------------------------------
% Core:
h_core = 32.2;  % core lenght
l_core = 23.5;  % lenght of core
w_core = 9;     % width of core
d_core = 4.5;   % flux conductor width
mat_core = 'M-19 Steel'; % core material
% Incuctor
gap_coil = 1;    % thichness of plastic
l_coil = 16;    % coil length
N = 2000;       % coil number of windings
d_wire = 0.23;  % coil wire thickness
mat_coil = 'Cu';% coil material
s_coil = (h_core/2-2*d_core-gap_coil);     % coil thickness
I_test = 0.1;        % Current used for L measurement
% Magnets
Hc = 155319 * sqrt(45); % NdFrB N45 Permanent magnets
gap = 1;      % gap between end of coil and magnets
w_mag = 10;  h_mag = 4.5; l_mag = 3; % geometry of magnet
mat_mag = 'NdFeB N45'; % magnet material



%% Create FEMM file for ke -------------------------------------------- 
addpath('C:\femm42\mfiles');
openfemm();
newdocument(0);
mi_saveas('Model2.fem'); 
%--------------------------------------------------------------------------
% Definition of problem type 
%(Magnetostatic; uinits in mm; planar; Precision of 10^(-8) for the linear solver)
mi_probdef(0, 'millimeters', 'planar', 1.e-8, 9, 30);

%% Define Materials ------------------------------------------------------
%% From library
mi_getmaterial('Air');
mi_getmaterial('M-19 Steel');
mi_addmaterial('NdFeB N45', 1.05, 1.05, Hc, 0, 0, 0, 0, 1, 0, 0, 0); 
mi_addmaterial('Cu',1,1,0,0,0,0,0,0,0,0,0,0,0);

%% Define Circuits --------------------------------------------------------
mi_addcircprop('coil',0,1);

%% Draw geometry ---------------------------------------------------------
shift = l_core+2*gap+l_mag;
% Core
drawRectangle(0, -h_core/2, l_core, h_core,0);
drawRectangle(shift, -h_core/2, l_core, h_core,0);
mi_addblocklabel(l_core/2, 0);
mi_addblocklabel(l_core/2+shift, 0);
mi_selectlabel(l_core/2, 0);
mi_selectlabel(l_core/2+shift, 0);
mi_setblockprop(mat_core,0,1,'<None>',0,0,0);
mi_clearselected;
drawRectangle(d_core, d_core , l_core-d_core, h_core/2-2*d_core,0);
drawRectangle(d_core,-h_core/2+d_core , l_core-d_core, h_core/2-2*d_core,0);
drawRectangle(shift, d_core , l_core-d_core, h_core/2-2*d_core,2);
drawRectangle(shift,-h_core/2+d_core , l_core-d_core, h_core/2-2*d_core,0);
mi_selectsegment(l_core, h_core/4);
mi_selectsegment(l_core, -h_core/4);
mi_selectsegment(shift, h_core/4);
mi_selectsegment(shift, -h_core/4);
mi_deleteselected;
mi_clearselected;

% Inductor
drawRectangle(d_core + gap_coil, d_core + gap_coil , l_coil, s_coil, 0);
drawRectangle(d_core + gap_coil, -h_core/2 +d_core, l_coil, s_coil, 0);
drawRectangle(shift + l_core - d_core - gap_coil-l_coil, d_core + gap_coil , l_coil, s_coil, 0);
drawRectangle(shift + l_core - d_core - gap_coil-l_coil, -h_core/2 +d_core, l_coil, s_coil, 0);
mi_addblocklabel(d_core + gap_coil + l_coil/2, d_core + gap_coil + s_coil/2);
mi_addblocklabel(d_core + gap_coil + l_coil/2 , -h_core/2 + d_core + s_coil/2);
mi_addblocklabel(shift+l_coil/2, d_core + gap_coil + s_coil/2);
mi_addblocklabel(shift+l_coil/2, -h_core/2 + d_core + s_coil/2);
mi_selectlabel(d_core + gap_coil + l_coil/2, d_core + gap_coil + s_coil/2);
mi_selectlabel(shift+l_coil/2, d_core + gap_coil + s_coil/2);
mi_setblockprop(mat_coil,0,1,'coil',0,2,N);
mi_clearselected;
mi_selectlabel(d_core + gap_coil + l_coil/2 , -h_core/2 + d_core + s_coil/2);
mi_selectlabel(shift+l_coil/2, -h_core/2 + d_core + s_coil/2);
mi_setblockprop(mat_coil,0,1,'coil',0,2,-N);
mi_clearselected;

% Draw second half

% Air
drawRectangle(-80,-90,  200, 180, 0)
mi_addblocklabel(-1, 0);
mi_selectlabel(-1, 0);
mi_setblockprop('Air',0,1,'<None>',0,0,0);
mi_clearselected;
mi_addboundprop('Dirichlet',0,0,0,0,0,0,0,0,0);   % Add boundary conditions
mi_selectsegment(0,-90);
mi_selectsegment(0,90);
mi_selectsegment(-80,0 );
mi_selectsegment(120,0);
mi_setsegmentprop('Dirichlet',0,1,0,6);
mi_clearselected;
mi_zoomnatural; % Adjust zoom

%% Get inductance
mi_modifycircprop('coil',1, 0.1);
mi_analyze(1);
mi_loadsolution;
prop = mo_getcircuitproperties('coil');
L = prop(3)/prop(1);
mi_modifycircprop('coil', 1,0)
%%

% Magnets
drawRectangle(l_core + gap, h_core/2-h_mag, l_mag, h_mag,1);
drawRectangle(l_core + gap, -h_mag, l_mag, h_mag*2,1);
drawRectangle(l_core + gap, -h_core/2, l_mag, h_mag,1);
mi_addblocklabel(l_core + gap + l_mag/2, h_core/2-h_mag/2);
mi_addblocklabel(l_core + gap + l_mag/2, 0);
mi_addblocklabel(l_core + gap + l_mag/2, -h_core/2+h_mag/2);
mi_selectlabel(l_core + gap + l_mag/2, h_core/2-h_mag/2);
mi_selectlabel(l_core + gap + l_mag/2, -h_core/2+h_mag/2);
mi_setblockprop(mat_mag,0,1,'<None>',180,1,0);
mi_clearselected;
mi_selectlabel(l_core + gap + l_mag/2,0);
mi_setblockprop(mat_mag,0,1,'<None>',0,1,0);
mi_clearselected;
mi_saveas('Model2.fem');


%% Solve model -----------------------------------------------------------
mi_saveas('temp.fem');
% Define magnet motion and tim step
n = 50;     % number of motion steps
range = 40; % motion range in mm
dy = range/n;
mi_clearselected();
Flux = zeros(1,n);
Position = zeros(1,n);
StaticForceX = zeros(1,n);
StaticForceY = zeros(1,n);
% loop over the various positions
for i = 1:n
    mi_analyze(1);
    mi_loadsolution;
    prop = mo_getcircuitproperties('coil');
    Flux(i) = prop(3);
    Position(i) = dy*(i-1);
    mo_selectblock(l_core + l_mag, Position(i));
    mo_selectblock(l_core + l_mag, Position(i) + h_core/2 - 1);
    mo_selectblock(l_core + l_mag, Position(i)- h_core/2 + 1);
    StaticForceX(i) = mo_blockintegral(18);   
    StaticForceY(i) = mo_blockintegral(19);
    mi_selectgroup(1);
    mi_movetranslate(0,dy);
    mi_clearselected();
end
Flux = [flip(Flux(2:end)), Flux];
Position = [-1*flip(Position(2:end)), Position];
StaticForceX = [flip(StaticForceX(2:end)), StaticForceX];
StaticForceY = [-flip(StaticForceY(2:end)), StaticForceY];
delete('temp.fem');
delete('temp.ans');

%% Elaborate results -----------------------------------------------------
ke = 1000*diff(Flux)./dy; %Coupling coefficient
position = Position(2:end);
StaticForceY = StaticForceY(2:end); StaticForceX = StaticForceX(2:end); 
save('M2_femm_data','ke', 'position','L','StaticForceX', 'StaticForceY');

close all
figure()
plot(position*1000, ke);
xlabel('position of magnet in mm');
ylabel('Coupling coefficnient ke');
title('Result for coupling coefficient ke');
grid on
axis on