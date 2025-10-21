% LOCALISATION D'UN VEHICULE PAR GPS ET CAPTEURS EMBARQUES.
% Nom: 

%IMPORTANT !!!!! LE PRESENT SCRIPT devrait appeller la fonction "fusion"
% ainsi que les fichier de données capteurs "Circuit_layout_map.mat", "dataGps.mat", et "dataCapt.mat". 

%BIEN VOULOIR VERIFIER QUE CES QUATRE (04) FICHIERS SONT PRESENT DANS LE REPERTOIRE
%COURANT AVANT D'EXECUTER CE SCRIPT "Localization_and_Data_Fusion.m"



%DECLARATIONS DES CONSTANTES ET DES VARIABLES (Définitions)

Fgps=10;              % Fréquence du GPS en Hz
Tech=0.02;            % Période l’acquisition (50Hz)

x(1)=0;                % Abscisse initial du véhicule (signal non biaisé)
y(1)=0;                % Ordonnée initiale du véhicule (signal non biaisé)
phi(1)=-2.18;          % Cap initial du véhicule (signal non biaisé) en rad 
x_b(1)=0;              % Abscisse initial du véhicule (signal biaisé)
y_b(1)=0;              % Ordonnée initiale du véhicule (signal biaisé)
phi_b(1)=-2.18;        % Cap initial du véhicule (signal biaisé) en rad




         % ACQUISITION DES SIGNAUX
         
load Circuit_layout_map.mat % Chargement du fichier Circuit_layout_map.mat


%  Coordonnées des accotements droit et gauche du tracé du circuit de Rixheim
x1=map_bd(:,1); % Abscisses bord droit
y1=map_bd(:,2); % Ordonnées bord droit
x2=map_bg(:,1); % Abscisses bord gauche
y2=map_bg(:,2); % Ordonnées bord gauche



         % AFFICHAGE GRAPHIQUE

% Afficharge FIGURE 1: Tracé du circuit
fig001=figure;  % Création figure 001
hold on         %  Maintenir active la figure créée pour ajout de tracés
plot(x1,y1,'y.')% Tracé du bord droit du circuit non interpolé en jaune
plot(x2,y2,'c.')% Tracé du bord gauche du circuit non interpolé en cyan
axis equal;     % Repère orthonormé 
xlabel('x (m)') % Abscisses en metre
ylabel('y (m)') % Ordonnées en metre
title('FIGURE 1: tracé du circuit (Piste de test)') % Titre
legend('bord droit','bord gauche') % Légende

 



