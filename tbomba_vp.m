% função de cálculo do trabalho da bomba
% entrada de dados(hs,he,eta_iso,eta_el,eta_mec)

function w_b = tbomba (v_l,p_s,p_e,eta_b)
w_b = (v_l*(p_s-p_e))/ (eta_b);
end
