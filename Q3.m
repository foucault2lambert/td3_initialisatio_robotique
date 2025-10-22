% === Calculs de base ===
% On suppose que T_unique, X_unique, Y_unique existent (temps et positions sans doublons)

% distances entre points consécutifs (résolution locale)
dx = diff(X_unique);
dy = diff(Y_unique);
d = sqrt(dx.^2 + dy.^2);        % d(i) = distance entre sample i et i+1, taille N-1

% temps entre échantillons
dt = diff(T_unique);            % taille N-1, en secondes (vérifier unité)

% vitesse instantanée (m/s) associée au segment i (entre i et i+1)
v = d ./ dt;                    % taille N-1

% distance cumulée (longueur parcourue)
L = [0; cumsum(d)];             % taille N (on ajoute 0 au début pour aligner)

% temps pour tracer d et v (on centre sur le segment i -> temps moyen)
t_seg = T_unique(1:end-1) + dt/2;

% === Option : moyenne glissante pour lisser la résolution/vitesse ===
win = 5; % fenêtre (en segments)
d_smooth = movmean(d, win);
v_smooth = movmean(v, win);

% === Tracés ===
figure;
subplot(3,1,1);
plot(T_unique, L, '-k', 'LineWidth', 1.2);
xlabel('Temps (s)'); ylabel('Distance cumulée (m)');
title('Distance totale parcourue');
grid on;

subplot(3,1,2);
plot(t_seg, d, '.-b', 'DisplayName', 'Distance segment');
hold on;
plot(t_seg, d_smooth, '-r', 'LineWidth', 1.2, 'DisplayName', sprintf('Moyenne glissante (%d)', win));
xlabel('Temps (s)'); ylabel('Distance entre échantillons (m)');
title('Évolution de la résolution (distance inter-échantillons)');
legend('Location','best'); grid on;

subplot(3,1,3);
plot(t_seg, v, '.-b', 'DisplayName', 'Vitesse instantanée (m/s)');
hold on;
plot(t_seg, v_smooth, '-r', 'LineWidth', 1.2, 'DisplayName','Vitesse lissée');
xlabel('Temps (s)'); ylabel('Vitesse (m/s)');
title('Évolution de la vitesse du véhicule');
legend('Location','best'); grid on;

% === Repérer les pics significatifs (masquage) ===
% seuils (à ajuster selon ton jeu de données)
thresh_d = max(3*median(d(d>0)), 2.0); % distance anormale (m)
thresh_v = 15;                          % vitesse anormale (m/s)

idx_big = find(d > thresh_d | v > thresh_v);
if ~isempty(idx_big)
    % marquer sur les deux graphiques
    subplot(3,1,2); hold on;
    scatter(t_seg(idx_big), d(idx_big), 60, 'm', 'filled', 'DisplayName','Anomalies');
    subplot(3,1,3); hold on;
    scatter(t_seg(idx_big), v(idx_big), 60, 'm', 'filled', 'DisplayName','Anomalies');
end

% Impression console
fprintf('Distance totale parcourue = %.2f m\n', L(end));
fprintf('Nombre de segments = %d, median(d) = %.3f m, seuil_d = %.3f m\n', numel(d), median(d), thresh_d);
if ~isempty(idx_big)
    fprintf('Segments anormaux détectés aux indices (segment):\n');
    disp(idx_big.');
else
    fprintf('Aucun segment anormal détecté avec les seuils actuels.\n');
end
