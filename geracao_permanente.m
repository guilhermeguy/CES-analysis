% Regime permanente com circuito de gera��o.
% vaz�o na Turbina 1 = 0
% vaz�o nos trocadores 1,2,3 no circuito de alta press�o = 0
% h_16 diferente de h_15
clear
clc

% par�metros de entrada
fluid = 'Nitrogen';
eta_iso = 0.8;
eta_el = 0.98;
eta_mec = 0.96;
z = 0;
v_tanque = 10;% volume do tanque em metros c�bicos



%vaz�es no compressor e bomba
m_C = 5;


%propriedades Nitrog�nio 298 K 0,101 MPa
t_0 = 298; % temperatura ambiente em [K]
h_0 = CoolProp.PropsSI('H','T',t_0,'P',101325,fluid); %entalpia entrada do compressor
s_0 = CoolProp.PropsSI('S','T',t_0,'P',101325,fluid); %entropia entrada do compressor
Cp = 1.042;
R = 0.296;
k = 1.4;
rho_n2= CoolProp.PropsSI('D','T',77.3,'P',101325,fluid);% massa espec�fica do fluido no tanque

p_1 = 101325; % press�o ambiente em [Pa]
p_2 = 4 * 10^6; % press�o na sa�da do compressor em [Pa] = 4 MPa
p_3 = 20 * 10^6;% Press�o na sa�da da bomba - 20 MPa
t_1 = t_0; % temperatura na entrada do compressor
t_3 = t_0; % temperatura sa�da do cooler deve ser 298 K
t_18 = 273 + 35; % temperatura na entrada do aquecedor solar TC-6
t_19 = 400 + 273; % temperatura de sa�da do aquecedor solar TC-6
t_8 = 77.3 ;% temp em 8 77,3 K, l�quido saturado Q = 0
Q_8 = 0 ; % t�tulo ponto 8
t_9 = 77.3; % temp em 9 77,3 K, vapor saturado Q = 1
Q_9 = 1; % t�tulo ponto 9
t_7 = 77.3 ;% temp em 7 77,3 K, duas fases com t�tulo Q = xr
t_15 = t_8;


h_1 = CoolProp.PropsSI('H','T',t_1,'P',p_1,fluid);
s_1 = CoolProp.PropsSI('S','T',t_1,'P',p_1,fluid);
t_2 = t_1*(p_2 / p_1)^((k-1)/k);% c�lculo temperatura  sa�da do compressor
h_2 = CoolProp.PropsSI('H','T',t_2,'P',p_2,fluid);
s_2 = CoolProp.PropsSI('S','T',t_2,'P',p_2,fluid);
h_12 = h_1;
s_12 = s_1;
h_3 = CoolProp.PropsSI('H','T',t_3,'P',p_2,fluid);
s_3 = CoolProp.PropsSI('S','T',t_3,'P',p_2,fluid);

h_8 = CoolProp.PropsSI('H','T',t_8,'Q',0,fluid);
s_8 = CoolProp.PropsSI('S','T',t_8,'Q',0,fluid);
h_9 = CoolProp.PropsSI('H','T',t_9,'Q',1,fluid);
s_9 = CoolProp.PropsSI('S','T',t_9,'Q',1,fluid);

% no circuito de gera��o
h_6 = CoolProp.PropsSI('H','Q',0.8,'P',p_1,fluid); 
h_15 = CoolProp.PropsSI('H','T',77.3,'P',20000000,fluid); % 
s_15 = CoolProp.PropsSI('S','T',77.3,'P',20000000,fluid);% 
h_18 =  CoolProp.PropsSI('H','T',t_18,'P',p_3,fluid);
s_18 =  CoolProp.PropsSI('S','T',t_18,'P',p_3,fluid);
h_19 = CoolProp.PropsSI('H','T',t_19,'P',p_3,fluid);
s_19 = CoolProp.PropsSI('S','T',t_19,'P',p_3,fluid);
t_20 = t_19 / ((p_3/p_1)^((k-1)/k)); % sa�da da turbina 2
h_20 = CoolProp.PropsSI('H','T',t_20,'P',p_3,fluid);
s_20 = CoolProp.PropsSI('S','T',t_20,'P',p_3,fluid);

% produ��o de l�quido na gera��o
% desconsiderando o efeito dos trocadores de calor TC1,TC2 e TC3.
eps=linspace(0,1,100);
[m,tot]=size(eps);
x = zeros(1,tot);
  
for i=1:tot
    x(i)= prodliq_gp(h_1,h_6,eps(i),h_9,h_8);
end


%% par�metros espec�ficos para c�lculos de efici�ncia
q_TC6 = h_19-h_18; % carga t�rmica do aquecedor solar TC-6
q_TC5 = 150000;% carga t�rmica no TC-5
w_C = tcompressor(h_2,h_1,eta_iso,eta_el,eta_mec);
w_B = tbomba(h_15,h_8,eta_iso,eta_el,eta_mec);
w_T2=tturbina(h_19,h_20,eta_iso,eta_el,eta_mec);

%% pot�ncias dos equipamentos 
m_B = x * m_C;
Q_TC6 = q_TC6 * m_B;
Q_TC5 = q_TC5 *  m_B;
W_C = w_C * m_C;
W_B = w_B * m_B;
W_T2 = w_T2 * m_B;

%% Efici�ncia
[m,totx] = size(x);
for i=1:totx
eta_g(i) = eficienciageracao(W_T2(i),Q_TC5(i),W_C,W_B(i),Q_TC6(i));
end

%%
%massa_liq_rsv = rho_n2 * v_tanque; % massa de l�quido no tanque. Considerado cheio.

% tempo de descarga em fun��o da massa de l�quido existente no tanque
% na condi��o inicial, vaz�o da bomba, e vaz�o do compressor multiplicado
% pela produ��o de l�quido.
%t_d = tempod(m_l,m_B,x,m_C);

%% Gr�ficos
figure(1)
plot (eps , x ,'--k')
ylim([0:1])
grid on
xlabel('Efetividade - \epsilon')
ylabel('Produ��o de l�quido - x')
title('Produ��o de l�quido em gera��o')

figure(2)
plot(x,eta_g,':k')
grid on
%xlim([0.1 1])
%ylim([0 1])
xlabel('Produ��o de l�quido - x')
ylabel('Efici�ncia na gera��o - \eta')
title ('Efici�ncia da gera��o em regime permanente')

figure(3)
plot(m_B,eta_g,':k')
grid on
%xlim([0.5 4])
%ylim([0 1])
xlabel('Vaz�o na bomba')
ylabel('Efici�ncia na gera��o - \eta')
title ('Efici�ncia da gera��o em regime permanente')

figure(4)
plot(x,W_T2,':k')
grid on
%xlim([0.5 4])
%ylim([0 1])
xlabel('Produ��o de l�quido - x')
ylabel('Pot�ncia na Turbina 2')
title ('Pot�ncia na Turbina 2')
