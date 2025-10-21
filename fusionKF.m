% FONCTION PERMETTANT DE FOURNIR LA REPONSE DU FILTRE DE KALMAN
%REDIGE PAR GILLES TAGNE 13-11-2008

function [Xest, Yest] = fusionKF(dataGps, dataCapt) % Définition de la fonction fusion 


% DECLARATIONS
% Création des vecteurs Tgps, Xgps, Ygps, Qgps et DataOk
Tgps=dataGps(:,1);  % Extraction de la 1ere colonne de dataGps Base de temps du GPS
Xgps=dataGps(:,2);  % Extraction de la 2eme colonne de dataGps Abscisse de la position véhicule
Ygps=dataGps(:,3);  % Extraction de la 3eme colonne de dataGps Ordonnée de la position véhicule
Qgps=dataGps(:,4);  % Extraction de la 4eme colonne de dataGps Note de qualité du GPS
DataOk=dataGps(:,5); % Extraction de la 5eme colonne de dataGps Indicateur de réception d’une nouvelle donnée GPS

% Création des vecteurs Tcapt, Vt, Vl et Psip 
Tcapt=dataCapt(:,1);  % Extraction de la 1ere colonne de dataCapt Base de temps des mesures capteurs (en s)
Vt=dataCapt(:,2);     % Extraction de la 2eme colonne de dataCapt Vitesse transversale du véhicule (en m/s)
Vl=dataCapt(:,3);     % Extraction de la 3eme colonne de dataCapt Vitesse longitudinale du véhicule (en m/s)
Psip=dataCapt(:,4);   % Extraction de la 4eme colonne de dataCapt Vitesse de lacet du véhicule (en rad/s)

% Définition des constantes du filtre
Q=[0.001 0 0;0 0.001 0;0 0 0.0001*pi/180]; % Matrice Q des bruits du modèle
Rgps=[0.015^2 0;0 0.015^2];  % Matrice des bruits de mesure du GPS
Rpro=[8*10^-7 0 0;0 7.96*10^-7 0;0 0 4.17*10^-6]; % Matrice des bruits de mesure des capteurs proprioceptifs
C=[1 0 0;0 1 0]; % Matrice d'observation reliant les mesures GPS au vecteur d'état X(x,y,phi)
P=[Rgps(1,1) 0 0;0 Rgps(2,2) 0;0 0 pi/3];  % Matrice d'incertitude
Xest(2)=Xgps(2);
Yest(2)=Ygps(2);
phi(1)=-2.18;         % Cap du véhicule 
Tech=0.02;            % Période l’acquisition (50Hz)


% compensation de Psip
val_moy_biais=mean(Psip(1:500,1));  % Valeur moyenne de l'écart par rapport à 0
Psip_comp=Psip-val_moy_biais;       % Psip compensé


% Phase de Prédiction du filtre
for n=2:length(Psip) % Pour n allant de 2 à la fin(Taille des vecteurs)
    % Calcul de A et B
    A=[1 0 (-Tech*((Vt(n-1))*(cos(phi(n-1)))+(Vl(n-1))*(sin(phi(n-1)))));0 1 (Tech*((Vl(n-1))*(cos(phi(n-1)))-(Vt(n-1))*(sin(phi(n-1)))));0 0 1];
    B=[(Tech*(cos(phi(n-1)))) (-Tech*(sin(phi(n-1)))) 0;(Tech*(sin(phi(n-1)))) (Tech*(cos(phi(n-1)))) 0;0 0 (Tech)];

    % Prédiction des états X du modèle d’évolution 
    Xest(n)=Xest(n-1)+Tech*(Vl(n-1)*cos(phi(n-1))-Vt(n-1)*sin(phi(n-1)));
    Yest(n)=Yest(n-1)+Tech*(Vl(n-1)*sin(phi(n-1))+Vt(n-1)*cos(phi(n-1)));
    phi(n)=phi(n-1)+Tech*Psip_comp(n-1);
    X=[Xest(n),Yest(n),phi(n)]'; % Definition de X

    % Calcul de la matrice de covariance de la prédiction
    P=A*P*(A')+B*Rpro*(B')+Q;

    % Phase de correction
    if (DataOk(n)~=DataOk(n-1)&(Qgps(n)>=15)) % Si nouvelle localisation GPS valide (ie variation de DataOk et Qgps=18
        % Calcul du gain de Kalman
        K=P*(C')*(inv([C*P*(C')+Rgps]));
        % Définition d'un vecteur des mesures GPS
        mesure_gps=[Xgps(n);Ygps(n)];
        % Correction de la prédiction des états
        X=X+K*(mesure_gps-C*X);
        % Correction de la matrice de covariance
        I=[1 0 0;0 1 0;0 0 1]; % Matrice identité
        P=(I-K*C)*P;
        % Enregistrements
        Xest(n)=Xgps(n);
        Yest(n)=Ygps(n);
    end;
end;
