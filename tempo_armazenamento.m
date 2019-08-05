% função de cálculo de tempo de carregamento do tanque
% sintaxe tempod(massa_liquido,m_B,x,m_C)
function deltat = tempo_armazenamento(massa_liquido,m_B,x,m_C)
deltat= (massa_liquido)/(x * m_C - m_B);
end