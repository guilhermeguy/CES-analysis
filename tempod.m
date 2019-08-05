% função de cálculo de tempo de descarga do tanque
% sintaxe tempod(massa de liq no tanque,m_B,x,m_C)
function deltat = tempod(massa_l,m_B,x,m_C)
deltat=massa_l/(m_B-x*m_C);
end