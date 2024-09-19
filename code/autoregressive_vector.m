function [ar_param, prediction, residual] = autoregressive_vector(A,b)
ar_param = pinv(A'*A)*A'*b;
prediction = A * ar_param;
residual = b - prediction;