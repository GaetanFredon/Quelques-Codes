%Main pour le TD

clear all, close all, clc

%% Parameters
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
parameters=[V2,V1,f,fp2,I2,Text,q,kr,h,lambda_iso,e_iso,mvfer,mvcuivre,rhocuivre,alphacuivre,mu0]
%% Variables

a = 0.013; % (m) largeur noyau lateral
b = 0.042; % (m) hauteur fenetre
c = 0.022; % (m) largeur fenetre
d = 0.022; % (m) epaisseur noyau
n1 = 945; % (-) nombre de tour primaire
S1 = 1.9e-6; % (m2) section de fil primaire
S2 = 16.9e-6; % (m2) section de fil secondaire
variables=[a,b,c,d,n1,S1,S2]

% lower bound and upper bound 
lb = [3e-3, 14e-3, 6e-3, 10e-3, 200, 0.15e-6, 0.15e-6]; % lower bound for [a; b; c; d; n1; S1; S2]
ub = [30e-3, 95e-3, 40e-3, 80e-3, 1200, 19e-6, 19e-6]; % upper bound for [a; b; c; d; n1; S1; S2]
variables = lb + rand(size(lb)).*(ub-lb);
%% Evaluate transfo
outputs=fct_model_transfo(parameters,variables);
outputs'