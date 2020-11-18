def gama_func(x, m_C, m_B, rho, volume):
    gama = rho * volume * (x - m_B / m_C)
    return gama

#Funcão para cálculo da variação da massa no reservatório durante o armazenamento
def deltaM(z, m_C, m_B, x, rho, volume):
    dmdt = ((1-z) * m_C - m_B + (1 - x - z - gama_func(rho, volume, x, m_B, m_C) * m_C))
    return dmdt

def deltaUd(mc, mb, gama, x, ha, hb, hc, t):
    dudt_d = ((mc * ha) - (mb * hb) + (1 - x  + gama) * mc * hc) * t
    return dudt_d

# produção de líquido em regime permanente
def prodliq_ap(ha,hb,eps,hc,eta_iso,z,hd,he,hf):

    xl = ((ha - hb - (1 - eps) * (ha - hc)) + eta_iso * z * (hd-he)) / (ha - hf - (1 - eps) * (ha - hc))
    if xl + z < 1:
        return xl
    else:
        return 0.99 - z
