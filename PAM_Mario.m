function [Pe_s, Pe_b] = PAM_Mario(SNRdB, k, MC, flag)
% M-PAM con un intervallo di diversi SNR -> mostra quindi un grafico
% di valutazione delle prestazioni in base a SNR e Pe, confrontato con 
% quello teorico

% INPUT
% SNRdB = rapporto segnale rumore per SIMBOLO in decibel
% k = numero di bit per simbolo
% flag = 1 se voglio stampare la modulazione e dei messaggi di output
% flag = 0 se voglio solo il grafico delle prestazioni

% OUTPUT
% Pe_s = probabilità di errore di simbolo stimata per ogni SNR
% Pe_b = probabilità di errore di bit stimata per ogni SNR

%% Parametri
M = 2^k;
SNR = 10.^(SNRdB/10);
Pe_s = zeros(1,length(SNRdB));
Pe_b = zeros(1,length(SNRdB));
Pe_s_th = 2*(M-1)/M * qfunc(sqrt(6/(M^2-1)*SNR));
Pe_b_th = Pe_s_th/k;

%% Calcolo della Pe per simbolo per tutti gli SNR presi in input
for ii=1:length(SNRdB)
    [Pe_s(ii), Pe_b(ii)] = PAM_Mario_util(SNRdB(ii), k, MC, flag);
    %fprintf('SNRdB=%d -> Ps(e)=%f Pb(e)=%f', SNRdB(ii), Pe_s(ii), Pe_b(ii));
end

%% Stampa della Pe e della teorica per un confronto
semilogy(SNRdB, Pe_s, 'ko', SNRdB, Pe_s_th, 'k-', 'MarkerSize', 6);
hold on;
semilogy(SNRdB, Pe_b_th, 'b-', SNRdB, Pe_b, 'bo', 'MarkerSize', 6);
hold on;
title(M+"-PAM")
xlabel('\gamma_b (dB)')
ylabel('P(e)')
grid on