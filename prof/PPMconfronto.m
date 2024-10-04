function []=PPMconfronto(k,SNRdB,NMC)
% function []=PPMconfronto(k,SNRdB,NMC)
% Confronto tra formula teorica e risultati della simulazione per una trasmissione ortogonale equienergetica M-aria
%
% INPUT 
% k (scalare) = numero di bit per simbolo
% SNRdB (vettore) = rapporto segnale rumore per bit in decibel 
% NMC (scalare) = numero di prove Monte Carlo  (approssimativo) (relativo alla prob. errore sul bit)
%                 [Il numero di prove per la prob. di errore sul simbolo è (circa) NMC/log2(M)]
% OUTPUT
% (di tipo grafico)  


M=2^k;
jj=0;
P_sym=NaN(1,length(SNRdB)); P_bit=NaN(1,length(SNRdB));
P_sym_th=NaN(1,length(SNRdB)); 
for SNRdBnow=SNRdB,
   jj=jj+1;
   P_sym_th(jj)=quad('ker_ort',-5,5,1e-6,[],10.^(SNRdBnow/10),M); % integrazione numerica
   [P_sym(jj), P_bit(jj)]=PPM(NMC,k,SNRdBnow,0);
end
P_bit_th=P_sym_th * 2^(k-1)/(2^k-1);

title_string=[num2str(M),'-PPM'];


semilogy(SNRdB,P_sym_th,'k',SNRdB,P_sym,'ko','MarkerSize',6,'Linewidth',2), hold on
semilogy(SNRdB,P_bit_th,'b--',SNRdB,P_bit,'bs','MarkerSize',6,'Linewidth',2), hold off
grid on
FS=24; 
xlabel('\gamma_b (dB)','FontSize',FS), ylabel('Probabilità di errore','FontSize',FS)
title(title_string,'FontSize',FS)
legend('simbolo-teoria','simbolo-simulazione','bit-teoria','bit-simulazione','Location','SouthWest');
a=gca; set(a,'FontSize',FS)