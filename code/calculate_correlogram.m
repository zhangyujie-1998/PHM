function results = calculate_correlogram(pc_r_sgwt,  pc_d_sgwt, G_r, G_d, param, T)

bin_num = param.bin_num + 1;

for i = 1:param.Nscales
   pc_sgwt_r = pc_r_sgwt{1,i};

   pc_sgwt_d = pc_d_sgwt{1,i};

   max_sgwt = max(max(pc_sgwt_r), max(pc_sgwt_d));
   min_sgwt = min(min(pc_sgwt_r), min(pc_sgwt_d));
   bin_sgwt = linspace(min_sgwt,max_sgwt,bin_num);


   [wavelet_correprob_W_r] = calculate_correprob(pc_sgwt_r, bin_sgwt, G_r.A, G_r.W);
   [wavelet_correprob_W_d] = calculate_correprob(pc_sgwt_d, bin_sgwt, G_d.A, G_d.W);

   sim_cov_W(1,i) = similarity_cov(wavelet_correprob_W_r, wavelet_correprob_W_d,T); 

end

 results = [sim_cov_W];  