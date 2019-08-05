% função de cálculo de tempo de carregamento do tanque
% sintaxe tempod(v_tanque,densidade do liq,massa de liq inicial,m_B,x,m_C)
function deltat = tempo_descarga(massa_liquido,m_B,x,m_C)
deltat= (massa_liquido)/(m_B - x * m_C);
end