% Examples
%
% This file shows how to use the algorithm
%
% This file is part of the modified version by G. Robin - 28/09/2004
%
% Copyright (C) 2004 Reiner Schulz (rschulz@cs.umd.edu)
% This file is part of the author's Matlab implementation of the NSGA-II
% multi-objective genetic algorithm with simulated binary crossover (SBX)
% and polynomial mutation operators.
%
% The algorithm was developed by Kalyanmoy Deb et al. 
% For details, refer to the following article:
% Deb, K., Pratap, A., Agarwal, S., and Meyarivan, T. 
% A fast and elitist multiobjective genetic algorithm: NSGA-II.
% in IEEE TRANSACTIONS ON EVOLUTIONARY COMPUTATION, vol. 8, pp. 182-197, 2002
%
% This implementation is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This implementation is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with This implementation; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

% function [ParGen, ObjVals, Ranking, SumOfViols, NmbOfFront] = ...
%   NSGA_II( nmbOfIndivs, nmbOfGens, Fct, RandParams, Ranges, ...
%   pX, etaX, pM, etaM)
function NSGA_NewExamples()

%--------------------------------------------------------------------------
%First example - Schaffer's function

nmbOfIndivs = 26;

%NSGA-II algorithm call
[ParGen, ObjVals, Ranking, SumOfViols, NmbOfFront] = ...
  NSGA_II( nmbOfIndivs, 25, @SchafferObjectiveFun, ...
 repmat( [1 -1000 1000], 10, 1), repmat( [-1000 1000], 10, 1), ...
  1, 1, 0.1, 1);

%Solution display
figure;
%Initialize color and marker vectors
couleurs = repmat(['b','g','r','c','y','w'],1,ceil(nmbOfIndivs/6));
style = repmat(['o' 'x' '+' '*' 's'],1,ceil(nmbOfIndivs/5));
%Plot last generation individuals
for i=1:nmbOfIndivs
    plot(ObjVals(1,i) , ObjVals(2,i), strcat(couleurs(Ranking(i)),style(NmbOfFront(i))))
    hold on
end
%Modify background to improve contrast
set(gca, 'color', [0.2 0.2 0.2]);
%Show grid
grid

%--------------------------------------------------------------------------
%Second example Kursawe's function

nmbOfIndivs = 60;

%NSGA-II algorithm call
[ParGen, ObjVals, Ranking, SumOfViols, NmbOfFront] = ...
  NSGA_II( nmbOfIndivs, 60, @KursaweObjectiveFun, ...
  repmat( [1 5 1], 3, 1), repmat( [-5 5], 3, 1), ...
  1, 1, 0.1, 1);

%Solution display
figure;
%Initialize color and marker vectors
couleurs = repmat(['b','g','r','c','y','w'],1,ceil(nmbOfIndivs/6));
style = repmat(['o' 'x' '+' '*' 's'],1,ceil(nmbOfIndivs/5));
%Plot last generation individuals
for i=1:nmbOfIndivs
    plot(ObjVals(1,i) , ObjVals(2,i), strcat(couleurs(Ranking(i)),style(NmbOfFront(i))))
    hold on
end
%Modify background to improve contrast
set(gca, 'color', [0.2 0.2 0.2]);
%Show grid
grid

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Objective functions
%--------------------------------------------------------------------------

% Schaffer's function for x in [-1000 1000]
function [ObjVals,ConstrVals]=SchafferObjectiveFun(Indivs)

[nmbOfVars nmbOfIndivs] = size( Indivs);

ObjVals = zeros( 2, nmbOfIndivs);
ObjVals( 1, :) = Indivs(1, :).^2;
ObjVals( 2, :) = (Indivs(1, :) - 2).^2;

%No constraints
ConstrVals=zeros(1,nmbOfIndivs);

%--------------------------------------------------------------------------

% Kursawe's function for x in [-5 5]
function [ObjVals,ConstrVals]=KursaweObjectiveFun(Indivs)

[nmbOfVars nmbOfIndivs] = size( Indivs);

ObjVals = zeros( 2, nmbOfIndivs);
ObjVals( 1, :) = sum( -10 * exp( -.2 * ...
    sqrt( Indivs(1:(end -1), :).^2 + Indivs(2:end, :).^2)), 1);
ObjVals( 2, :) = sum( abs( Indivs).^.8 + 5 * sin( Indivs.^3), 1);

%No constraints
ConstrVals=zeros(1,nmbOfIndivs);

%--------------------------------------------------------------------------

% Zitzler's 1st function for x in [0 1]
function [ObjVals,ConstrVals]=Zitzler1ObjectiveFun(Indivs)

[nmbOfVars nmbOfIndivs] = size( Indivs);

ObjVals = zeros( 2, nmbOfIndivs);
ObjVals( 1, :) = sum( -10 * exp( -.2 * ...
    sqrt( Indivs(1:(end -1), :).^2 + Indivs(2:end, :).^2)), 1);
ObjVals( 2, :) = sum( abs( Indivs).^.8 + 5 * sin( Indivs.^3), 1);

%No constraints
ConstrVals=zeros(1,nmbOfIndivs);

%--------------------------------------------------------------------------

% Zitzler's 2nd function for x in [0 1]
function [ObjVals,ConstrVals]=Zitzler2ObjectiveFun(Indivs)

[nmbOfVars nmbOfIndivs] = size( Indivs);

ObjVals = zeros( 2, nmbOfIndivs);
ObjVals( 1, :) = Indivs(1, :);
ObjVals( 2, :) = 1 + 9 * sum( Indivs(2:end, :), 1) ./ (nmbOfVars - 1);
ObjVals( 2, :) = ObjVals( 2, :) .* ...
    (1 - (Indivs(1, :) ./ ObjVals( 2, :)).^2);

%No constraints
ConstrVals=zeros(1,nmbOfIndivs);

%--------------------------------------------------------------------------

% Zitzler's 4th function for x_1 in [0 1] and x_i>1 in [-5 5]
function [ObjVals,ConstrVals]=Zitzler4ObjectiveFun(Indivs)

[nmbOfVars nmbOfIndivs] = size( Indivs);

ObjVals = zeros( 2, nmbOfIndivs);
ObjVals( 1, :) = Indivs(1, :);
ObjVals( 2, :) = 1 + 10 * (nmbOfVars - 1) + sum( Indivs(2:end, :).^2 - 10 * cos( 4 * pi * Indivs(2:end, :)), 1);
ObjVals( 2, :) = ObjVals( 2, :) .* ...
    (1 - sqrt( Indivs(1, :) ./ ObjVals( 2, :)));

%No constraints
ConstrVals=zeros(1,nmbOfIndivs);

