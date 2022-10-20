%função para cálculo da variação da energia interna do reservatório durante
%o armazenamento. Regime transiente.
% entrada (mc,mb,x,z,rho,v_l,x,h7,h8,h9)

function dudt_a = deltaUa (mc,mb,x,z,rho_vap,v_liq,h7,h8,h9,t)
dudt_a = ((1 - z) * mc * h7 - (mb * h8)+(1 - x - z + gama(x, mc, mb, rho_vap, v_liq)) * mc * h9) * t;
end
