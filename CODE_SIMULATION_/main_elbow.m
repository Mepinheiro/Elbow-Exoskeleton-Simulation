% main_elbow.m — versão com elo flexível (motor + carga), com gráficos atualizados

global Kpac Bpac Kr Br Ks mode_controlador uiControlMode

modelParameters_elbow;

set(0,'Current',graph_interface);

set(graph_interface,'CurrentAxes',theta_axis);
cla;
grid;
xlabel('Tempo (s)');
ylabel('\theta_m e \theta_l (graus)');

set(graph_interface,'CurrentAxes',vel_axis);
cla;
grid;
xlabel('Tempo (s)');
ylabel('Velocidades (graus/s)');

set(graph_interface,'CurrentAxes',tau_axis);
cla;
grid;
xlabel('Tempo (s)');
ylabel('Torques (N.m)');

drawnow
set(graph_interface,'CurrentAxes',movie_axis);

%tfinal = str2double(get(uiTfinal,'String'));
%tfinal = str2double(get(uiTfinal,'String'));
tfinal = 10;

% Parâmetros de simulação
dt = 0.001;
h = dt/2;
max_sample = (tfinal/dt)+1;
t = 0:dt:tfinal;
stop = 0;

% Inicialização dos vetores para 4 estados: [q_m, dq_m, q_l, dq_l]
n = 2;
x = zeros(max_sample, 2*n);
dx = zeros(max_sample, 2*n);
xd = zeros(max_sample, 2);
tau_r = zeros(max_sample, 1);
tau_pac = zeros(max_sample, 1);
tau_l = zeros(max_sample,1);     % torque elástico
e_pos = zeros(max_sample,1);     % erro de posição

% Estado inicial
x(1,:) = [0 0 0 0];

% Trajetória desejada aplicada à carga
%xd(:,1) = (pi/4)*sin(2*pi*0.5*t - 1.5) + (pi/4);
%xd(:,2) = [diff(xd(:,1))'/dt 0];

% ============================================================
% REFERÊNCIA CHIRP PARA VARREDURA EM FREQUÊNCIA

A_ref = deg2rad(20);        % amplitude angular [rad]
offset_ref = deg2rad(45);   % offset angular [rad]

f0 = 0.1;   % frequência inicial [Hz]
f1 = 3.0;   % frequência final [Hz]
% você pode começar com 3 Hz também, se 5 Hz ficar agressivo

xd(:,1) = offset_ref + A_ref * chirp(t, f0, tfinal, f1, 'linear')';
xd(:,2) = [diff(xd(:,1))'/dt 0];
% ============================================================

% Leitura dos ganhos da interface
Kpac = str2double(get(uiControlKpac,'String'));
Bpac = str2double(get(uiControlBpac,'String'));
Kr = str2double(get(uiControlKr,'String'));
Br = str2double(get(uiControlBr,'String'));

mode_controlador = get(uiControlMode, 'Value');  % 1 = PD, 2 = K1, 3 = K1+K2, 4 = K1+K2+K3

drawnow

% Loop principal da simulação
tic;
for j = 1:max_sample-1

    % Integração Runge-Kutta
    %[F1, tau_pac(j), tau_r(j)] = elbow_model(t(j), x(j,:), xd(j,:));
    %F2 = elbow_model(t(j)+h, x(j,:)+h*F1.', xd(j,:));
    %F3 = elbow_model(t(j)+h, x(j,:)+h*F2.', xd(j,:));
    %F4 = elbow_model(t(j)+dt, x(j,:)+dt*F3.', xd(j,:));

    [F1, tau_pac(j), tau_r(j), tau_l(j)] = elbow_model(t(j), x(j,:), xd(j,:));
    F2 = elbow_model(t(j)+h, x(j,:)+h*F1.', xd(j,:));
    F3 = elbow_model(t(j)+h, x(j,:)+h*F2.', xd(j,:));
    F4 = elbow_model(t(j)+dt, x(j,:)+dt*F3.', xd(j,:));
    e_pos(j) = xd(j,1) - x(j,3);

    x(j+1,:) = x(j,:) + (dt/6)*(F1 + 2*F2 + 2*F3 + F4).';
    dx(j+1,:) = (1/6)*(F1 + 2*F2 + 2*F3 + F4).';

    
    % Atualização da animação
    if rem(j, 100) == 0
        set(graph_interface, 'CurrentAxes', movie_axis);
        anim_elbow_meio;
    end

    % Atualização dos gráficos
    if rem(j, 200) == 0
        set(graph_interface,'CurrentAxes',theta_axis);
        plot(t, x(:,1)*180/pi, 'b--', t, x(:,3)*180/pi, 'k-', t, xd(:,1)*180/pi, 'r:','LineWidth', 2);
        legend('\theta_m','\theta_l','\theta_{ref}');
        grid;
        ylabel('\theta_m e \theta_l (degree)');
        axis([0 t(end) -20 120]);
        title(theta_axis, 'Angular Position (\theta_m and \theta_l)')

        set(graph_interface,'CurrentAxes',vel_axis);
        plot(t, x(:,2)*180/pi, 'b--', t, x(:,4)*180/pi, 'k-', t, xd(:,2)*180/pi, 'r:','LineWidth', 2);
        legend('$\dot{\theta}_m$','$\dot{\theta}_l$','$\dot{\theta}_{ref}$', 'Interpreter', 'latex');
        grid;
        ylabel('Velocities (degrees/s)');
        axis([0 t(end) -180 180]);
        title(vel_axis, 'Angular Velocities');

        set(graph_interface,'CurrentAxes',tau_axis);
        plot(t, tau_r, 'b-', t, tau_pac, 'r--', 'LineWidth', 2);
        legend('\tau_{r}','\tau_{pac}');
        grid;
        xlabel('Time (s)'); ylabel('Torques (N.m)');
        %axis([0 t(end) -20 20]);
        axis([0 t(end) -25 25]);
        title(tau_axis, 'Applied Torques');

        drawnow;

        if stop == 1
            break;
        end
    end
end
cpu = toc;

%%% numerical metrics 

j_end = j;

% Conversões para graus (já usados nos gráficos)
theta_ref = xd(:,1) * 180/pi;
theta_l   = x(:,3) * 180/pi;

% Erro de seguimento
erro_theta = theta_ref - theta_l;
rms_error = sqrt(mean(erro_theta.^2));
max_error = max(abs(erro_theta));

% Torque máximo aplicado pelo robô
peak_tau = max(abs(tau_r));

% Exibição no console
fprintf('\n--- Simulation Performance Metrics ---\n');
fprintf('RMS tracking error: %.2f deg\n', rms_error);
fprintf('Max tracking error: %.2f deg\n', max_error);
fprintf('Peak actuator torque: %.2f N·m\n', peak_tau);

figure;
subplot(3,1,1)
plot(t, xd(:,1)*180/pi, 'r--', t, x(:,3)*180/pi, 'k', 'LineWidth', 1.5);
grid on;
xlabel('Tempo (s)');
ylabel('Posição (graus)');
legend('\theta_{ref}','\theta_l');
title('Resposta com referência chirp');

subplot(3,1,2)
plot(t, e_pos*180/pi, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Tempo (s)');
ylabel('Erro (graus)');
title('Erro de rastreamento');

subplot(3,1,3)
plot(t, tau_l, 'm', 'LineWidth', 1.5);
grid on;
xlabel('Tempo (s)');
ylabel('\tau_{elo} (N.m)');
title('Torque elástico no elo');

