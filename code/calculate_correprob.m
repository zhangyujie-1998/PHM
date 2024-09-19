function [wavelet_corregram_W_norm] = calculate_correprob(pc_wavelet, bin, A, W) 

bin_count = size(bin,2)-1;
[~, ~, binIndices] = histcounts(pc_wavelet, bin);

wavelet_corregram_W = zeros(bin_count);
[r, c] = find(A);
idx_r = binIndices(r);
idx_c = binIndices(c);
weight = W(sub2ind(size(W), r, c));


linear_idx = sub2ind([bin_count bin_count], idx_r, idx_c);
wavelet_corregram = accumarray(linear_idx, weight);
[row_idx, col_idx, values] = find(wavelet_corregram);
wavelet_corregram_W(row_idx) = values;
total_weight = sum(sum(wavelet_corregram_W(:)));
wavelet_corregram_W_norm = wavelet_corregram_W / total_weight;
