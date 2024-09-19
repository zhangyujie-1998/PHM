function [pc_sgwt_cell, smoothness, G] = calculate_wavelet(pc_coor, pc_color, param)

pc_coor = double(pc_coor);
pc_count = size(pc_coor,1);
pc_luminance = pc_color * [0.299, 0.587,0.114]';

setting.k = param.k;
setting.weight_kernel = @(x, sigma) exp(-x/sigma);
setting.use_l1 = 0;
G = gsp_nn_graph(pc_coor, setting);
G = gsp_estimate_lmax(G);
lmax = G.lmax;


L = G.L;
smoothness_x = sparse(pc_coor(:,1))' * L * sparse(pc_coor(:,1)) ;
smoothness_y = sparse(pc_coor(:,2))' * L * sparse(pc_coor(:,2));
smoothness_z = sparse(pc_coor(:,3))' * L * sparse(pc_coor(:,3));
smoothness = [smoothness_x, smoothness_y, smoothness_z]/pc_count;

switch param.type
    case 'abspline3'
        g = sgwt_filter_design(lmax,param.Nscales-1);
    case 'mexican_hat'
        g = gsp_design_mexican_hat(G, param.Nscales);
    case 'meyer'
        g = gsp_design_meyer(G, param.Nscales);
    case 'simple_tf'
        g = gsp_design_simple_tf(G, param.Nscales);
    case 'itersine'
        g = gsp_design_itersine(G ,param.Nscales);
    case 'half_cosine'
        g = gsp_design_half_cosine(G, param.Nscales);
    case 'warp'
        g = gsp_design_warped_translates(G, param.Nscales);
    otherwise
        error('Unknown wavelet type')
end

pc_sgwt = gsp_filter_analysis(G,g,pc_luminance);
pc_sgwt = reshape(pc_sgwt, size(pc_coor,1), param.Nscales);
pc_sgwt_cell = cell(1,param.Nscales);

for i = 1:param.Nscales
    pc_sgwt_cell{1,i} = pc_sgwt(:,i);
end








