function dudt_d = deltaUd (mc,mb,gama,x, h7,h8,h9,t)
dudt_d = ((mc * h7) - (mb * h8)+(1-x+gama)*mc*h9)*t;
end