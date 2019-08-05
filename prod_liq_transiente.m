function x = prod_liq_transiente(h_3,h_1,h_8,m_B,m_C,rho_9,v_8,h_9,z,h_13,h_14,eps,eta_iso)
syms xl
xl = solve(((h_1-h_3 - (1-eps)*(h_1-h_9))+(m_B/m_C)*h_8 + ...
  (1/m_C) * Etransiente(xl,m_C,m_B,h_8,h_9,rho_9,v_8) + gama(xl,m_C,m_B,rho_9,v_8) * h_1) ...
   /(h_1-(1-eps)*(h_1-h_9)) + z*eta_iso*((h_13-h_14)/(h_1-(1-eps)*(h_1-h_9)))-xl);
xl = double(xl);
if m_B/m_C + z < 1- (1/m_C)*Mtransiente(xl,m_C,m_B,rho_9,v_8)
    x = xl;
end
if m_B/m_C + z> 1- (1/m_C)*Mtransiente(xl,m_C,m_B,rho_9,v_8)
    x = 0.99 - z;
end
end

    