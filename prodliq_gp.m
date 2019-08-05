function x = prodliq_gp(h_1,h_6,eps,h_9,h_8)
x = (h_1 - h_6 - (1-eps)*(h_1-h_9)) / (h_1 - h_8 - (1-eps)*(h_1-h_9));
end