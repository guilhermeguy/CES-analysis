%função de cálculo do trabalho da turbina
%entrada de dados (he,hs,eta_iso,eta_el,eta_mec)

function w_t = tturbina (he,hs,eta_t)
w_t = (he-hs)*(eta_t);
end
