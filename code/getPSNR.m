function  psnr= getPSNR(pPSNR,distance,factor)
psnr = 10 * log10(pPSNR*pPSNR*factor/distance);
end