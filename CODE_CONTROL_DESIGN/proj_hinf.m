clear all
close all

run('modelo_simulacao_G1_G2.m')

%--------------------------------------------------------------------------
% Projeto de K1(s)
G_1=pck(A1,B1,C1,D1);

%W1 - error 
Ms=2;%2,5
%wb=100/4;
wb=5;%3
E=0.01;%0,02
nwe=[1/Ms wb/Ms];
dwe=[1 wb*E];
W1tf=tf(nwe,dwe);
W1=nd2sys(nwe,dwe);

% %W2 - input u
%Mu = 12;
Mu = 8;
%wbc = 1000/4;
wbc = 5;
E1 = 0.01; 

nwu = (1/Mu)*[1 wbc];
dwu = [1 wbc/E1];
W2tf=tf(nwu,dwu);
W2=nd2sys(nwu,dwu);

%W3 - posicao Theta_l
wc=80;
E2=0.01;
nwtheta=[1 wc];
dwtheta=[1 wc/E2];
W3tf=tf(nwtheta,dwtheta);
W3=nd2sys(nwtheta,dwtheta);

% Planta aumentada
systemnames='G_1 W1 W2 W3';
inputvar='[dist; control]';
outputvar='[W1; W2; W3;-G_1-dist]';
input_to_G_1='[control]';
input_to_W1='[-G_1-dist]';
input_to_W2='[control]';
input_to_W3='[G_1]';
sysoutname='P';
cleanupsysic='yes';
sysic

% Síntese Hinf
gmin=0.1;
gmax=1e6;
[K1,CL1,GAM,INFO]=hinfsyn(P,1,1,gmin,gmax,0.05);
[Ak1,Bk1,Ck1,Dk1]=unpck(K1);
K1_ss=ss(Ak1,Bk1,Ck1,Dk1);

% Gráficos
[Agk,Bgk,Cgk,Dgk]=series(Ak1,Bk1,Ck1,Dk1,A1,B1,C1,D1);
Lo=ss(Agk,Bgk,Cgk,Dgk);

% Sensitivity function
So=inv(eye(size(Lo))+Lo);

%figure
[SV_so,W_so] = sigma(So,{1e-9,1e8});
SV_so = 20*log10(SV_so);
[SV_we,W_we] = sigma(GAM*inv(W1tf),{1e-9,1e6});
SV_we = 20*log10(SV_we);
[SV_we2,W_we2] = sigma(inv(W1tf),{1e-9,1e6});
SV_we2 = 20*log10(SV_we2);

KSo=series(K1_ss,So);
%figure
[SV_kso,W_kso] = sigma(KSo,{1e0,1e9});
SV_kso = 20*log10(SV_kso);
[SV_wu,W_wu] = sigma(GAM*inv(W2tf),{1e0,1e9});
SV_wu = 20*log10(SV_wu);
[SV_wu2,W_wu2] = sigma(inv(W2tf),{1e0,1e9});
SV_wu2 = 20*log10(SV_wu2);

T = feedback(Lo,1);

figura_art

%--------------------------------------------------------------------------

% Projeto de K2(s)
G = pck(A,B,C,D);

%W1 - error
nwe=[65];
dwe=[1];
W1tf=tf(nwe,dwe);
W1=nd2sys(nwe,dwe);

% %W2 - input u 
%Mu = 12;
Mu = 8;
wbc = 1;
E1 = 0.0002; 
nwu = (1/Mu)*[1 wbc];
dwu = [1 wbc/E1];
W2tf=tf(nwu,dwu);
W2=nd2sys(nwu,dwu);


%W3 - posicao Theta_l
nwtheta = [10];
dwtheta = [1];
W3tf = tf(nwtheta, dwtheta);
W3 = nd2sys(nwtheta, dwtheta);

% Função de Transferência de Referência Xt
n = 1;
d = [0.1 5 20];
Xt = nd2sys(n,d);
% Xtt = tf(n,d)

% Planta Aumentada
systemnames = 'G K1 Xt W1 W2 W3';
inputvar = '[fl; control]';
outputvar = '[W1; W2; W3; fl]';
input_to_G = '[control+K1; fl]';
input_to_Xt = '[fl]';
input_to_K1 = '[-G]';
input_to_W1 = '[Xt-G]';
input_to_W2 = '[control]';
input_to_W3 = '[G]';
sysoutname = 'P';
cleanupsysic = 'yes';
sysic;

% Síntese Hinf
gmin = 0.1;
gmax = 1e6;
[K2, CL2, GAM2, INFO2] = hinfsyn(P, 1, 1, gmin, gmax, 0.05);
[Ak2, Bk2, Ck2, Dk2] = unpck(K2);
K2_ss = ss(Ak2, Bk2, Ck2, Dk2);


% Gráfico %

K1_tf = tf(K1_ss);
K2_tf = tf(K2_ss);

FTmf = G2 + (G1/(1+G1*K1_tf))*(K2_tf-K1_tf*G2);
 
FTma = G2+T*G2;

Xtt = tf(n,d);

% % % % % % % % % % % % % 

% Definir posição e tamanho da janela de figura
gui_x_pos = 375;
gui_y_pos = 200;
gui_x_size = 600;
gui_y_size = 300;

% Criar figura
figure3 = figure('Color', [1 1 1], 'Position', [gui_x_pos, gui_y_pos, gui_x_size, gui_y_size]);

% Criar e configurar os eixos
axes2 = axes('Parent', figure3, 'YGrid', 'on', 'XScale', 'log', 'XMinorTick', 'on', ...
    'Position', [0.12 0.20 0.85 0.75]);

% Obter dados de magnitude e frequência usando bode
[mag1, ~, wout1] = bode(FTmf, {0.01, 1e4});
[mag2, ~, wout2] = bode(FTma, {0.01, 1e4});
[mag3, ~, wout3] = bode(Xtt, {0.01, 1e4});

% Converter magnitude para dB
mag1 = 20*log10(squeeze(mag1));
mag2 = 20*log10(squeeze(mag2));
mag3 = 20*log10(squeeze(mag3));

% Plotar com semilogx
semilogx(wout3, mag3, 'LineStyle', '--', 'LineWidth', 2, 'Color', 'r');
hold on;
semilogx(wout1, mag1, 'LineStyle', '-', 'LineWidth', 2, 'Color', 'b');
semilogx(wout2, mag2, 'LineStyle', '-.', 'LineWidth', 2, 'Color', 'g');


% Configurar os eixos
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Frequência (rad/s)', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontName', 'Times New Roman', 'FontSize', 14);

% Configurar a legenda
leg = legend('Referência X_T', 'Com K_2(s)', 'Sem K_2(s)');
set(leg, 'FontSize', 14, 'FontName', 'Times New Roman', 'Location', 'SouthWest', 'FontAngle', 'italic');

% Configurar ticks e grid
set(gca, 'XTick', [1e-2 1e-1 1e0 1e1 1e2 1e3]);
axis([1e-2 1e3 -60 0]);
grid on;

%--------------------------------------------------------------------------

% Projeto de K3(s)
G=pck(A1,B1,C1,D1);

%W1 - error 
%Ms=0.000001;
Ms=2;
%wb=100;
wb=12;
E=0.001;
nwe=[1/Ms wb/Ms];
dwe=[1 wb*E];
W1tf=tf(nwe,dwe);
W1=nd2sys(nwe,dwe);

%W2 - input u
nwu=0.01;
dwu=1;
W2tf=tf(nwu,dwu);
W2=nd2sys(nwu,dwu);

%W3 - posicao Theta_l
Mtheta=2;
wbc=1;
E1 = 1;
nwtheta=0;
dwtheta=1;
W3tf=tf(nwtheta,dwtheta);
W3=nd2sys(nwtheta,dwtheta);

%f = 20;
f = 0.5;
wn = 2*pi*f;
zeta = 1;

n = 2*wn^2;
d = [1 2*zeta*wn wn^2];

Tt = nd2sys(n,d);

Tt_tf = tf(n,d);

% Planta aumentada
systemnames='G K1 Tt W1 W2 W3';
inputvar='[thetad; control]';
outputvar='[W1; W2; W3; thetad]';
input_to_G='[K1]';
input_to_Tt='[thetad]';
input_to_K1='[control-G]';
input_to_W1='[Tt-G]';
input_to_W2='[control]';
input_to_W3='[G]';
sysoutname='P';
cleanupsysic='yes';
sysic

% Síntese Hinf
gmin=0.1;
gmax=15000;
K3 = hinfsyn(P,1,1,gmin,gmax,0.05);
[Ak3,Bk3,Ck3,Dk3]=unpck(K3);
K3_ss = ss(Ak3,Bk3,Ck3,Dk3);


% Gráfico %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K3_T = K3_ss*T;

% Definir posição e tamanho da janela de figura
gui_x_pos = 375;
gui_y_pos = 200;
gui_x_size = 600;
gui_y_size = 300;

% Criar figura
figure4 = figure('Color', [1 1 1], 'Position', [gui_x_pos, gui_y_pos, gui_x_size, gui_y_size]);

% Criar e configurar os eixos
axes2 = axes('Parent', figure4, 'YGrid', 'on', 'XScale', 'log', 'XMinorTick', 'on', ...
    'Position', [0.12 0.20 0.85 0.75]);

% Obter dados de magnitude e frequência usando bode
[mag1, ~, wout1] = bode(T, {0.1, 1e4});
[mag2, ~, wout2] = bode(Tt_tf, {0.1, 1e4});
[mag3, ~, wout3] = bode(K3_T, {0.1, 1e4});

% Converter magnitude para dB
mag1 = 20*log10(squeeze(mag1));
mag2 = 20*log10(squeeze(mag2));
mag3 = 20*log10(squeeze(mag3));

% Plotar com semilogx
semilogx(wout2, mag2, 'LineStyle', '--', 'LineWidth', 2, 'Color', 'r');
hold on;
semilogx(wout3, mag3, 'LineStyle', '-', 'LineWidth', 2, 'Color', 'b');
semilogx(wout1, mag1, 'LineStyle', '-.', 'LineWidth', 2, 'Color', 'g');

% Configurar os eixos
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Frequência (rad/s)', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('Magnitude (dB)', 'FontName', 'Times New Roman', 'FontSize', 14);

% Configurar a legenda
leg = legend('Referência T_t', 'Com K_3(s)', 'Sem K_3(s)');
set(leg, 'FontSize', 14, 'FontName', 'Times New Roman', 'Location', 'SouthWest', 'FontAngle', 'italic');

% Configurar ticks e grid
set(gca, 'XTick', [1e0 1e1 1e2 1e3 1e4]);
axis([1e0 1e4 -80 0]);
grid on;

Ts = 0.001; % tempo de amostragem

save controladores.mat K1_ss K2_ss K3_ss

% =========================================================
% Diagramas de Bode dos Controladores H∞

K1_tf = tf(K1_ss);
K2_tf = tf(K2_ss);
K3_tf = tf(K3_ss);

figure('Color','w','Position',[300 200 750 600])

% Criar bodeplot customizável
h = bodeplot(K1_tf, K2_tf, K3_tf);

% Opções visuais
setoptions(h,...
    'FreqUnits','rad/s',...
    'Grid','on',...
    'PhaseVisible','on',...
    'MagVisible','on');

% Aumentar espessura das linhas
set(findall(gcf,'Type','line'),'LineWidth',2.2)

% Ajustar fontes e eixos
ax = findall(gcf,'Type','axes');
for i = 1:length(ax)
    set(ax(i),'FontSize',14,...
              'FontName','Times New Roman',...
              'LineWidth',1.2,...
              'Box','off')
end

% Legenda
leg = legend('K_1(s)', 'K_2(s)', 'K_3(s)');

set(leg, 'FontSize', 14, 'FontName', 'Times New Roman', 'Location', 'SouthWest', 'FontAngle', 'italic', ...
    'Location','southwest','FontSize',13, 'FontName','Times New Roman');

title('Diagramas de Bode dos Controladores H_\infty',...
      'FontSize',16,...
      'FontName','Times New Roman')
grid on

%save controladores_discretos.mat K1_d K2_d K3_d


%figure
%bode(K1_ss)
%grid on
%title('K_1 – Controle de Sensibilidade')

%figure
%bode(K2_ss)
%grid on
%title('K_2 – Controle de Impedância')

%figure
%bode(K3_ss)
%grid on
%title('K_3 – Rastreamento de Trajetória')
