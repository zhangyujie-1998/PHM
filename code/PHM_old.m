function score = PHM_old(pt_r, pt_d, pt_fast, param)

%% Parameter Setting
T = 0.000001;
center = pt_fast.Location;
pc_r_coor0 = pt_r.Location;
pc_d_coor0 = pt_d.Location;
pc_r_color0 = single(pt_r.Color);
pc_d_color0 = single(pt_d.Color);
patch_num = pt_fast.Count;


%% Visible Difference Measurement
pc_r0 = [pc_r_coor0, pc_r_color0];
pc_d0 = [pc_d_coor0, pc_d_color0];

K = param.AR_order + 1;
[idx_cluster_r, ~] = knnsearch(center, pc_r_coor0, 'K', 1, 'Distance','euclidean');
[idx_cluster_d, ~] = knnsearch(center, pc_d_coor0, 'K', 1, 'Distance','euclidean');
[idx_r_knn, ~] = knnsearch(pc_r_coor0, pc_r_coor0, 'K', K, 'Distance','euclidean');
[~, pc_r_residual_lumin, ~] = AR_lumin(pc_r0, idx_r_knn,  K);

randomness = log2(1+mean(abs(pc_r_residual_lumin))); % Calculate the texture complexity

PSNR_lumin1 = calculate_PSNR_lumin(pc_r0, pc_d0); % Calculate the luminance PNSR 
PSNR_lumin2 = calculate_PSNR_lumin(pc_d0, pc_r0);
PSNR_lumin = min(PSNR_lumin1, PSNR_lumin2); 
D_H =  (PSNR_lumin+ 4.5*randomness)/(10*log10(255^2)+36); % Texture masking compensenation

%% Appearance Degradation Measurement

for i = 1:patch_num
   center_coor = center(i,:);
   
   indx_r = find(idx_cluster_r == i);
   indx_d = find(idx_cluster_d == i);
   point_num_r(i) = length(indx_r);
   pc_r_coor = pc_r_coor0(indx_r, :);
   pc_r_color = pc_r_color0(indx_r,:);
   pc_d_coor =  pc_d_coor0(indx_d, :);
   pc_d_color = pc_d_color0(indx_d, :);
   count_r = size(pc_r_coor,1);
   count_d = size(pc_d_coor,1);

   if (size(pc_d_coor, 1) > param.k) && (size(pc_r_coor, 1) > param.k)
        [pc_r_sgwt, smoothness_r, G_r] = calculate_wavelet(pc_r_coor, pc_r_color, param);
        [pc_d_sgwt, smoothness_d, G_d] = calculate_wavelet(pc_d_coor, pc_d_color, param);
        sim_smoothness(i,:) = similarity(smoothness_r, smoothness_d, T); % Calculate the graph smoothness of geomtry information
        sim_WCM(i,:) = calculate_correlogram(pc_r_sgwt,  pc_d_sgwt, G_r, G_d, param, T); %Calculate the WCM of attribute information
   else
        sim_smoothness(i,:) = zeros(1,3);
        sim_WCM(i,:) = zeros(1,param.Nscales);
   end

end

D_LO = mean(mean(sim_smoothness));  % Calculate geometry appearance degradation 
D_LI = mean(mean(sim_WCM)); % Calculate texture appearance degradation 
D_L = sqrt(D_LO .* D_LI);

%% Adaptive Combination
w = 1./(1+5*D_H);
score = D_H .^(1-w) .* D_L.^w;


