% trabalho do compressor
% entrada de dados (hs,he,eta_iso,eta_el,eta_mec)

function w_c = tcompressor_entalpia(hs,he,eta_c)
w_c = (hs-he)/(eta_c);
end