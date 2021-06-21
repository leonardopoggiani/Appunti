load filters

% filtro passa basso a 15 kHz
obj_lpf = dsp.FIRFilter('Numerator', numerator);


figure 
hold on
% filtro passa-basso
[h,f] = freqz(numerator);
f1 = f/(2*pi)*228e3;
semilogy(f1,abs(h))


xline(19e3,'r')
