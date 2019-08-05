function Et = Etransiente(x,m_C,m_B,h_8,h_9,rho_9,v_8)
Et = (x*m_C-m_B)*(h_8-h_9*rho_9*v_8);
end