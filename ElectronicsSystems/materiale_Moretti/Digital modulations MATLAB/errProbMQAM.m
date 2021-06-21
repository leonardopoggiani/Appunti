function sep = errProbMQAM(snrdB,M)
snr = 10.^(snrdB/10);
A = 2*(M-1)/3;
Q = qfunc(sqrt(2*snr/A));
sep = 1-(4*(1-Q).^2+4*(sqrt(M)-2)*(1-Q).*(1-2*Q)+(sqrt(M)-2)^2*(1-2*Q).^2)/M;

