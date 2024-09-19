function PSNR_lumin = calculate_PSNR_lumin(pcA,pcB)


pcA_cor = pcA(:,1:3);
pcA_col = pcA(:,4:6);
pcA_col = double(pcA_col) * [0.299, 0.587,0.114]';
pcA_lumin = pcA_col;
pcB_cor = pcB(:,1:3);
pcB_col = pcB(:,4:6);


weighted_color = zeros(size(pcA,1),3);

[idx,idt] = knnsearch(pcB_cor,pcA_cor,'K',10); 

for i = 1:size(pcA,1)

    lable = find(idt(i,:)==idt(i,1));
    lable = idx(i,lable);
    [~,colums] = size(lable);
    if (colums==1)
        weighted_color(i,:) = pcB_col(lable,:);
    else
        weighted_color(i,:) = mean(pcB_col(lable,:));
    end
    
end

weighted_lumin = (weighted_color) * [0.299, 0.587,0.114]';

lumin_distance = pcA_lumin - weighted_lumin;
lumin_distance = lumin_distance.^2 ;

MSE_lumin = mean(lumin_distance);
PSNR_lumin = getPSNR(255,MSE_lumin,1);



