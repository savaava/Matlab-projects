function []=PAMconfronto(k,SNRdB,NMC)
% function []=PAMconfronto(k,SNRdB,NMC)
% Confronto tra formula teorica e risultati della simulazione per una trasmissione PAM M-aria
%
% INPUT
% k (scalare) = numero di bit per simbolo
% SNRdB (vettore) = rapporto segnale rumore per bit in decibel
% NMC (scalare) = numero di prove Monte Carlo  (approssimativo) (relativo alla prob. errore sul bit)
%                 [Il numero di prove per la prob. di errore sul simbolo è (circa) NMC/log2(M)]
% OUTPUT
% (di tipo grafico)


SNR=10.^(SNRdB/10);

M=2^k;
P_sym_th=2*(M-1)/M*qfunc(sqrt(6*k/(M^2-1)*SNR));
P_bit_th=P_sym_th/k;
jj=0;

P_sym=NaN(1,length(SNRdB));
P_bit=NaN(1,length(SNRdB));
for SNRdBnow=SNRdB
    jj=jj+1;
    [P_sym(jj), P_bit(jj)]=PAM(NMC,k,SNRdBnow,0);
end

title_string=[num2str(M),'-PAM'];
% semilogy(SNRdB,P_sym_th,'k',SNRdB,P_sym,'ko','MarkerSize',6,'Linewidth',2), hold on
semilogy(SNRdB,P_bit_th,'b-',SNRdB,P_bit,'bs','MarkerSize',6,'Linewidth',2),
% s
grid on
FS=24;
xlabel('\gamma_b (dB)','FontSize',FS), ylabel('Probabilità di errore','FontSize',FS)
title(title_string,'FontSize',FS)
legend('simbolo-teoria','simbolo-simulazione','bit-teoria','bit-simulazione','Location','SouthWest');
set(gca,'FontSize',FS)
