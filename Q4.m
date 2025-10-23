% === Représentation de la qualité GPS ===
figure;
plot(Tgps, Qgps, 'b-', 'LineWidth', 1.5);
xlabel('Temps (s)');
ylabel('Qualité GPS (Qgps)');
title('Évolution de la qualité de réception GPS en fonction du temps');
grid on;
ylim([0 18]);
legend('Note de qualité GPS');

% Mise en évidence des zones de masquage
hold on;
yline(5, 'r--', 'Limite de masquage (Qgps < 5)', 'LabelHorizontalAlignment','left');
