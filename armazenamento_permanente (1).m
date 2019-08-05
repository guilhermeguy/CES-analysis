% Regime Permanente no armazenamento. Nesse caso específico, m_C é igual a
% m_B com vazão na turbina 1 diferente de zero.
%% parâmetros de entrada
clear
clc
fluid = 'Nitrogen';
eta_iso = 0.8; % eficiência isentrópica
eta_el = 0.98; % eficiência elétrica
eta_mec = 0.96;% mecânica
T_0 = 298;%temperatura em [K]

h_0 = CoolProp.PropsSI('H','T',298,'P',101325,fluid); % entalpia condições de entorno
s_0 = CoolProp.PropsSI('S','T',T_0,'P',101325,fluid); % entropia condições de entorno
k = 1.4;
P_1 = 101325;% pressão ambiente
P_2 = 4000000; % pressão saída do compressor até entrada válvula de expansão
P_3 = 20000000; % pressão saída da bomba até entrada da turbina 2
T_4 = 298-33; % temperatura na extração para turbina by-pass
T_1 = T_0; % temperatura entrada do compressor e 
T_3 = T_1; % temperatura saída do cooler, expansão isotérmica
T_19 = 400+273; % temperatura na saída do aquecedor solar
T_8 = 77.3; % temperatura do líquido no tanque
Q_8 = 0; %título no ponto 8
T_9 = 77.3; % temperatura no retorno de vapor saturado do reservatório
Q_9 = 1; %título no ponto 9
T_7 = 77.3; %temperatura na saída da válvula de expansão
T_15 = T_8; % temperatura na saída da bomba
m_C = 6;

%% Propriedades termodinâmicas nos pontos

h_1 = CoolProp.PropsSI('H','T',T_1,'P',P_1,fluid);
s_1 = CoolProp.PropsSI('S','T',T_1,'P',P_1,fluid);

T_2 = T_1*(P_2 / P_1)^((k-1)/k);% cálculo temperatura  saída do compressor
h_2 = CoolProp.PropsSI('H','T',T_2,'P',P_2,fluid);
s_2 = CoolProp.PropsSI('S','T',T_2,'P',P_2,fluid);
h_12 = h_1;
s_12 = s_1;
h_3 = CoolProp.PropsSI('H','T',T_3,'P',P_2,fluid);
s_3 = CoolProp.PropsSI('S','T',T_3,'P',P_2,fluid);

%parâm reservatório definidos 77,3 K (vap. sat, líq sat)
h_8 = CoolProp.PropsSI('H','T',T_8,'Q',0,fluid);
s_8 = CoolProp.PropsSI('S','T',T_8,'Q',0,fluid);
h_9 = CoolProp.PropsSI('H','T',T_9,'Q',1,fluid);
s_9 = CoolProp.PropsSI('S','T',T_9,'Q',1,fluid);

h_4 = CoolProp.PropsSI('H','T',T_4,'P',P_2,fluid);
s_4 = CoolProp.PropsSI('S','T',T_4,'P',P_2,fluid);
h_13 = h_4;
s_13 = s_4;
T_13 = T_4;
T_14 = T_13/((P_2/P_1)^((k-1)/k)); % cálculo para temperatura no ponto 14
h_14 = CoolProp.PropsSI('H','T',T_14,'P',P_1,fluid);
s_14 = CoolProp.PropsSI('S','T',T_14,'P',P_1,fluid);
T_10 = T_14;
h_10 = h_14;
s_10 = s_14;

%% produção de líquido durante o armazenamento
z1 = linspace(0,1,50);% extração para turbina 1 (by-pass)
eps1 = linspace(0,1,50); %efetividade
zcombeps = combvec(z1,eps1);
[m,tot] = size(zcombeps);
x = zeros(1,tot);
z=zcombeps(1,:);
eps = zcombeps(2,:);
for i=1:tot
    x(i) = prodliq_ap(h_1,h_3,eps(i),h_9,eta_iso,z(i),h_13,h_14,h_8);
    if x(i)<0
        x(i)=NaN;
    end
end

m_l = x .* m_C;
m_B = m_l; 

%% propriedades no circuito de geração durante o armazenamento
h_15 = CoolProp.PropsSI('H','T',T_15,'P',P_3,fluid); % 
s_15 = CoolProp.PropsSI('S','T',T_15,'P',P_3,fluid);% 
h_16 =  h_15; % não há vazão em TC4
T_16 = T_15;% não há vazão em TC4
s_16 = s_15;% não há vazão em TC4
h_17 =  h_16 + 150000; % carga térmica do TC5 150 kJ/kg
T_17 = CoolProp.PropsSI('T','H',h_17,'P',P_3,fluid);
s_17 =  CoolProp.PropsSI('S','T',T_17,'P',P_3,fluid) ;
T_18 = 273 + 35; % temperatura de saída do Cooler
h_18 =  CoolProp.PropsSI('H','T',T_18,'P',P_3,fluid);
s_18 =  CoolProp.PropsSI('S','T',T_18,'P',P_3,fluid);
% T_19 já declarada de 400ºC
h_19 = CoolProp.PropsSI('H','T',T_19,'P',P_3,fluid); 
s_19 = CoolProp.PropsSI('S','T',T_19,'P',P_3,fluid);
T_20 = T_19 / ((P_3/P_1)^((k-1)/k)); % saída da turbina 2
h_20 = CoolProp.PropsSI('H','T',T_20,'P',P_3,fluid);
s_20 = CoolProp.PropsSI('S','T',T_20,'P',P_3,fluid);

%% Volumes de controle nos equipamentos para cálculo de trabalhos e potências e cargas térmicas

w_C = tcompressor(h_2,h_1,eta_iso,eta_el,eta_mec);
W_C = w_C * m_C;
w_B = tbomba(h_15,h_8,eta_iso,eta_el,eta_mec); %trabalho na bomba
W_B = w_B * m_B; % Potência na bomba
w_T1 = tturbina(h_13,h_14,eta_iso,eta_el,eta_mec);
W_T1 = w_T1 * z * m_C;
w_T2 = tturbina(h_19,h_20,eta_iso,eta_el,eta_mec);
W_T2 = w_T2 * m_B;
q_TC5 = calortc(h_17,h_16);
Q_TC5 = q_TC5 * m_B;
q_TC6 = calortc(h_19,h_18);
Q_TC6 = q_TC6 * m_B;
%wg = W_T1 + W_T2 + Q_TC5;
%wc = W_C + W_B + Q_TC6;
%eta_armaz = eficiencia(wg,wc);

%% Gráficos
figure()
[X,Y] = meshgrid(z,eps);
Z = griddata(z,eps,x,X,Y);
[c,h] = contour(X,Y,Z,'k');
clabel(c,h);
xlabel('Extração para Turbina 1 - z')
ylabel('Efetividade - \epsilon')

%% Trabalho líquido específico
for i=1:tot
    w_le_C(i)= w_C / x(i);
end
%%  Trabalho liq espec do compressor funç extração z
figure()
% subplot(1,2,1)
plot (z,w_le_C,'--k')
title('Trabalho Líquido Específico')
% xlim([0.3 inf]),ylim([0 0.5e8])
xlabel('Extração para Turbina 1 - z')
ylabel('Trabalho líquido específico - kJ/kg_{ar}')

% subplot(1,2,2)
% plot (z,w_le_C1,'--k',z,w_le_C2,'-.r',z,w_le_C3,':c',z,w_le_C4,'g',z,w_le_C5,'b')
% legend(MFR1,MFR2,MFR3,MFR4,MFR5)
% xlim([0.5 0.6]),ylim([0.7e7 1.2e7])
% xlabel('Extração para Turbina 1 - z')
% ylabel('Trabalho líquido específico - kJ/kg_{ar}')









