''' 
Rotina para cálculo dos parâmetros mais importantes para avaliação do desempenho de um CES
Grandezas no SI (temperatura em Kelvin, pressão em Pascal, massa em kg, etc.)
@guilherme@inovasol.com
'''
#%% importações

import numpy as np
from scipy.interpolate import griddata
import CoolProp.CoolProp as cp
import matplotlib.pyplot as plt
import CES_funcoes as funcoes

#%% Parâmetros de entrada

fluid = 'Nitrogen'
eta_c = 0.5
eta_t = 0.85
eta_b = 0.75
v_tanque = 35
m_C = 5
T_0 = 298
h_0 = CoolProp.PropsSI(’H’,’T’,T_0,’P’,101325,fluid)
s_0 = CoolProp.PropsSI(’S’,’T’,T_0,’P’,101325,fluid)
k = 1.4
P_1 = 101325
P_2 = 4000000
P_3 = 20000000
T_4 = 298-33
T_1 = T_0
T_3 = T_1
T_19 = 400+273
T_8 = 77.3
Q_8 = 0
T_9 = 77.3
Q_9 = 1
T_7 = 77.3
T_15 = T_8

#%% Propriedades termodinâmicas nos pontos

