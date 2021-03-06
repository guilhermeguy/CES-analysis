import numpy as np

def gama_func(x, m_C, m_B, rho, volume):
    gama = rho * volume * (x - m_B / m_C)
    return gama

#Funcão para cálculo da variação da massa no reservatório durante o armazenamento
def deltaM(z, m_C, m_B, x, rho, volume):
    dmdt = ((1-z) * m_C - m_B + (1 - x - z - gama_func(rho, volume, x, m_B, m_C) * m_C))
    return dmdt

#Trocador de calor
def calortc(hs, he):
    q_tc = hs - he
    return q_tc

def deltaUd(mc, mb, gama, x, ha, hb, hc, t):
    dudt_d = ((mc * ha) - (mb * hb) + (1 - x  + gama) * mc * hc) * t
    return dudt_d

def eficiencia(wg, wc):
    eta_t = wg / wc
    return eta_t
