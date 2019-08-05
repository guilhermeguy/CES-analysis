% trabalho do compressor
% entrada de dados (hs,he,eta_iso,eta_el,eta_mec)

function w_c = tcompressor(v_g,p_e,p_s,eta_c)
w_c = v_g * (p_s-p_e)/(eta_c);
end