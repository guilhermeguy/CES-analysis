function x = producaoliq (h1,h3,eps,h9,mb,mc,h8,dudt,gama,z,eta_iso,h13,h14)
x = (((h1-h3)-(1-eps).*(h1-h9)) + (mb./mc).*h8 + (1./mc).*(dudt)+ gama.*h1 + z.*eta_iso.*(h13-h14)) ./ (h1-(1-eps).*(h1-h9));
end