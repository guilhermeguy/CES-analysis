%função para produção de líquido no circuito de armazenamento (vazão na T1
%diferente de zero em regime permanente.

function x = prodliq_ap(h_1,h_3,eps,h_9,eta_iso,z,h_13,h_14,h_8)
xl = ((h_1-h_3-(1-eps)*(h_1-h_9))+ eta_iso * z *(h_13-h_14))/(h_1-h_8-(1-eps)*(h_1-h_9));
if xl + z <1
    x=xl;
end
if xl+z> 1
    x = 0.99-z;
end
end