function sep = errProbMPAM(snrdB,M)
% Calcolo esatto della symbol error probability per M-PAM
snr = 10.^(snrdB/10);
A = (M^2-1)/3;
sep = 2*(M-1)/M*qfunc(sqrt(2*snr/A));

