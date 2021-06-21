function ser = errprobMPSK(snrdB,M)
% Cacolo approx con union bound della symbol error probability per M-PSK
snr = 10.^(snrdB/10);
alpha = pi/M;
ser = 2*qfunc(sin(alpha)*sqrt(2*snr));

