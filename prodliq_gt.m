% fun��o para produ��o de l�quido durante a gera��o em regime 
%transiente uniforme
% entrada da fun��o(h_1,h_6,eps,h_ 9,mfr,h_8,m_C,dudt,rho,v_l,x(prod liquido),m_B)
function x = prodliq_gt(h_1,h_6,eps,h_9,h_8,m_C,dudt,rho,v_l,x1,m_B)
syms x1
x1 = solve(((h_1-h_6)-(1-eps)*(h_1-h_9)+(m_B / m_C)*h_8+ (1/m_C)*dudt() + gama(rho,v_l,x1,m_B,m_C)*h_12)/(h_1 - (1-eps)*(h_1-h_9))-xl);
if (m_B / m_C) < 1-(1/m_C)*dmdt()
    x = x1;
else 
    x = 0;
end
end
