%% entete
function [f, g, h] = ObjContrMulti(x)
%% variables x

% x = [0.0248;0.0802;0.0125;0.0187;1021;1.22e-05;4.54e-07] ;
% x = [0.0248;0.0802;0.0125;0.0187;1021;1.22e-05;4.54e-07] ;

 a = x(1) ; %largeur noyau lateral
 b = x(2) ; % hauteur fenetre
 c = x(3) ; % largeur fenetre
 d = x(4) ;
 n1 = x(5) ;
 S1fil = x(6) ;
 S2fil = x(7) ;

%% declaration des parametres
% parametres

V2 = 24;                % (V) tension secondaire
V1 = 230;               % (V) tension primaire
f = 50;              	% (Hz) frequence
fp2 = 0.8;              % (-) facteur de puissance secondaire
I2 = 8;                 % (A) courant secondaire
Text = 40;              % (Â°C) temperature exterieur
q = 1;                  % (W/kg) qualite de tole
kr = 0.5;               % (-) Coefficient de remplissage des encoches
h = 10;            	% (W/m2/K) coefficient de convection de l'air
lambda_iso = 0.15;      % (W/m/K) coefficient de conduction de l'isolant
e_iso = 1e-3;           % (m) epaisseur de l'isolant
mvfer = 7800;           % (kg/m3) masse volumique du fer
mvcuivre = 8800;        % (kg/m3) masse volumique du cuivre
rhocuivre = 1.72e-8;    % (ohm.m) resistivite du cuivre
alphacuivre = 3.8e-3;   % (1/K) variation de la resistivite du cuivre
mu0 = 4*pi*1e-7;        % (-) vacuum permeability
parametres = [V2,V1,f,fp2,I2,Text,q,kr,h,lambda_iso,e_iso,mvfer,mvcuivre,rhocuivre,alphacuivre,mu0];
%%
variables = x ;

[outputs] = fct_model_transfo(parametres,variables) ;




%%
f = [outputs(1), outputs(2)] ;

g = [outputs(3) ;
outputs(4) ;
outputs(5) ;
outputs(6) ;
outputs(7) ;
outputs(8) ;
outputs(9)] ;

h = 0 ;








%% declaration du modele de conception

