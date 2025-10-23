% --- Q7: Compensation du biais du gyromètre ---

% 1. Trouver l'indice jusqu'à 10s (assumant Tcapt est un vecteur colonne ou ligne)
N_10s = find(Tcapt <= 10, 1, 'last');

% 2. Calculer le biais sur les 10 premières secondes
Psip_biais = mean(Psip(1:N_10s));

disp(['Valeur du biais du gyromètre (rad/s) : ', num2str(Psip_biais)]);

% 3. Compenser le signal
Psip_comp = Psip - Psip_biais;

% 4. Tracer les deux signaux
figure;
hold on;
plot(Tcapt, Psip, '.b');
plot(Tcapt, Psip_comp, 'y');
plot([0 max(Tcapt)], [0 0], 'k--'); % Ligne de référence zéro
plot([0 max(Tcapt)], [Psip_biais Psip_biais], 'g--'); % Ligne de référence du biais
title('Vitesse de Lacet (Psip): Biaisée vs. Compensée');
xlabel('Temps (s)');
ylabel('Vitesse de Lacet (rad/s)');
legend('Psip (Biaisé)', 'Psip (Compensé)', 'Zéro de Référence', 'Biais Calculé');
grid on;
hold off;
Psip_biais