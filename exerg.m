% função para cálculo da exergia
%sintaxe exerg(h_i,h_0,T_0,s_i,s_0)
function e_i = exerg(h_i,h_0,T_0,s_i,s_0)
e_i = (h_i-h_0)-T_0*(s_i-s_0);
end
