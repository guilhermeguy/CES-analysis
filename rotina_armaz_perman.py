''' 
Rotina para cálculo dos parâmetros mais importantes para avaliação do desempenho de um CES
Grandezas no SI (temperatura em Kelvin, pressão em Pascal, massa em kg, etc.)
@guilherme@inovasol.com
'''
import numpy as np
from scipy.interpolate import griddata
import CoolProp.CoolProp as cp
import matplotlib.pyplot as plt
import CES_funcoes as funcoes

#%% Parâmetros de entrada
fluid = 'Nitrogen'
eta_c = 0.5
eta_iso = 0.8
eta_t = 0.85
eta_b = 0.75
T_0 = 298
h_0 = cp.PropsSI('H','T',T_0,'P',101325,fluid)
s_0 = cp.PropsSI('S','T',T_0,'P',101325,fluid)
k = 1.4
P_1 = 101325
P_2 = 4e6
P_3 = 2e7
T_4 = 293-33
T_1 = T_0
T_3 = T_1
T_19 = 400+273
T_8 = 77.3
Q_8 = 0
T_9 = 77.3
Q_9 = 1
T_7 = 77.3
T_15 = T_8
m_c = 5

#%% Propriedades termodinâmicas nos pontos

h_1 = cp.PropsSI('H', 'T', T_1, 'P', P_1, fluid)
s_1 = cp.PropsSI('S', 'T', T_1, 'P', P_1, fluid)
T_2 = T_1 * (P_2 / P_1) ** ((k - 1) / k)
h_2 = cp.PropsSI('H','T',T_2,'P',P_2,fluid)
s_2 = cp.PropsSI('S','T',T_2,'P',P_2,fluid)
h_12 = h_1
s_12 = s_1
h_3 = cp.PropsSI('H','T',T_3,'P',P_2,fluid)
s_3 = cp.PropsSI('S','T',T_3,'P',P_2,fluid)
h_8 = cp.PropsSI('H','T',T_8,'Q',Q_8,fluid)
s_8 = cp.PropsSI('S','T',T_8,'Q',Q_8,fluid)
h_9 = cp.PropsSI('H','T',T_9,'Q',Q_9,fluid)
s_9 = cp.PropsSI('S','T',T_9,'Q',Q_9,fluid)
h_4 = cp.PropsSI('H','T',T_4,'P',P_2,fluid)
s_4 = cp.PropsSI('S','T',T_4,'P',P_2,fluid)
h_13 = h_4
s_13 = s_4
T_13 = T_4
T_14 = T_13 / ((P_2 / P_1) ** ((k - 1) / k))
h_14 = cp.PropsSI('H','T',T_14,'P',P_1,fluid)
s_14 = cp.PropsSI('S','T',T_14,'P',P_1,fluid)
T_10 = T_14
h_10 = h_14
s_10 = s_14

#%% Produção de líquido 
z1 = np.linspace(0, 1, 100)
eps1 = np.linspace(0, 1, 100)
zcombeps = np.ones([z1.size * eps1.size,2])
index = 0

[m,n] = zcombeps.shape

for i in z1:
    for j in eps1:
        zcombeps[index, 0] = j
        zcombeps[index, 1] = i
        index += 1
z = zcombeps[:, 1]
eps = zcombeps[:, 0]
x = np.ones(m)
index = 0

for i in z:
    x[index] = funcoes.prodliq_ap(h_1,h_3,eps[index],h_9,eta_iso,z[index],h_13,h_14,h_8)
    if x[index] < 0:
        x[index] = np.nan
    index += 1

[X,Y] = np.meshgrid(z,eps)

Z = griddata((z,eps),x,(X,Y) , method = 'linear')

#%% Gráfico de produção de líquido

[fig, ax] = plt.subplots()
CS = ax.contour(X, Y, Z, 6, colors = 'k', linewidths = 0.5)
ax.clabel(CS, inline = True, inline_spacing = 7, fontsize=10)
ax.set_title('Produção de líquido em regime permanente')
plt.xlabel('Extração para Turbina 1 - z')
plt.ylabel('Efetividade - $\epsilon$')
#plt.savefig('prodliq_ap.jpg', dpi = 600)

#%% Trabalho e potência
m_l = x * m_c
m_b = m_l


h_15 = cp.PropsSI('H', 'T', T_15, 'P', P_3, fluid)
s_15 = cp.PropsSI('S', 'T', T_15, 'P', P_3, fluid)
h_16 = h_15 # não há vazão no TC4
T_16 = T_15 # não há vazão no TC4
h_17 = h_16 + 150000 # carga térmica no TC5 150 kJ / kg
T_17 = cp.PropsSI('T', 'H', h_17, 'P', P_3, fluid)
s_17 = cp.PropsSI('S', 'T', T_17, 'P', P_3, fluid)
T_18 = 273 + 35 # temperatura de saída do cooler
h_18 = cp.PropsSI('H', 'T', T_18, 'P', P_3, fluid)
s_18 = cp.PropsSI('S', 'T', T_18, 'P', P_3, fluid)
h_19 = cp.PropsSI('H', 'T', T_19, 'P', P_3, fluid)
s_19 = cp.PropsSI('S', 'T', T_19, 'P', P_3, fluid)
T_20 = T_19 / ((P_3 / P_1) ** ((k - 1) / k))
h_20 = cp.PropsSI('H', 'T', T_20, 'P', P_3, fluid)
s_20 = cp.PropsSI('S', 'T', T_20, 'P', P_3, fluid)

w_c = (h_2 - h_1) / eta_c # (hs - he) / (eta_c) --  (hs, he, eta_c)
W_c = w_c * m_c 
w_b = (h_15 - h_8) /eta_b # w_b = (hs - he) / eta_b
W_b = w_b * m_b # Potência W e trabalho w 
w_T1 = (h_13 - h_14) / eta_t  # (he, hs, eta_t) -- (he - hs) * eta_t
W_T1 = w_T1 * z * m_c
w_T2 = (h_19 - h_20) * eta_t
W_T2 = w_T2 * m_b

## Trocador de calor (hs, he) -- q_t = hs - he
q_TC5 = (h_17 - h_16)
Q_TC5 = q_TC5 * m_b
q_TC6 = (h_19 - h_18)
Q_TC6 = q_TC6 * m_b

index = 0
w_le_c = np.zeros(m)
for i in x:
  w_le_c[index] = w_c / x[index]
  index += 1
  
plt.plot(z, w_le_c,'-')
ax.set_xlabel('Extração para Turbina By-pass - z')
ax.set_ylabel('Trabalho Líquido')