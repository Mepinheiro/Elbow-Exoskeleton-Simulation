% modelParameters_elbow.m
g = 9.81;

% Comprimentos dos segmentos do braço (em metros)
L_upper = 0.30;   % úmero
L_fore = 0.26;    % antebraço

% Centro de massa (posição relativa * comprimento)
Z_upper = 0.436 * L_upper;  % posição do centro de massa do úmero
Z_fore = 0.430 * L_fore;    % posição do centro de massa do antebraço

% Massas dos segmentos (em kg)
M_upper = 1.89;   % massa do úmero
M_fore = 1.12;    % massa do antebraço

% Momento de inércia aproximado (em relação ao centro de massa)
XX_upper = M_upper * (Z_upper)^2;
XX_fore = M_fore * (Z_fore)^2;

% Parâmetros simplificados do modelo dinâmico
D = XX_fore;   % inércia equivalente
C = 0.5;       % termo de Coriolis simplificado

% Aplica incerteza nos parâmetros
    %D = D * (1 + 0.1);
    %C = C * (1 + 0.5);
    %M_fore = M_fore * (1 + 2);
    %Z_fore = Z_fore * (1 + 0.2);

% Parâmetros do motor

Kv_motor = 80;          % [rpm/V]
Kt_motor = 0.11;        % [N.m/A]
R_motor  = 1.8;         % [ohm]
L_motor  = 1.1e-3;      % [H]

%J_rotor = 3.2e-6;       % [kg.m^2]
J_rotor = 3.2e-6;

% Redução interna
N_gear = 36;

% Torque na saída
tau_nominal = 8;        
tau_peak    = 24;       

mass_motor  = 0.340;    % [kg]

% Rigidez do elo elástico
Ks = 150;

% Inércia refletida na saída do redutor
J_motor_out = J_rotor * N_gear^2;    % ~ 4.1472e-3 kg.m^2

% Amortecimento equivalente na saída
B_motor_out = 0.5;      % valor inicial estimado/ajustável



    

 
