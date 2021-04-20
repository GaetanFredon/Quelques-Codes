clear all;
clc

%% !!!!! Not working yet !!!!!!
% Lance Optim
% 25/02/2020
% function to run Matlab fmincon with safety transformer benchmark
% mono-objective problem solved with MDF formulation
% % xe = [0.0129172;0.0501221;0.0166106;0.0432578;640.771;3.24828e-07;2.91178e-06];

%% Parameters
V2 = 24;                % (V) tension secondaire
V1 = 230;               % (V) tension primaire
f = 50;              	% (Hz) frequence
fp2 = 0.8;              % (-) facteur de puissance secondaire
I2 = 8;                 % (A) courant secondaire
Text = 40;              % (Ã‚Â°C) temperature exterieur
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
%%
lb = [ 3e-3 ; 14e-3 ; 6e-3 ; 10e-3 ; 200 ; 0.15e-6 ; 0.15e-6 ]; % lower bound for a ; b ; c ; d ; n1 , S1 ; S2
ub = [ 30e-3 ; 95e-3 ; 40e-3 ; 80e-3 ; 1200 ; 19e-6 ; 19e-6 ]; % upper bound for a ; b ; c ; d ; n1 , S1 ; S2

%% NSGA
%Nombre d'individus par génération (taille de la population)
nmbOfIndivs = 150;
%Nombre de générations avant l'arret de l'algorithme
nmbOfGens = 100;
%Référence vers la fonction objectif à utiliser (handle matlab :
%@nom_fonction)
Fct = @myfuncontr ;
%Paramètre pour le tirage aléatoire de la première génération
%1 ligne par variable de décision (ici 1)
%Exemple : distribution uniforme (1) dans l'intervalle [-1000;1000]
RandParams = [ones(length(lb),1) lb ub] ;
%Domaine de variation pour chaque variable de décision (ici [-1000;1000])
Ranges = [lb ub];
%Probabilité de croisement (ici 1 : on croise toutes les variables des
%individus
pX = 1;
%Caractéristique de la distribution utilisée pour simuler le croisement
%binaire : plus ce chiffre est grand, plus les enfants générés auront des
%valeurs proches des parents
etaX = 1;
%Probabilité de mutation (taux de la population mutée à chaque génération)
pM=0.1;
%Caractéristique de la distribution utilisée pour la mutation (meme
%comportement que pour le croisement)
etaM=1;
%Set Options fields
Options.SaveDir = 'Test';
%%
%Lancement de l'optimisation
[ParGen, ObjVals,ConstrVals, Ranking, SumOfViols, NmbOfFront] = ...
  NSGA_II( nmbOfIndivs, nmbOfGens, Fct, RandParams, Ranges, ...
  pX, etaX, pM, etaM, Options);

%Affichage de la solution
figure;
%objectifs
for i=1:nmbOfIndivs
%     plot(ObjVals(:,i) , ObjVals(:,i), strcat(couleurs(Ranking(i)),style(NmbOfFront(i))))
plot(ObjVals(1,:),ObjVals(2,:),'o')
    hold on
end
%Changement de la couleur de fond pour améliorer le contraste
% set(gca, 'color', [0.2 0.2 0.2]);
%Affichage de la grille
grid
% exitflag doit etre positif pour avoir un minimum local
%% Nested functions

    function [F, G] = myfuncontr(x)
        
        [F,G]=ObjContrMulti(x);
        
    end
% Objective function
    function f = myfun(x)
        outputs = fct_model_transfo(parameters,x);
%         f = outputs(1); %min(Mtot)
       f = -outputs(2); %max(ren)=min(-ren)
        end
        
% Constraint function
    function [g,h] = mycon(x)
        outputs = fct_model_transfo(parameters,x);
        g = [outputs(3:9)]; %g<0
        h = []; %h=0
    end
