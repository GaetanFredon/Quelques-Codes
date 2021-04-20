% Exemple
function NSGA_Exemple3()

%--------------------------------------------------------------------------
%Fonction de test
borne_max=100;
borne_min=0;

%Nombre d'individus par génération (taille de la population)
nmbOfIndivs = 100;
%Nombre de générations avant l'arret de l'algorithme
nmbOfGens = 25;
%Référence vers la fonction objectif à utiliser (handle matlab :
%@nom_fonction)
Fct = @test;
%Paramètre pour le tirage aléatoire de la première génération
%1 ligne par variable de décision (ici 1)
%Exemple : distribution uniforme (1) dans l'intervalle [0;20]
RandParams = [1 borne_min borne_max; 1 borne_min borne_max];
%Domaine de variation pour chaque variable de décision (ici [0;20])
Ranges = [borne_min borne_max;borne_min borne_max];
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


%Lancement de l'optimisation
[ParGen, ObjVals, Ranking, SumOfViols, NmbOfFront] = ...
  NSGA_II( nmbOfIndivs, nmbOfGens, Fct, RandParams, Ranges, ...
  pX, etaX, pM, etaM, 'Resultats');


Meilleur_individu = ParGen(:, find(Ranking==1) )

Pertes = ObjVals(:,find(Ranking==1))

Couple = Meilleur_individu(1,:).*Meilleur_individu(2,:)

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Fonction objectif
%--------------------------------------------------------------------------

%Fonction x²+y²
%x dans [0 20] y dans [0 20]
%Contrainte xy >= 10
function [ObjVals,ConstrVals]=test(Indivs)

%Calcul de la valeur de l'objectif
ObjVals(1,:) = Indivs(1,:).^2+Indivs(2,:).^2;

%Contrainte
ConstrVals(1,:)=(10)-Indivs(1,:).*Indivs(2,:);


