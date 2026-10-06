% Modelo baseado na estrutura da simulação (motor + mola + carga)

modelParameters_elbow;

% --- Parametros equivalentes do atuador AK45-36 KV80 ---
% J_rotor = 32 g*cm^2 = 3.2e-6 kg.m^2
% Relacao de reducao N = 36:1

% Inercia refletida na saida: J_motor_out = J_rotor * N^2 ~= 4.15e-3 kg.m^2
J_motor_out = J_rotor * N_gear^2;
Jeq = J_motor_out;

Beq = B_motor_out;

% Termo pequeno de regularizacao
K_eps = 0.001;

% G1 - dinâmica principal do atuador
G1 = tf(1, [Jeq Beq K_eps]);
[num1, den1] = tfdata(G1, 'v');
[A1, B1, C1, D1] = tf2ss(num1, den1);
sys1 = ss(A1, B1, C1, D1);

% G2 - efeito do elo elástico em série
G2 = tf(-[Jeq/Ks Beq/Ks 1], [Jeq Beq K_eps]);
[num2, den2] = tfdata(G2, 'v');
[A2, B2, C2, D2] = tf2ss(num2, den2);
sys2 = ss(A2, B2, C2, D2);

% Modelo total em paralelo
sys = parallel(sys1, sys2, [], [], 1, 1);
sys = minreal(sys);

% Matrizes finais 
% para uso no controle
[A, B, C, D] = ssdata(sys);

