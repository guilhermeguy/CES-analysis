%função para cálculo de gama

function gama = gama(x,m_C,m_B,rho_9,v_8)
gama = rho_9*v_8*(x-m_B/m_C);
end