clearvars
load("dataGps.mat")

Tgps = dataGps(:,1);
Xgps = dataGps(:,2);
Ygps = dataGps(:,3);
Qgps = dataGps(:,4);
DataOk = dataGps(:,5);

% Vérification de la fréquence d'acquisition GPS
temp = diff(Tgps);
temp(temp == 0) = [];
f = numel(temp) / (max(Tgps) - min(Tgps));

% Déclaration des constantes
Fgps = 10;             % Fréquence du GPS en Hz
Tech = 0.02;           % Période d'acquisition (50 Hz)
x(1) = 0;
y(1) = 0;
phi(1) = -2.18;
x_b(1) = 0;
y_b(1) = 0;
phi_b(1) = -2.18;

% Chargement du plan du circuit
load Circuit_layout_map.mat

x1 = map_bd(:,1);  % Bord droit
y1 = map_bd(:,2);
x2 = map_bg(:,1);  % Bord gauche
y2 = map_bg(:,2);

% === INTERPOLATION DE LA TRAJECTOIRE GPS ===
% On enlève les doublons temporels
[T_unique, idx_unique] = unique(Tgps, 'stable');
X_unique = Xgps(idx_unique);
Y_unique = Ygps(idx_unique);

% On définit un temps régulier pour interpoler
ti = linspace(min(T_unique), max(T_unique), 2000); % 2000 points réguliers

% Interpolation linéaire (ou 'spline' pour plus de lissage)
Xi = interp1(T_unique, X_unique, ti, 'spline');
Yi = interp1(T_unique, Y_unique, ti, 'spline');