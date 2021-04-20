function [outputs]=femm_axisym_trace(variables)

global eps
%% Définition du problème

newdocument(0);
mi_probdef(0,'centimeters','axi',1e-8,0,30,0);

%% Constantes

mu = 352;
Sig = 53.9;

%% Dimensions

r_dom = 8;     %rayon du domaine (boule) 
r_mag =variables(1);       %rayon de l'aimant
h_mag = variables(2);       %hauteur de l'aimant
h_fer = 10;      %hauteur du fer
e_fer = 1;     %�paisseur du fer
h_coil = 8;      %hauteur de la bobine
e_coil =  1.4;   %�paisseur de la bobine
i_coil = 0;     %courant dans la bobine
e_guide = 0.2;    %�paisseur de l'entrefer
n = 1491;        %nbr de tours de bobine
eps_bord = 0.1;
e_entrefer = 1e-2;
%% Géométries

geo_mag = [0, -h_mag/2
    r_mag, -h_mag/2
    r_mag, h_mag/2
    0, h_mag/2];
label_mag = [r_mag/2, 0];

geo_guide = [r_mag+e_entrefer, -h_fer/2
    r_mag+e_entrefer, h_fer/2
    r_mag+e_guide+e_entrefer, h_fer/2
    r_mag+e_guide+e_entrefer, -h_fer/2];
label_guide = [r_mag+e_entrefer + e_guide/2, 0];

geo_coil = [r_mag+e_entrefer+e_guide, -h_coil/2
    r_mag+e_entrefer+e_guide+e_coil, -h_coil/2
    r_mag+e_entrefer+e_guide+e_coil, h_coil/2
    r_mag+e_entrefer+e_guide, h_coil/2];
label_coil = [r_mag+e_entrefer + e_guide + e_coil/2, 0];

geo_fer = [r_mag+e_entrefer+e_guide, -h_fer/2
    r_mag+e_entrefer+e_guide+e_coil+e_fer, -h_fer/2
    r_mag+e_entrefer+e_guide+e_coil+e_fer, h_fer/2
    r_mag+e_entrefer+e_guide, h_fer/2
    r_mag+e_entrefer+e_guide, h_coil/2
    r_mag+e_entrefer+e_guide+e_coil, h_coil/2
    r_mag+e_entrefer+e_guide+e_coil, -h_coil/2
    r_mag+e_entrefer+e_guide, -h_coil/2];
label_fer = [r_mag+e_entrefer+e_guide+e_coil+e_fer/2, 0];

%% Matériaux

mi_addmaterial('Air' ,1,1,0,0,0,0,0,1,0,0,0);

mat_guide = 'Aluminium';
mi_addmaterial(mat_guide,1,1,0,0,0,0,0,1,0,0,0);

mat_mag = 'Aimant';
mi_addmaterial(mat_mag, 1.05, 1.05, 1006182,0,0,0,0,1,0,0,0);

mat_fer = 'Tole';
mi_addmaterial(mat_fer ,mu,mu,0,0,0,0,0,1,0,0,0);

mat_coil = 'Cuivre';
surface = pi*((r_mag+e_coil+e_fer+e_guide)^2-(r_mag+e_guide+e_fer)^2);
Dwire = 2*sqrt(surface/pi);
mi_addmaterial(mat_coil,1,1,0,0,Sig,0,0,0,3,0,0,1,Dwire);


%% Circuit électrique

mi_addcircprop('Coil', i_coil, 1);

%% Tracé des limites

mi_addboundprop('Bound', 0, 0, 0, 0, 0, 0, 0, 0, 0);

mi_drawline(0,-r_dom,0,r_dom);
mi_drawarc(0,-r_dom,0,r_dom,180,20);
mi_selectsegment(0,-r_dom);
mi_setsegmentprop('Bound', 20, 1, 0, 3);
mi_selectarcsegment(0,-r_dom);
mi_setarcsegmentprop(20, 'Bound', 0, 3);

mi_addblocklabel(eps_bord, -r_dom+1);
mi_selectlabel(eps_bord, -r_dom+1);
mi_setblockprop('Air',1,0,0,0,3,0);
mi_clearselected;


%% Tracé guide
mi_drawpolygon(geo_guide);
mi_addblocklabel(label_guide(1), label_guide(2));
mi_selectlabel(label_guide(1), label_guide(2));
mi_setblockprop(mat_guide,1,0,0,0,2,0);
mi_clearselected;

%% Tracé bobine
mi_drawpolygon(geo_coil);
mi_addblocklabel(label_coil(1),label_coil(2));
mi_selectlabel(label_coil(1),label_coil(2));
mi_setblockprop(mat_coil,1,0,'Coil',0,2,n);
mi_clearselected;

%% Tracé fer
mi_drawpolygon(geo_fer);
mi_addblocklabel(label_fer(1), label_fer(2));
mi_selectlabel(label_fer(1), label_fer(2));
mi_setblockprop(mat_fer,1,0,0,90,2,0);
mi_clearselected;

%% Tracé de l'aimant

mi_drawpolygon(geo_mag);
nsize = size(geo_mag);

for i=1:nsize(1)
    mi_selectnode(geo_mag(i,1), geo_mag(i,2));
end
mi_setnodeprop(0,1);

for i=1:nsize(1)-1
    mi_selectsegment((geo_mag(i,1)+geo_mag(i+1,1))/2,(geo_mag(i,2)+geo_mag(i+1,2))/2);
end
mi_selectsegment((geo_mag(nsize(1),1)+geo_mag(1,1))/2,(geo_mag(nsize(1),2)+geo_mag(1,2))/2);
mi_setsegmentprop(0,0,1,0,1);

mi_addblocklabel(label_mag(1), label_mag(2));
mi_selectlabel(label_mag(1), label_mag(2));
mi_setblockprop(mat_mag,1,0,0,90,1,0);
mi_clearselected;




%% Résolution
% Sauvegarde
    mi_saveas('test1.fem');
% Affichage complet
    mi_zoomnatural;
% Résolution et chargement des résultats
    mi_analyze(1);
    mi_loadsolution;

%% Get inductance
mi_modifycircprop('Coil',1, 0.1);
mi_analyze(1);
mi_loadsolution;
prop = mo_getcircuitproperties('Coil');
L = prop(3)/prop(1);
mi_modifycircprop('Coil', 1,0);

    

    
%% Solve model -----------------------------------------------------------
mi_saveas('temp.fem');
% Define magnet motion and tim step
n1 = 7;     % number of motion steps
range = h_mag/2; % motion range in mm
dy = range/n1;
mi_clearselected();
Flux = zeros(1,n1);
Position = zeros(1,n1);
StaticForceX = zeros(1,n1);
StaticForceY = zeros(1,n1);
% loop over the various positions
for i = 1:n1
    mi_analyze(1);
    mi_minimize();
    mi_loadsolution;
    prop = mo_getcircuitproperties('Coil');
    Flux(i) = prop(3);
    Position(i) = dy*(i-1);
%     mo_selectblock(l_core + l_mag, Position(i));
%     mo_selectblock(l_core + l_mag, Position(i) + h_core/2 - 1);
%     mo_selectblock(l_core + l_mag, Position(i)- h_core/2 + 1);
%     StaticForceX(i) = mo_blockintegral(18);   
%     StaticForceY(i) = mo_blockintegral(19);
    mi_selectgroup(1);
    mi_movetranslate(0,dy);
    mi_clearselected();
end
Flux = [flip(Flux(2:end)), Flux];
Position = [-1*flip(Position(2:end)), Position];
StaticForceX = [flip(StaticForceX(2:end)), StaticForceX];
StaticForceY = [-flip(StaticForceY(2:end)), StaticForceY];


%% Elaborate results -----------------------------------------------------
rho_fer = 7.874e-3; %7.874 g/cm3
rho_cuivre = 8.96e-3; %8.96 g/cm3
rho_alu = 2.7e-3; %2.7 g/cm3
rho_mag = 7.5e-3; %7.3-7.7 g/cm3
m_mag = rho_mag * h_mag * r_mag^2 * pi;
m_alu = ((r_mag+e_guide+e_entrefer)^2-(r_mag+e_entrefer)^2)*pi*h_fer * rho_alu;
%m_cuivre = ((r_mag+e_entrefer+e_guide+e_coil)^2-(r_mag+e_entrefer+e_guide)^2)*pi*h_coil * rho_cuivre;
m_fer = ( ((r_mag+e_entrefer+e_guide+e_coil+e_fer)^2-(r_mag+e_entrefer+e_guide+e_coil)^2)*pi*h_fer + ((r_mag+e_entrefer+e_guide+e_coil)^2-(r_mag+e_entrefer+e_guide)^2)*pi*(h_fer-h_coil) )*rho_fer;

Surface_cu = ((r_mag+e_entrefer+e_guide+e_coil)^2-(r_mag+e_entrefer+e_guide)^2)*pi ;
%supposons que la surface est occup� � 50% cuivre  = n*Scuivre < = 1*Surface
Sfil = 0.1*0.1 ;
 
m_cuivre = n*Sfil*h_coil* rho_cuivre;  %moitie bob
outputs(1)=  m_mag + m_alu + m_cuivre + m_fer;

ke = 100*diff(Flux)./dy; %Coupling coefficient
position = Position(2:end);
StaticForceY = StaticForceY(2:end); StaticForceX = StaticForceX(2:end); 
save('M2_femm_data','ke', 'position','L','StaticForceX', 'StaticForceY');
outputs(2)=-max(abs(ke));
outputs(3)=h_coil - h_fer +0.1;
outputs(4)= n*Sfil-Surface_cu;
outputs(5)=outputs(1)-eps

% figure()
% plot(position*10, ke);
% xlabel('position of magnet in mm');
% ylabel('Coupling coefficnient ke');
% title('Result for coupling coefficient ke');
% grid on
% axis on
end