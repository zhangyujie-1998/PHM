function [s] = similarity_cov(X,Y,T)
    cov_mat = cov(X,Y);
    s = (cov_mat(1,2)+T)/(sqrt(cov_mat(1,1)*cov_mat(2,2))+T);