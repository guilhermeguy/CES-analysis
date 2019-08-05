%fun��o delta M. C�lculo da varia��o da massa no reservat�rio durante o
%armazenamento.
%entrada (z,mc,mb,x,z,d9,v8,t)
function dmdt = deltaM (z,m_C,m_B,x,rho,v8)
dmdt = ((1-z)*m_C-m_B+(1-x-z-gama(rho,v8,x,m_B,m_C)*m_C));
end