% função de cálculo do trabalho da bomba
% entrada de dados(hs,he,eta_iso,eta_el,eta_mec)

function w_b = tbomba_entalpia (hs,he,eta_b)
w_b = (hs-he) / (eta_b);
end
