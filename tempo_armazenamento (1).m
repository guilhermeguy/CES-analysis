% função de cálculo de tempo de carregamento do tanque
% sintaxe tempod(v_tanque,densidade do liq,massa de liq inicial,m_B,x,m_C)
function deltat = tempo_armazenamento(v_tanque,rho_liq,m_l,m_B,x,m_C)
deltat= (v_tanque * rho_liq - m_l)/(x * m_C - m_B);
end