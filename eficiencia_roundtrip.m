% função para eficiência ida e volta
function eta_rt = eficiencia_roundtrip (m_Bg,m_Cg,m_Ba,m_Ca,W_T2g,W_Bg,W_Cg,t_g,W_Ca,W_Ba,W_T2a,W_T1a,x_a,t_a)
eta_rt = ((m_Bg*W_T2g-m_Bg*W_Bg-m_Cg*W_Cg)*t_g)/((m_Ca*W_Ca+m_Ba*W_Ba-m_Ba*W_T2a-x_a*m_Ca*W_T1a)*t_a);
end