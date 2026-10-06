% anim_elbow_meio.m — versão com elo flexível

% Posição da carga (braço), que corresponde ao terceiro estado
q_l = x(j+1, 3);  % posição angular do braço em rad

% Parâmetros do braço
modelParameters_elbow;

% Recupera o ombro (ponto fixo) e os handles
pShoulder = getappdata(graph_interface, 'pShoulder');
upper_arm = getappdata(graph_interface, 'upper_arm');
fore_arm = getappdata(graph_interface, 'fore_arm');

% Úmero (fixo): ombro → cotovelo
pElbow_x = pShoulder(1);
pElbow_y = pShoulder(2) - L_upper;

% Antebraço: cotovelo → mão (gira com q_l)
pHand_x = pElbow_x + L_fore * cos(pi/2 - q_l);
pHand_y = pElbow_y - L_fore * sin(pi/2 - q_l);

% Atualiza segmento do úmero
set(upper_arm, 'XData', [pShoulder(1), pElbow_x], 'YData', [pShoulder(2), pElbow_y]);

% Atualiza segmento do antebraço
set(fore_arm, 'XData', [pElbow_x, pHand_x], 'YData', [pElbow_y, pHand_y]);

drawnow;