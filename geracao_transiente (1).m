   % Regime permanente com circuito de geração.
% vazão na Turbina_1 = 0
% vazão nos trocadores 1,2,3 no circuito de alta pressão = 0
% h_16 diferente de h_15
% efi = exergia acum / trabalho total
%eta gera = trabalho gerad / exerg acum.
clear
format longG
clc
%% parâmetros de entrada
fluid = 'Nitrogen';
eta_c = 0.4;
eta_t = 0.8;
eta_b = 0.8;
v_tanque = 10;% volume do tanque em metros cúbicos
m_C = 1;
t_0 = 298; % temperatura ambiente em [K]
p_1 = 101325; % pressão ambiente em [Pa]
p_2 = 4 * 10^6; % pressão na saída do compressor em [Pa] = 4 MPa
p_3 = 20 * 10^6;% Pressão na saída da bomba - 20 MPa

%% propriedades do fluido (Nitrogênio)

h_0 = CoolProp.PropsSI('H','T',t_0,'P',101325,fluid); %entalpia entrada do compressor
s_0 = CoolProp.PropsSI('S','T',t_0,'P',101325,fluid); %entropia entrada do compressor
Cp = 1.042;
R = 0.296;
k = 1.4;
rho_n2= CoolProp.PropsSI('D','T',77.3,'P',101325,fluid);% massa específica do fluido no tanque
v_8 = 1/CoolProp.PropsSI('D','T',77.3,'Q',0,fluid); % volume específico do líquido no tanque
rho_9 = CoolProp.PropsSI('D','T',77.3,'Q',1,fluid); % peso específico do vapor saturado no tanque
rho_liq = CoolProp.PropsSI('D','T',77.3,'Q',0,fluid); % peso específico do líquido no tanque
v_1 = 1/CoolProp.PropsSI('D','T',298,'P',p_1,fluid);
t_1 = t_0; % temperatura na entrada do compressor
t_3 = t_0; % temperatura saída do cooler deve ser 298 K
t_18 = 273 + 35; % temperatura na entrada do aquecedor solar TC-6
t_19 = 400 + 273; % temperatura de saída do aquecedor solar TC-6
t_8 = 77.3 ;% temp em 8 77,3 K, líquido saturado Q = 0
Q_8 = 0 ; % título ponto 8
t_9 = 77.3; % temp em 9 77,3 K, vapor saturado Q = 1
Q_9 = 1; % título ponto 9
t_7 = 77.3 ;% temp em 7 77,3 K, duas fases com título Q = xr
t_15 = t_8;
T_4 = 298-33; % temperatura na extração para turbina by-pass


h_1 = CoolProp.PropsSI('H','T',t_1,'P',p_1,fluid);
s_1 = CoolProp.PropsSI('S','T',t_1,'P',p_1,fluid);
t_2 = t_1*(p_2 / p_1)^((k-1)/k);% cálculo temperatura  saída do compressor
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


% no circuito de geração
h_6 = CoolProp.PropsSI('H','Q',0.8,'P',p_1,fluid); 
h_15 = CoolProp.PropsSI('H','T',77.3,'P',20000000,fluid); % 
s_15 = CoolProp.PropsSI('S','T',77.3,'P',20000000,fluid);% 
h_18 =  CoolProp.PropsSI('H','T',t_18,'P',p_3,fluid);
s_18 =  CoolProp.PropsSI('S','T',t_18,'P',p_3,fluid);
h_19 = CoolProp.PropsSI('H','T',t_19,'P',p_3,fluid);
s_19 = CoolProp.PropsSI('S','T',t_19,'P',p_3,fluid);
t_20 = t_19 / ((p_3/p_1)^((k-1)/k)); % saída da turbina 2
h_20 = CoolProp.PropsSI('H','T',t_20,'P',p_3,fluid);
s_20 = CoolProp.PropsSI('S','T',t_20,'P',p_3,fluid);

%% parâmetros para cálculo da produção de líquido
h_13 = 1;
h_14 = 1;
MFR = [0.01 0.75 2 4 6];
MFR1 = sprintf('MFR = %0.01g',MFR(1)); MFR2 = sprintf('MFR = %g',MFR(2));
MFR3 = sprintf('MFR = %0.01g',MFR(3)); MFR4 = sprintf('MFR = %0.01g',MFR(4)); 
MFR5 = sprintf('MFR = %0.001g',MFR(5));
[~,tot1] = size(MFR);
m_B= m_C * MFR;
z=0; % Não há extração para turbina 1 (turbina by-pass)
eps=0.8;
[~,tot2]=size(eps);
T_6v = linspace(90,140,100);
p_2 = 4000000;
[~,totp] = size(T_6v);

%% razão de produção de líquido na geração

% desconsiderando o efeito dos trocadores de calor TC1,TC2 e TC3.

h_6v = zeros(size(totp));

for i=1:totp
  h_6v(i) = CoolProp.PropsSI('H','T',T_6v(i),'P',p_2,'Nitrogen'); 
  %Q_7(i) = CoolProp.PropsSI('Q','H',h_6v(i),'P',0.1*10^6,'Nitrogen');%título na saída da VE (ponto 7)
end
[~,tot3] = size(h_6v);
x1 = zeros(size(tot3));
x2 = zeros(size(tot3));
x3 = zeros(size(tot3));
x4 = zeros(size(tot3));
x5 = zeros(size(tot3));

for i=1:tot1
    for j=1:tot2
        for k=1:tot3
            if i==1 %MFR1
                x1(j,k) = prod_liq_transiente(h_6v(k),h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z,h_13,h_14,eps(j),eta_t);
                if x1 <0
                    x1=NaN;
                end
            end
            if i==2 %MFR2
                x2(j,k) = prod_liq_transiente(h_6v(k),h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z,h_13,h_14,eps(j),eta_t);
                if x2<0
                    x2= NaN;
                end
            end
            if i==3 %MFR3
                x3(j,k) = prod_liq_transiente(h_6v(k),h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z,h_13,h_14,eps(j),eta_t);
                if x3<0
                    x3= NaN;
                end
            end
            if i==4 %MFR4
                x4(j,k) = prod_liq_transiente(h_6v(k),h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z,h_13,h_14,eps(j),eta_t);
                if x4<0
                    x4= NaN;
                end
            end
            if i==5 %MFR5
                x5(j,k) = prod_liq_transiente(h_6v(k),h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z,h_13,h_14,eps(j),eta_t);
                if x5<0
                    x5= NaN;
                end
            end
        end
    end
end

%% Gráficos de produção de líquido 
figure()
subplot(1,2,1)
plot(T_6v,x1,':k',T_6v,x2,'-+b',T_6v,x3,'-*r',T_6v,x4,'-.g',T_6v,x5,'--k')
legend(MFR1,MFR2,MFR3,MFR4,MFR5)
%xlim([0.2,0.75])%,ylim([0.1,inf])
xlabel('Temperatura na entrada da VE - K');
ylabel('Produção de líquido - x')

subplot(1,2,2)
plot(T_6v,x1,':k',T_6v,x2,'-+b',T_6v,x3,'-*r',T_6v,x4,'-.g',T_6v,x5,'--k')
legend(MFR1,MFR2,MFR3,MFR4,MFR5)
xlim([126 133]),ylim([0.53 0.66])
xlabel('Temperatura na entrada da VE - K');
ylabel('Produção de líquido - x')


%% Cálculo do tempo de descarga
% considerando o tanque cheio %% função tempo_descarga (massa_líquido,mb,x,mc)
w_C = tcompressor_entalpia (h_2,h_1,eta_c);
W_C = w_C * m_C;
w_B = tbomba_entalpia(h_15,h_8,eta_b); %trabalho na bomba
W_B = w_B * m_B; % Potência na bomba
w_T2 = tturbina(h_19,h_20,eta_t);
W_T2 = w_T2 * m_B;
massa_liquido = rho_liq * v_tanque * 0.95;% 1 para tanque cheio 
t_d1 = zeros(size(tot3));
t_d2 = zeros(size(tot3));
t_d3 = zeros(size(tot3));
t_d4 = zeros(size(tot3));
t_d5 = zeros(size(tot3));
E_liq1 = zeros(size(tot3));
E_liq2 = zeros(size(tot3));
E_liq3 = zeros(size(tot3));
E_liq4 = zeros(size(tot3));
E_liq5 = zeros(size(tot3));

for i = 1:tot1
    for j = 1:tot3
        if i==1 % MFR1
            t_d1(j) = (tempo_descarga(massa_liquido,m_B(i),x1(j),m_C))/3600;
            if t_d1(j)<0
                t_d1(j) = NaN;
            end
            E_liq1(j) = (W_T2(i) - W_B(i)- W_C)*t_d1(j)/1000;
        end
        if i==2
            t_d2(j) = (tempo_descarga(massa_liquido,m_B(i),x2(j),m_C))/3600;
            if t_d2(j)<0
                t_d2(j) = NaN;
            end
            E_liq2(j) = (W_T2(i) - W_B(i)- W_C)*t_d2(j)/1000;
        end
        if i==3
            t_d3(j) = tempo_descarga(massa_liquido,m_B(i),x3(j),m_C)/3600;
            if t_d3(j)<0
                t_d3(j) = NaN;
            end
            E_liq3(j) = (W_T2(i) - W_B(i)- W_C)*t_d3(j)/1000;      
        end
        if i==4
            t_d4(j) = tempo_descarga(massa_liquido,m_B(i),x4(j),m_C)/3600;
            if t_d4(j)<0
                t_d4(j) = NaN;
            end
            E_liq4(j) = (W_T2(i) - W_B(i)- W_C)*t_d4(j)/1000;       
        end
        if i==5
            t_d5(j) = tempo_descarga(massa_liquido,m_B(i),x5(j),m_C)/3600;
            if t_d5(j)<0
                t_d5(j) = NaN;
            end
            E_liq5(j) = (W_T2(i) - W_B(i)- W_C)*t_d5(j)/1000;           
        end
    end
end

%% Gráficos dos tempos de descarga
figure ()
plot(T_6v,t_d1,':k',T_6v,t_d2,'-+b',T_6v,t_d3,'-*r',T_6v,t_d4,'-.g',T_6v,t_d5,'--k')
legend(MFR1,MFR2,MFR3,MFR4,MFR5)
ylim([0 20])
xlabel('Temperatura na entrada da Válvula de Expansão - K')
ylabel('Tempos de Descarga [horas]')
title('Tempo de descarga do reservatório cheio')


%% Parâmetros para cálculos da eficiência
MFR_ef = linspace(0.01,8,50);
m_Bef = MFR_ef * m_C;
[~,totmbe] = size(m_Bef);

w_Cef = tcompressor_entalpia (h_2,h_1,eta_c);
W_Cef = w_Cef * m_C;
w_Bef = tbomba_entalpia(h_15,h_8,eta_b); %trabalho na bomba
W_Bef = w_Bef * m_Bef; % Potência na bomba
w_T2ef = tturbina(h_19,h_20,eta_t);
W_T2ef = w_T2ef * m_Bef;
q_TC5 = 150000;
Q_TC5 = q_TC5 * m_Bef;
q_TC6ef = calortc(h_19,h_18);
Q_TC6ef = q_TC6ef * m_Bef;


%% Eficiência
y=1;
eta_ger = zeros(size(totmbe));
for i=1:totmbe
eta_ger(i) = eficienciageracao(W_T2ef(i),Q_TC5(i),W_Cef,W_Bef(i),Q_TC6ef(i));
end
figure()
plot(MFR_ef,eta_ger,'k',MFR_ef,y*ones(size(MFR_ef)),':k');
xlabel('MFR')
ylabel('Eficiência - \eta_{ger}')

% %% Energia produzida
% % Saldo Energético
% % energia produzida  - energia consumida
% W_Ce= w_C * m_C;
% W_Be = w_B * m_B;% Potência na bomba
% W_T2e = w_T2 * m_B;
% 
% t_d1h = t_d1 /3600; %conversão de tempo em segundos para horas
% t_d2h = t_d2 /3600;
% t_d3h = t_d3 /3600;
% t_d4h = t_d4 /3600;
% t_d5h = t_d5 /3600;
% 
% for i=1:tot1
%     for j=1:tot3
%         if i==1
%         E_tot1(j) = W_T2e(i) * t_d1h(j);
%         E_liq1(j) = (W_T2e(i) - W_Be(i)- W_C)*t_d1h(j);
%         end
%         if i==2
%         E_tot2(j) = W_T2e(i) * t_d2h(j);
%         E_liq2(j) = (W_T2e(i) - W_Be(i)- W_C)*t_d2h(j);
%         end
%         if i==3
%         E_tot3(j) = W_T2e(i) * t_d3h(j);
%         E_liq3(j) = (W_T2e(i) - W_Be(i)- W_C)*t_d3h(j);
%         end
%         if i==4
%         E_tot4(j) = W_T2e(i) * t_d4h(j);
%         E_liq4(j) = (W_T2e(i) - W_Be(i)- W_C)*t_d4h(j);
%         end
%         if i==5
%         E_tot5(j) = W_T2e(i) * t_d5h(j);
%         E_liq5(j) = (W_T2e(i) - W_Be(i)- W_C)*t_d5h(j);
%         end
%     end
% end

%% gráficos de energia x tempo de descarga

% tempos negativos de descarga se m_B é muito pequeno

% figure()            
% plot (t_d1h,E_tot1,':k',t_d1h,E_liq1,'--k')
% legend('Energia total', 'Energia líquida')
% title (MFR1)
% xlabel('Tempo de descarga - em horas')
% ylabel('Energia gerada')
% 
% figure()            
% plot (T_6v,E_liq2,'--k')
% legend('Energia líquida')
%  title (MFR2)
%  xlabel('Tempo de descarga - em horas')
%  ylabel('Energia gerada')

figure()            
plot (t_d3,E_liq3,'k')
legend('Energia líquida')
title (MFR3)
xlabel('Tempo de descarga - em horas')
ylabel('Energia gerada [kWh]')

figure()            
plot (t_d4,E_liq4,'k')
legend('Energia líquida')
title (MFR4)
xlabel('Tempo de descarga - em horas')
ylabel('Energia gerada [kWh]')

figure()            
plot (t_d5,E_liq5,'k')
legend('Energia líquida')
title (MFR5)
xlabel('Tempo de descarga - em horas')
ylabel('Energia gerada [kWh]')

%% Gráficos Energia pela produç de liq

figure()            
plot (x3,E_liq3,'k')
legend('Energia líquida')
title (MFR3)
xlabel('Produção de líquido')
ylabel('Energia gerada [kWh]')

figure()            
plot (x4,E_liq4,'k')
legend('Energia líquida')
title (MFR4)
xlabel('Produção de líquido')
ylabel('Energia gerada [kWh]')

figure()            
plot (x5,E_liq5,'k')
legend('Energia líquida')
title (MFR5)
xlabel('Produção de líquido')
ylabel('Energia gerada [kWh]')

%% Gráficos Energia pela temperatura na Entrada da VE

figure()            
plot (T_6v,E_liq3,'k')
legend('Energia líquida')
title (MFR3)
xlabel('Temperatura na entrada da VE')
ylabel('Energia gerada [kWh]')

figure()            
plot (T_6v,E_liq4,'k')
legend('Energia líquida')
title (MFR4)
xlabel('Temperatura na entrada da VE')
ylabel('Energia gerada [kWh]')

figure()            
plot (T_6v,E_liq5,'k')
legend('Energia líquida')
title (MFR5)
xlabel('Temperatura na entrada da VE')
ylabel('Energia gerada [kWh]')

save 'E_liq_ger.mat' E_liq1 E_liq2 E_liq3 E_liq4 E_liq5

%% Exergia no tanque

%exergia específica
e_t = exergia(h_8,h_0,t_0,s_8,s_0);








              
                
            


