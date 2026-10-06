% anim_elbow_init.m
% Desenho inicial do sistema corpo/órtese com foco no braço e posição sentada

% Apaga a área movie_axis
set(graph_interface, 'CurrentAxes', movie_axis);
cla;

% Posição inicial do corpo e braço
x0 = [0 0];  % ângulo inicial do cotovelo em radianos (45 graus)

% Parâmetros do modelo
modelParameters_elbow;

% Ajustando proporções
L_torso = 0.5;  % Comprimento do tronco aumentado
L_thigh = 0.28; % Comprimento da coxa aumentado
L_leg = 0.28;   % Comprimento da perna aumentado
L_foot = 0.1;  % Comprimento do pé
L_seat = 0.3;  % Comprimento do assento da cadeira
L_neck = 0.08;  % Comprimento do pescoço
L_head = 0.12;  % Ajuste no tamanho da cabeça

% Posição do quadril (base do tronco na altura do assento)
pHip_x = -0.2;
pHip_y = 0.6; % altura do assento

% Posição do ombro (ajustado para a postura sentada)
pShoulder_x = pHip_x; 
pShoulder_y = pHip_y + L_torso; % altura do ombro

% Posição do pescoço
pNeck_x = pShoulder_x;
pNeck_y = pShoulder_y + L_neck;

% Posição do cotovelo
pElbow_x = pShoulder_x;
pElbow_y = pShoulder_y - L_upper;

% Posição da mão
% pHand_x = pElbow_x + L_fore * cos(x0(1));
% pHand_y = pElbow_y - L_fore * sin(x0(1));
pHand_x = pElbow_x + L_fore * cos(pi/2 - x0(1));
pHand_y = pElbow_y - L_fore * sin(pi/2 - x0(1));

% Cores
upper_color = 'b';
fore_color = 'r';
torso_color = 'k';
head_color = 'k';
chair_color = [0.545, 0.271, 0.075]; % Marrom
foot_color = 'k';

% Desenha a cadeira primeiro (assento e encosto)
pSeat_x = pHip_x - 0.05;
pSeat_y = pHip_y;
pBackrest_x = pSeat_x;
pBackrest_y = pShoulder_y;

chair_seat = line([pSeat_x pSeat_x + L_seat], [pSeat_y pSeat_y]);
set(chair_seat, 'LineWidth', 5, 'Color', chair_color);

chair_back = line([pBackrest_x pBackrest_x], [pSeat_y pBackrest_y]);
set(chair_back, 'LineWidth', 5, 'Color', chair_color);

chair_leg1 = line([pSeat_x pSeat_x], [pSeat_y pSeat_y - 0.3]);
set(chair_leg1, 'LineWidth', 5, 'Color', chair_color);

chair_leg2 = line([pSeat_x + L_seat pSeat_x + L_seat], [pSeat_y pSeat_y - 0.3]);
set(chair_leg2, 'LineWidth', 5, 'Color', chair_color);

% Desenha o tronco (quadril → ombro)
torso = line([pHip_x pShoulder_x], [pHip_y pShoulder_y]);
set(torso, 'LineWidth', 15, 'Color', torso_color);

% Desenha o pescoço
neck = line([pShoulder_x pNeck_x], [pShoulder_y pNeck_y]);
set(neck, 'LineWidth', 8, 'Color', torso_color);

% Desenha a cabeça
pHead_x = pNeck_x;
pHead_y = pNeck_y + L_head/2;
head = line(pHead_x, pHead_y, 'Marker', 'o', 'MarkerSize', 35, 'Color', head_color, 'LineWidth', 5);

% Ajusta a perna para joelho a 90° com proporções corretas
pKnee_x = pHip_x + L_thigh;
pKnee_y = pHip_y;
knee = line([pHip_x pKnee_x], [pHip_y pKnee_y]);
set(knee, 'LineWidth', 10, 'Color', torso_color);

pAnkle_x = pKnee_x;
pAnkle_y = pKnee_y - L_leg;
foot = line([pKnee_x pAnkle_x], [pKnee_y pAnkle_y]);
set(foot, 'LineWidth', 10, 'Color', torso_color);

% Desenha o pé
pToe_x = pAnkle_x + L_foot;
pToe_y = pAnkle_y;
foot_shape = line([pAnkle_x pToe_x], [pAnkle_y pToe_y]);
set(foot_shape, 'LineWidth', 10, 'Color', foot_color);

% Desenha os segmentos do braço

upper_arm = line([pShoulder_x pElbow_x], [pShoulder_y pElbow_y]);
set(upper_arm, 'LineWidth', 10, 'Color', upper_color, 'Marker', '.', 'MarkerSize', 40);

annotation('textarrow', [0.25 0.215], [0.7 0.62], ...
    'String', 'Humerus', ...
    'FontSize', 10, ...
    'Color', upper_color, ...
    'LineWidth', 1.5, ...
    'FontWeight', 'bold');

rectangle('Position', [pShoulder_x-0.015, pShoulder_y-0.015, 0.03, 0.03], ...
    'Curvature', [1, 1], 'EdgeColor', 'k', 'LineWidth', 1.5);

fore_arm = line([pElbow_x pHand_x], [pElbow_y pHand_y]);
set(fore_arm, 'LineWidth', 10, 'Color', fore_color, 'Marker', '.', 'MarkerSize', 40);

annotation('textarrow', [0.25 0.215], [0.6 0.52], ...
    'String', 'Forearm', ...
    'FontSize', 10, ...
    'Color', fore_color, ...
    'LineWidth', 1.5, ...
    'FontWeight', 'bold');

rectangle('Position', [pElbow_x-0.015, pElbow_y-0.015, 0.03, 0.03], ...
    'Curvature', [1, 1], 'EdgeColor', 'k', 'LineWidth', 1.5);

% Eixos ajustados
axis equal;
axis([-0.5 0.6 0.2 1.5]);
xlabel('X');
ylabel('Y');
title('Simulação da Flexão-Extensão do Cotovelo');
grid on;

% Armazena handles para atualização
setappdata(graph_interface, 'upper_arm', upper_arm);
setappdata(graph_interface, 'fore_arm', fore_arm);
setappdata(graph_interface, 'pShoulder', [pShoulder_x, pShoulder_y]);
