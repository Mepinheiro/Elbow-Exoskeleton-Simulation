% elbow_model.m — versão com elo flexível (motor + carga com mola)

%function [dx, tau_pac, tau_r] = elbow_model(t, x, xd)
function [dx, tau_pac, tau_r, tau_l] = elbow_model(t, x, xd)
   
    global Kpac Bpac Kr Br Ks mode_controlador

    modelParameters_elbow;

    % Estados:
    q_m  = x(1);   % posição do motor
    dq_m = x(2);   % velocidade do motor
    q_l  = x(3);   % posição da carga (braço)
    dq_l = x(4);   % velocidade da carga

    qd = xd(1);    % posição desejada
    dqd = xd(2);   % velocidade desejada

    % Parâmetros do modelo com elo flexível
    Jm = J_motor_out;     % inércia do motor
    Bm = B_motor_out;     % atrito do motor
    Jl = D;               % inércia do braço
    Bl = C;               % atrito do braço

    % Torque do paciente (PD sobre o braço)
    tau_pac = Kpac * (qd - q_l) - Bpac * dq_l;
    
    persistent K1_d K2_d K3_d xK1 xK2 xK3
if isempty(K1_d)
    S = load('controladores_discretos.mat');
    K1_d = S.K1_d;
    K2_d = S.K2_d;
    K3_d = S.K3_d;
    xK1 = zeros(size(K1_d.A,1),1);
    xK2 = zeros(size(K2_d.A,1),1);
    xK3 = zeros(size(K3_d.A,1),1);
end

% Erros e entradas
erro1 = qd - q_l;
%u2 = Ks * (q_m - q_l);

u3 = qd;
tau_l = Ks * (q_m - q_l);
u2 = tau_l;

% K1 - discreto
xK1 = K1_d.A * xK1 + K1_d.B * erro1;
u_K1 = K1_d.C * xK1 + K1_d.D * erro1;

% K2 - discreto
xK2 = K2_d.A * xK2 + K2_d.B * u2;
u_K2 = - (K2_d.C * xK2 + K2_d.D * u2);

% K3 - discreto
xK3 = K3_d.A * xK3 + K3_d.B * u3;
u_K3 = K3_d.C * xK3 + K3_d.D * u3;

% Torque total aplicado
switch mode_controlador
    case 1  % PD não robusto
         tau_r = Kr * (qd - q_m) - Br * dq_m;
         %tau_r = Kr * (qd - q_l) - Br * dq_l + u2;
    case 2  % K1
        tau_r = u_K1;
    case 3  % K1 + K2
        tau_r = u_K1 + u_K2;
    case 4  % K1 + K2 + K3
        tau_r = u_K1 + u_K2 + u_K3;
end

% Saturação de torque
%tau_r = max(min(tau_r, 20), -20);
tau_r = max(min(tau_r, tau_peak), -tau_peak);

% Gravidade
G = M_fore * g * Z_fore * sin(q_l);

% Dinâmica com elo flexível
ddq_m = (1/Jm) * (-Bm * dq_m - Ks * (q_m - q_l) + tau_r);
ddq_l = (1/Jl) * (-Bl * dq_l - Ks * (q_l - q_m) - G + tau_pac);
dx = [dq_m; ddq_m; dq_l; ddq_l];

end
