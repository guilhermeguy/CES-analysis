%função para produção de líquido no circuito de armazenamento (vazão na T1
%diferente de 0) em regime transiente. ver função 'deltaM'
% entrada (h_1,h_3,h_9,eps,h_8,m_C,m_B,z,rho,v_l,h_7,eta_iso,h_13,h_14)
function x = prodliq_at(h_1,h_3,h_9,eps,h_8,m_C,m_B,z,rho,v_l,h_7,eta_iso,h_13,h_14)
syms xl
xl = solve((((h_1-h_3)-(1-eps)*(h_1-h_9)+(m_B/m_C)*h_8+(1/m_C)*deltaUa(m_C,m_B,xl,z,rho,v_l,h_7,h_8,h_9)+gama(rho,v_l,xl,m_B,m_C)*h_1+z*eta_iso*(h_13-h_14))/(h_1-(1-eps)*(h_1-h_9)))-xl);
if m_B/m_C + z <1-(1/m_C)*deltaM(z,m_C,m_B,xl,rho,v_l)
    x=xl;
end
if m_B/m_C + z > 1-(1/m_C)*deltaM(z,m_C,m_B,xl,rho,v_l)
    x = 0.99-z;
end
end

