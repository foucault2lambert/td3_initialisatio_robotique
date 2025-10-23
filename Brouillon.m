% --- Correction de l'orientation des vecteurs ---
Tcapt = Tcapt(:);
Psip = Psip(:);

% --- Recalcul du N_10s ---
% 1. Trouver l'indice jusqu'à 10s (Tcapt est maintenant un vecteur colonne)
% On cherche tous les indices où le temps est <= 10.
Indices_10s = find(Tcapt <= 10);

% 2. Le dernier indice de cette liste est notre N_10s
if isempty(Indices_10s)
    N_10s = 0;
    warning('Aucune donnée de capteur n''est enregistrée avant ou à 10 secondes.');
else
    N_10s = Indices_10s(end);
end

% Vérification après correction
disp(['Nouvelle valeur de N_10s : ', num2str(N_10s)]);

% 3. Extraction et vérification du vecteur
Psip_extract = Psip(1:N_10s);
disp(['Taille du vecteur pour la moyenne (après correction) : ', num2str(length(Psip_extract))]);

% 4. Calcul du biais (maintenant que la taille est > 0)
if N_10s > 0
    Psip_biais = mean(Psip_extract);
    disp(['Valeur du biais du gyromètre (rad/s) : ', num2str(Psip_biais)]);
    
    % Compensation
    Psip_comp = Psip - Psip_biais;

    % ... Poursuivez avec le tracé ...
else
    % Gérer le cas où N_10s est 0 (par exemple, si le fichier est vide)
    Psip_biais = 0;
    Psip_comp = Psip;
end