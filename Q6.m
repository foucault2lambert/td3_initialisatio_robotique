load("dataCapt.mat");  % contient [Tcapt, Vt, Vl, Psip]
Tcapt = dataCapt(:,1);
Vt    = dataCapt(:,2);
Vl    = dataCapt(:,3);
Psip  = dataCapt(:,4);

% Interpolation de la vitesse GPS sur la base de temps des capteurs
v_gps_interp = interp1(t_seg, v, Tcapt, 'linear', 'extrap');

figure;
plot(Tcapt, Vl, '-b', 'DisplayName', 'Vitesse capteur Vl');
hold on;
plot(Tcapt, v_gps_interp, '-r', 'LineWidth', 1.2, 'DisplayName', 'Vitesse GPS interp.');
xlabel('Temps (s)');
ylabel('Vitesse (m/s)');
title('Comparaison vitesse GPS vs capteurs');
legend('Location','best'); grid on;
