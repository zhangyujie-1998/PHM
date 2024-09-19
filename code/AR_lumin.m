function [pc_r_predict_color, residual_color, ar_param] = AR_lumin(pc_r, idx_r, K)
 
   pc_r_color = single(pc_r(:,4:6));
   pc_r_lumin = pc_r_color * [0.299, 0.587,0.114]';

   pc_source_lumin = pc_r_lumin ;
 
   nei_r_idx = idx_r(:,2:end)';

   weight_r_kron = 1;
   
   nei_lumin  = pc_source_lumin(nei_r_idx(:),:);
   nei_lumin_T = nei_lumin';
   nei_lumin_v = nei_lumin_T(:);
   nei_lumin_reshape = (reshape(nei_lumin_v, (K-1), []))';

   A = nei_lumin_reshape .* weight_r_kron;
   b = pc_r_lumin;

   [ar_param, pc_r_predict_color, residual_color] = autoregressive_vector(A, b);



