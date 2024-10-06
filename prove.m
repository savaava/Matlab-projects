k=1;
M=2^k;
SNRdB = -2;
SNR = 10^(SNRdB/10);

2*(M-1)/M * qfunc(sqrt(6*k/(M^2-1)*SNR))
qfunc(sqrt(2*SNR))