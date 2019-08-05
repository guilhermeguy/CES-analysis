%função para cálculo da irreversibilidade específica 
% entrada(exergia no ponto inicial, exergia no ponto final, trabalho
% produzido (negativo) ou consumido).
%sintaxe irrev(e_i,e_f,w)

function I_i = irrev (e_i,e_f,w) 
I_i = e_i - e_f + w;
end