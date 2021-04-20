%Script d'analyse de la convergence
%Représentation de la population dans l'espace des objectifs à chaque
%génération.

clear

%Récupération du nombre de générations
Resultat_final = load('sauve\Resultat.mat');
nmbOfGens = Resultat_final.nmbOfGens;

%Création des noms des variables structures qui recevront les résultats
NomsResultats = genvarname(num2cell(repmat('res',nmbOfGens,1) , 2));

%Initialize color and marker vectors
couleurs = repmat(['b','g','r','c','y','w'],1,ceil(nmbOfGens/6));
%style = repmat(['o' 'x' '+' '*' 's'],1,ceil(nmbOfGens/5));
figure

%Chargement de chaque structure avec le contenu des fichiers archives
MaxObj1 = -Inf;
MinObj1 = +Inf;
MaxObj2 = -Inf;
MinObj2 = +Inf;

for i=1:nmbOfGens
    NomResultat = char(NomsResultats{i});
    NomFichier = strcat('sauve\Result_',sprintf('%d',i));
    commande = strcat(NomResultat,'=load(NomFichier);');
    eval(commande);
    commande = ['MaxObj1 = max(MaxObj1 , max(' NomResultat '.ObjVals(1,:)));'];
    eval(commande);
    commande = ['MaxObj2 = max(MaxObj2 , max(' NomResultat '.ObjVals(2,:)));'];
    eval(commande);
    commande = ['MinObj1 = min(MinObj1 , min(' NomResultat '.ObjVals(1,:)));'];
    eval(commande);
    commande = ['MinObj2 = min(MinObj2 , min(' NomResultat '.ObjVals(2,:)));'];
    eval(commande);
end

for i=1:nmbOfGens
    NomResultat = char(NomsResultats{i});
    %Tracé sur un même graphique dans le plan des objectifs de toutes les
    %générations
    %commande = strcat('plot(',NomResultat,'.ObjVals(1,:),',NomResultat,'.ObjVals(2,:), strcat(couleurs(i),''+''));');
    commande = strcat('plot(',NomResultat,'.ObjVals(1,:),',NomResultat,'.ObjVals(2,:), ''r+'');');
    eval(commande);
    grid
    %Modification du fond pour améliorer le contraste
    set(gca, 'color', [0.2 0.2 0.2]);
    %axis([MinObj1 MaxObj1 MinObj2 MaxObj2])
    xlabel('Objectif 1');
    ylabel('Objectif 2');
    TITLE('Front de Pareto');
    annotation1 = annotation(...
        gcf,'textbox',...
        'Position',[0.8071 0.7984 0.06607 0.0746],...
        'LineStyle','none',...
        'Color',[0.502 0.502 1],...
        'String',{sprintf('%d',i)},...
        'FitHeightToText','on');
    %pause(0.4);
    M(i) = getframe(gcf);
    %Effaçage du numéro de la génération
    delete(annotation1)
end


movie2avi(M,'convergence','compression','None','FPS',2);

