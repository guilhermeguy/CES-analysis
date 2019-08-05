% programa para c�lculo dos par�metros durante o
% Regime transiente no armazenamento
format longG
clear
clc
%% par�metros de entrada
fluid = 'Nitrogen';
eta_c = 0.4; % efici�ncia isentr�pica
eta_t = 0.8; % efici�ncia el�trica
eta_b = 0.8;% mec�nica
v_tanque = 10;% volume do tanque em metros c�bicos
m_C = 5; % vaz�o de massa no compressor

T_0 = 298;%temperatura em [K]
h_0 = CoolProp.PropsSI('H','T',T_0,'P',101325,fluid); % entalpia condi��es de entorno
s_0 = CoolProp.PropsSI('S','T',T_0,'P',101325,fluid); % entropia condi��es de entorno
k = 1.4;
P_1 = 101325;% press�o ambiente
P_2 = 4000000; % press�o sa�da do compressor at� entrada v�lvula de expans�o
P_3 = 20000000; % press�o sa�da da bomba at� entrada da turbina 2
T_4 = 298-33; % temperatura na extra��o para turbina by-pass
T_1 = T_0; % temperatura entrada do compressor e 
T_3 = T_1; % temperatura sa�da do cooler, expans�o isot�rmica
T_19 = 400+273; % temperatura na sa�da do aquecedor solar
T_8 = 77.3; % temperatura do l�quido no tanque
Q_8 = 0; %t�tulo no ponto 8
T_9 = 77.3; % temperatura no retorno de vapor saturado do reservat�rio
Q_9 = 1; %t�tulo no ponto 9
T_7 = 77.3; %temperatura na sa�da da v�lvula de expans�o
T_15 = T_8; % temperatura na sa�da da bomba

%% Propriedades termodin�micas nos pontos

h_1 = CoolProp.PropsSI('H','T',T_1,'P',P_1,fluid);
s_1 = CoolProp.PropsSI('S','T',T_1,'P',P_1,fluid);

T_2 = T_1*(P_2 / P_1)^((k-1)/k);% c�lculo temperatura  sa�da do compressor
h_2 = CoolProp.PropsSI('H','T',T_2,'P',P_2,fluid);
s_2 = CoolProp.PropsSI('S','T',T_2,'P',P_2,fluid);
h_12 = h_1;
s_12 = s_1;
h_3 = CoolProp.PropsSI('H','T',T_3,'P',P_2,fluid);
s_3 = CoolProp.PropsSI('S','T',T_3,'P',P_2,fluid);

%par�m reservat�rio definidos 77,3 K (vap. sat, l�q sat)
h_8 = CoolProp.PropsSI('H','T',T_8,'Q',0,fluid);
s_8 = CoolProp.PropsSI('S','T',T_8,'Q',0,fluid);
h_9 = CoolProp.PropsSI('H','T',T_9,'Q',1,fluid);
s_9 = CoolProp.PropsSI('S','T',T_9,'Q',1,fluid);
rho_9 = CoolProp.PropsSI('D','T',T_9,'Q',1,fluid);
v_8 = 1/CoolProp.PropsSI('D','T',T_9,'Q',0,fluid);

h_4 = CoolProp.PropsSI('H','T',T_4,'P',P_2,fluid);
s_4 = CoolProp.PropsSI('S','T',T_4,'P',P_2,fluid);
h_6 = CoolProp.PropsSI('H','T',T_9,'Q',0.9,fluid);
h_7 = h_6;
h_13 = h_4;
s_13 = s_4;
T_13 = T_4;
T_14 = T_13/((P_2/P_1)^((k-1)/k)); % c�lculo para temperatura no ponto 14
h_14 = CoolProp.PropsSI('H','T',T_14,'P',P_1,fluid);
s_14 = CoolProp.PropsSI('S','T',T_14,'P',P_1,fluid);
T_10 = T_14;
h_10 = h_14;
s_10 = s_14;
h_15 = CoolProp.PropsSI('H','T',T_15,'P',P_3,fluid); % 
s_15 = CoolProp.PropsSI('S','T',T_15,'P',P_3,fluid);% 
h_16 =  h_15; % n�o h� vaz�o em TC4
T_16 = T_15;% n�o h� vaz�o em TC4
s_16 = s_15;% n�o h� vaz�o em TC4
h_17 =  h_16 + 150000; % carga t�rmica do TC5 150 kJ/kg
T_17 = CoolProp.PropsSI('T','H',h_17,'P',P_3,fluid);
s_17 =  CoolProp.PropsSI('S','T',T_17,'P',P_3,fluid) ;
T_18 = 273 + 35; % temperatura de sa�da do Cooler
h_18 =  CoolProp.PropsSI('H','T',T_18,'P',P_3,fluid);
s_18 =  CoolProp.PropsSI('S','T',T_18,'P',P_3,fluid);
% T_19 j� declarada de 400�C
h_19 = CoolProp.PropsSI('H','T',T_19,'P',P_3,fluid); 
s_19 = CoolProp.PropsSI('S','T',T_19,'P',P_3,fluid);
T_20 = T_19 / ((P_3/P_1)^((k-1)/k)); % sa�da da turbina 2
h_20 = CoolProp.PropsSI('H','T',T_20,'P',P_3,fluid);
s_20 = CoolProp.PropsSI('S','T',T_20,'P',P_3,fluid);

%% C�lculo da produ��o de l�quido durante o armazenamento para 5 MFR's
MFR = [0.01 0.05 0.15 0.35 1]; % 5 pontos entre 0 e 1
[~,tot1] = size(MFR);
eps = 0.8; % efetividade dos trocadores
[~,tot2]=size(eps);
z = linspace(0.05,0.9,100); % fra��o de extra��o para T1
[~,tot3] = size(z);
m_B =  MFR * m_C;
x1a =zeros(size(tot3));
x2a =zeros(size(tot3));
x3a =zeros(size(tot3));
x4a =zeros(size(tot3));
x5a =zeros(size(tot3));
for i=1:tot1
    for j=1:tot2
        for k=1:tot3
            if i==1
            x1a(k) = prod_liq_transiente(h_3,h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z(k),h_13,h_14,eps(j),eta_t);
            if x1a(k) < 0
                x1a(k) = NaN;
            end
            end
            if i==2
            x2a(k) = prod_liq_transiente(h_3,h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z(k),h_13,h_14,eps(j),eta_t);
            if x2a(k)<0
                x2a(k) = NaN;
            end
            end
            if i==3
            x3a(k) = prod_liq_transiente(h_3,h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z(k),h_13,h_14,eps(j),eta_t);
            if x3a(k)<0
                x3a(k) = NaN;
            end
            end
            if i==4
            x4a(k) =prod_liq_transiente(h_3,h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z(k),h_13,h_14,eps(j),eta_t);
            if x4a(k)<0
                x4a(k) = NaN;
            end
            end
            if i==5
            x5a(k) = prod_liq_transiente(h_3,h_1,h_8,m_B(i),m_C,rho_9,v_8,h_9,z(k),h_13,h_14,eps(j),eta_t);
            if x5a(k)<0
                x5a(k) = NaN;
            end
            end         
        end
    end
end
%% Gr�ficos da Produ��o de l�quido fun� da extra��o para T1
MFR1 = sprintf('MFR = %0.01g',MFR(1)); MFR2 = sprintf('MFR = %0.01g',MFR(2));
MFR3 = sprintf('MFR = %0.01g',MFR(3)); MFR4 = sprintf('MFR = %0.01f',MFR(4)); 
MFR5 = sprintf('MFR = %0.001g',MFR(5));
figure()
subplot(1,2,1)
plot(z,x1a,':k',z,x2a,'-+b',z,x3a,'-*r',z,x4a,'-.g',z,x5a,'--c')
legend(MFR1,MFR2,MFR3,MFR4,MFR5)
xlim([0.2,0.75])%,ylim([0.1,inf])
xlabel('Extra��o para Turbina 1 - z');
ylabel('Produ��o de l�quido - x')

subplot(1,2,2)
plot(z,x1a,':k',z,x2a,'-+b',z,x3a,'-*r',z,x4a,'-.g',z,x5a,'--c')
legend(MFR1,MFR2,MFR3,MFR4,MFR5)
xlim([0.6,0.68]),ylim([0.12,0.14])
xlabel('Extra��o para Turbina 1 - z');
ylabel('Produ��o de l�quido - x')

%% Trabalhos e pot�ncias
w_C = tcompressor_entalpia (h_2,h_1,eta_c);
W_C = w_C * m_C;
w_B = tbomba_entalpia(h_15,h_8,eta_b);%trabalho na bomba
W_B = w_B * m_B; % Pot�ncia na bomba
w_T1 = tturbina(h_13,h_14,eta_t);
W_T1 = w_T1 * z * m_C;
w_T2 = tturbina(h_19,h_20,eta_t);
W_T2 = w_T2 * m_B;
q_TC5 = calortc(h_17,h_16);
Q_TC5 = q_TC5 * m_B;
q_TC6 = calortc(h_19,h_18);
Q_TC6 = q_TC6 * m_B;

%% Trabalho l�quido espec�fico
[~,tot4] = size(x1a);
w_le_C1= zeros(size(x1a));
w_le_C2= zeros(size(x1a));
w_le_C3= zeros(size(x1a));
w_le_C4= zeros(size(x1a));
w_le_C5= zeros(size(x1a));
for i=1:tot4
    w_le_C1(i)= w_C / x1a(i);
    w_le_C2(i)= w_C / x2a(i);
    w_le_C3(i)= w_C / x3a(i);
    w_le_C4(i)= w_C / x4a(i);
    w_le_C5(i)= w_C / x5a(i);
end
% %% Gr�ficos do trabalho liq espec�fico do compressor fun� da extra��o para T1
% figure()
% plot (W_T1,w_le_C1,'--k',W_T1,w_le_C2,'-.r',W_T1,w_le_C3,':c',W_T1,w_le_C4,'g',W_T1,w_le_C5,'b')
% legend (MFR1,MFR2,MFR3,MFR4,MFR5)
% xlim([1.7e5 2.1e5])
% grid on
% xlabel('Pot�ncia na Turbina 1')
% ylabel('Trabalho l�quido espec�fico - kJ/kg_{ar}')

%%  Trabalho liq espec do compressor fun� extra��o z
figure()
subplot(1,2,1)
plot (z,w_le_C1,'--k',z,w_le_C2,'-.r',z,w_le_C3,':c',z,w_le_C4,'g',z,w_le_C5,'b')
legend(MFR1,MFR2,MFR3,MFR4,MFR5)
xlim([0.3 inf]),ylim([0 0.5e8])
xlabel('Extra��o para Turbina 1 - z')
ylabel('Trabalho l�quido espec�fico - kJ/kg_{ar}')

subplot(1,2,2)
plot (z,w_le_C1,'--k',z,w_le_C2,'-.r',z,w_le_C3,':c',z,w_le_C4,'g',z,w_le_C5,'b')
legend(MFR1,MFR2,MFR3,MFR4,MFR5)
xlim([0.62 0.67]),ylim([1.15e7 1.22e7])
xlabel('Extra��o para Turbina 1 - z')
ylabel('Trabalho l�quido espec�fico - kJ/kg_{ar}')


%% C�lculo do tempo de armazenamento
% quando m_B > x*m_C n�o h� armazenamento
% se MFR > x ocorre descarga
rho_liq = CoolProp.PropsSI('D','T',T_8,'Q',0,fluid);%densidade do l�quido
m_l = (5/100) * rho_liq * v_tanque;% massa inicial de l�quido no reservat�rio 5%
t_a1 = zeros(size(tot3));
t_a2 = zeros(size(tot3));
t_a3 = zeros(size(tot3));
t_a4 = zeros(size(tot3));
t_a5 = zeros(size(tot3));
E_a1 = zeros(size(tot3));
E_a2 = zeros(size(tot3));
E_a3 = zeros(size(tot3));
E_a4 = zeros(size(tot3));
E_a5 = zeros(size(tot3));

for i=1:tot1
    for j=1:tot3
        if i ==1
            t_a1 (j)= tempo_armazenamento(v_tanque,rho_liq,m_l,m_B(i),x1a(j),m_C)/3600;
            if t_a1(j)<0
                t_a1(j) = NaN;
            end
            E_a1 (j)= (W_C + W_B(i) -  W_T2(i) - W_T1(j)) * t_a1(j) / 1000; 
        end
        if i == 2
            t_a2 (j)= tempo_armazenamento(v_tanque,rho_liq,m_l,m_B(i),x2a(j),m_C)/3600;
            if t_a2(j)<0
                t_a2(j) = NaN;
            end
            E_a2 (j)= (W_C + W_B(i) -  W_T2(i) - W_T1(j)) * t_a2(j) / 1000; 
        end       
        if i == 3
            t_a3 (j)= tempo_armazenamento(v_tanque,rho_liq,m_l,m_B(i),x3a(j),m_C)/3600;
            if t_a3(j)<0
                t_a3(j) = NaN;
            end
            E_a3 (j)= (W_C + W_B(i) -  W_T2(i) - W_T1(j)) * t_a3(j) / 1000; 
        end        
        if i == 4
            t_a4 (j)= tempo_armazenamento(v_tanque,rho_liq,m_l,m_B(i),x4a(j),m_C)/3600;
            if t_a4(j)<0
                t_a4(j) = NaN;
            end
            E_a4 (j)= (W_C + W_B(i) -  W_T2(i) - W_T1(j)) * t_a4(j) / 1000; 
        end
        if i == 5
            t_a5 (j)= tempo_armazenamento(v_tanque,rho_liq,m_l,m_B(i),x5a(j),m_C)/3600;
            if t_a5(j)<0
                t_a5(j) = NaN;
            end
            E_a5 (j)= (W_C + W_B(i) -  W_T2(i) - W_T1(j)) * t_a5(j) / 1000; 
        end
    end
end

%%  Gr�fico Tempo de armazenamento fun��o da extra��o
figure()
plot(z,t_a1,':k',z,t_a2,'-+b',z,t_a3,'-*r',z,t_a4,'-.g',z,t_a5,'--c')
legend(MFR1,MFR2,MFR3,MFR4,MFR5)
xlim([0.3 0.9])
ylim([0 20])
xlabel('Extra��o para Turbina 1 - z');
ylabel('Tempo de carregamento do tanque - em horas')

%% 
figure()
plot(x1a,t_a1)
legend(MFR1)
%xlim([0.04 inf])
ylim([0 20])
xlabel('produ��o de l�quido');
ylabel('Tempo de carregamento do tanque - em horas')
%%
figure()
plot(x2a,t_a2)
legend(MFR2)
%xlim([0.04 inf])
ylim([0 20])
xlabel('produ��o de l�quido');
ylabel('Tempo de carregamento do tanque - em horas')

%%
figure()
plot(x3a,t_a3,'--*r')
legend(MFR3)
%xlim([0.8 1])
ylim([0 20])
grid on
xlabel('produ��o de l�quido');
ylabel('Tempo de carregamento do tanque - em horas')
% %%
% figure()
% plot(x4a,t_a4)
% legend(MFR4)
% %xlim([0.8 1])
% %ylim([0 40000])
% grid on
% xlabel('produ��o de l�quido');
% ylabel('Tempo de carregamento do tanque - em horas')
% %%
% figure()
% plot(x5a,t_a5)
% legend(MFR5)
% %xlim([0.8 1])
% %ylim([0 40000])
% grid on
% xlabel('produ��o de l�quido');
% ylabel('Tempo de carregamento do tanque - em horas')

% %% C�lculo da Energia Armazenada
% ze = [0.4 0.65 0.8];
% ze1 = sprintf('z = %0.01f',ze(1));ze2 = sprintf('z = %0.01f',ze(2));ze3 = sprintf('z = %0.01f',ze(3));
% [~,totze] = size(ze);
% for i = 1:tot1
%     for j = 1:totze
%         for k = 1:tot3
%             if i==1
%                 E_a1(j,k) = deltaUa(m_C,m_B(i),x1a(k),ze(j),rho_9,v_8,h_6,h_8,h_9,t_a1(k));
%             end
%             if i == 2
%                 E_a2(j,k) = deltaUa(m_C,m_B(i),x2a(k),ze(j),rho_9,v_8,h_6,h_8,h_9,t_a2(k));
%             end
%             if i == 3
%                 E_a3(j,k) = deltaUa(m_C,m_B(i),x3a(k),ze(j),rho_9,v_8,h_6,h_8,h_9,t_a3(k));
%             end
%             if i == 4
%                 E_a4(j,k) = deltaUa(m_C,m_B(i),x4a(k),ze(j),rho_9,v_8,h_6,h_8,h_9,t_a4(k));
%             end
%             if i == 5
%                 E_a5(j,k) = deltaUa(m_C,m_B(i),x5a(k),ze(j),rho_9,v_8,h_6,h_8,h_9,t_a5(k));
%             end
%         end
%     end
% end

% %% gr�ficos da energia armazenada em fun��o da Produ��o de l�quido
% figure()
% plot(x1a,E_a1(1,:),'--r',x1a,E_a1(2,:),'-*g',x1a,E_a1(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR1)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')
% 
% figure()
% plot(x2a,E_a2(1,:),'--r',x2a,E_a2(2,:),'-*g',x2a,E_a2(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR2)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')
% 
% 
% figure()
% plot(x3a,E_a3(1,:),'--r',x3a,E_a3(2,:),'-*g',x3a,E_a3(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR3)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')
% 
% 
% figure()
% plot(x4a,E_a4(1,:),'--r',x4a,E_a4(2,:),'-*g',x4a,E_a4(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR4)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')
% 
% 
% figure()
% plot(x5a,E_a5(1,:),'--r',x5a,E_a5(2,:),'-*g',x5a,E_a5(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR5)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')
% %% Energia armazenada em fun��o dos tempos de armazenamento
% 
% figure()
% plot(t_a1h,E_a1(1,:),'--r',t_a1h,E_a1(2,:),'-*g',t_a1h,E_a1(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR1)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')
% 
% figure()
% plot(t_a2h,E_a2(1,:),'--r',t_a2h,E_a2(2,:),'-*g',t_a2h,E_a2(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR2)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')


% figure()
% plot(t_a3h,E_a3(1,:),'--r',t_a3h,E_a3(2,:),'-*g',t_a3h,E_a3(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR3)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')
% 
% 
% figure()
% plot(t_a4h,E_a4(1,:),'--r',t_a4h,E_a4(2,:),'-*g',t_a4h,E_a4(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR4)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')
% 
% 
% figure()
% plot(t_a5h,E_a5(1,:),'--r',t_a5h,E_a5(2,:),'-*g',t_a5h,E_a5(3,:),':b')
% xlim([0 inf])
% ylim([0 inf])
% legend(ze1,ze2,ze3)
% title(MFR5)
% ylabel('Energia armazenada')
% xlabel('Tempo de armazenamento')





%% Efici�ncia round-trip (ida e volta) ---------------------------------
% Energia gerada / energia consumida no armazenamento
load('E_liq_ger.mat') % carregando dados de Energia Gerada

% ga1 = combvec(E_liq1,E_a1);
% [~,totrt] = size(ga1);
% eg1 = ga1(1,:);
% ea1 = ga1(2,:);
% ga2 = combvec(E_liq2,E_a2);
% eg2= ga2(1,:);
% ea2 = ga2(2,:);
% ga3 = combvec(E_liq3,E_a3);
% eg3= ga3(1,:);
% ea3 = ga3(2,:);
% ga4 = combvec(E_liq4,E_a4);
% eg4= ga4(1,:);
% ea4= ga4(2,:);
% ga5 = combvec(E_liq5,E_a5);
% eg5= ga5(1,:);
% ea5 = ga5(2,:);
% for i=1:totrt
%     eta_rt1(i) = eg1(i)/ea1(i);
%     eta_rt2(i) = eg2(i)/ea2(i);
%     eta_rt3(i) = eg3(i)/ea3(i);
%     eta_rt4(i) = eg4(i)/ea4(i);
%     eta_rt5(i) = eg5(i)/ea5(i);
% end


%% C�lculos Efici�ncia RT
[~,totrt] = size(E_liq1);
    eta_rt11 = zeros(size(totrt));
    eta_rt12= zeros(size(totrt));
    eta_rt13= zeros(size(totrt));
    eta_rt14= zeros(size(totrt));
    eta_rt15= zeros(size(totrt));
    eta_rt21= zeros(size(totrt));
    eta_rt22= zeros(size(totrt));
    eta_rt23= zeros(size(totrt));
    eta_rt24= zeros(size(totrt));
    eta_rt25= zeros(size(totrt));
    eta_rt31= zeros(size(totrt));
    eta_rt32= zeros(size(totrt));
    eta_rt33= zeros(size(totrt));
    eta_rt34= zeros(size(totrt));
    eta_rt35= zeros(size(totrt));
    eta_rt41= zeros(size(totrt));
    eta_rt42= zeros(size(totrt));
    eta_rt43= zeros(size(totrt));
    eta_rt44= zeros(size(totrt));
    eta_rt45= zeros(size(totrt));
    eta_rt51= zeros(size(totrt));
    eta_rt52= zeros(size(totrt));
    eta_rt53= zeros(size(totrt));
    eta_rt54= zeros(size(totrt));
    eta_rt55= zeros(size(totrt));

for i=1:totrt
    eta_rt11(i) = E_liq1(i)/ E_a1(i);
    eta_rt12(i) = E_liq1(i)/ E_a2(i);
    eta_rt13(i) = E_liq1(i)/ E_a3(i);
    eta_rt14(i) = E_liq1(i)/ E_a4(i);
    eta_rt15(i) = E_liq1(i)/ E_a5(i);
    eta_rt21(i) = E_liq2(i)/ E_a1(i);
    eta_rt22(i) = E_liq2(i)/ E_a2(i);
    eta_rt23(i) = E_liq2(i)/ E_a3(i);
    eta_rt24(i) = E_liq2(i)/ E_a4(i);
    eta_rt25(i) = E_liq2(i)/ E_a5(i);
    eta_rt31(i) = E_liq3(i)/ E_a1(i);
    eta_rt32(i) = E_liq3(i)/ E_a2(i);
    eta_rt33(i) = E_liq3(i)/ E_a3(i);
    eta_rt34(i) = E_liq3(i)/ E_a4(i);
    eta_rt35(i) = E_liq3(i)/ E_a5(i);
    eta_rt41(i) = E_liq4(i)/ E_a1(i);
    eta_rt42(i) = E_liq4(i)/ E_a2(i);
    eta_rt43(i) = E_liq4(i)/ E_a3(i);
    eta_rt44(i) = E_liq4(i)/ E_a4(i);
    eta_rt45(i) = E_liq4(i)/ E_a5(i);
    eta_rt51(i) = E_liq5(i)/ E_a1(i);
    eta_rt52(i) = E_liq5(i)/ E_a2(i);
    eta_rt53(i) = E_liq5(i)/ E_a3(i);
    eta_rt54(i) = E_liq5(i)/ E_a4(i);
    eta_rt55(i) = E_liq5(i)/ E_a5(i);
end

%% Gr�ficos eficiencia RT
% MFR = [0.01 0.05 0.15 0.35 1];
figure()
plot(z,eta_rt11,':k',z,eta_rt12,'--k',z,eta_rt13,'-*b',z,eta_rt14,'--+g',z,eta_rt15,'r')
ylim([0 inf])
title('MFR_{ger} = 0,01')
legend('MFR_{arm} = 0.01','MFR_{arm} = 0,05','MFR_{arm} = 0,15','MFR_{arm} = 0,35','MFR_{arm} = 1')
xlabel('Extra��o para Turbina 1')
ylabel('Efici�ncia roundtrip - \eta_{RT}')
 
%%
figure()
plot(z,eta_rt21,':k',z,eta_rt22,'--k',z,eta_rt23,'-*b',z,eta_rt24,'--+g',z,eta_rt25,'r')
ylim([0 inf])
title('MFR_{ger} = 0,75')
legend('MFR_{arm} = 0.01','MFR_{arm} = 0,05','MFR_{arm} = 0,15','MFR_{arm} = 0,35','MFR_{arm} = 1')
xlabel('Extra��o para Turbina 1')
ylabel('Efici�ncia roundtrip - \eta_{RT}')

%%
figure()
plot(z,eta_rt31,':k',z,eta_rt32,'--k',z,eta_rt33,'-*b',z,eta_rt34,'--+g',z,eta_rt35,'r')
ylim([0 inf])
title('MFR_{ger} = 2')
legend('MFR_{arm} = 0.01','MFR_{arm} = 0,05','MFR_{arm} = 0,15','MFR_{arm} = 0,35','MFR_{arm} = 1')
xlabel('Extra��o para Turbina 1')
ylabel('Efici�ncia roundtrip - \eta_{RT}')

%%
figure()
plot(z,eta_rt41,':k',z,eta_rt42,'--k',z,eta_rt43,'-*b',z,eta_rt44,'--+g',z,eta_rt45,'r')
ylim([0 inf])
title('MFR_{ger} = 4')
legend('MFR_{arm} = 0.01','MFR_{arm} = 0,05','MFR_{arm} = 0,15','MFR_{arm} = 0,35','MFR_{arm} = 1')
xlabel('Extra��o para Turbina 1')
ylabel('Efici�ncia roundtrip - \eta_{RT}')

%%
figure()
plot(z,eta_rt51,':k',z,eta_rt52,'--k',z,eta_rt53,'-*b',z,eta_rt54,'--+g',z,eta_rt55,'r')
ylim([0 inf])
title('MFR_{ger} = 6')
legend('MFR_{arm} = 0.01','MFR_{arm} = 0,05','MFR_{arm} = 0,15','MFR_{arm} = 0,35','MFR_{arm} = 1')
xlabel('Extra��o para Turbina 1')
ylabel('Efici�ncia roundtrip - \eta_{RT}')



        
     
       





