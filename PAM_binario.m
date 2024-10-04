function Pe_b = PAM_binario(SNRdB, MonteCarlo)

SNR = 10.^(SNRdB/10);
% il . sta per: deve farlo elemento per elemento
N0 = 1;
E = SNR*N0;
Pe_b = zeros(1, length(SNR));

for i=1:length(SNR)
    Enow = E(i);
    bitTx = randi([0,1],1,MonteCarlo);
    sym = bitTx*(2*sqrt(Enow))-sqrt(Enow);
    % sym è un vettore 1xMonteCarlo di +-sqrt(Enow) 
    % rappresenta i segnali trasmessi -> 1 o 0
    r = sym+randn(1,MonteCarlo)*sqrt(N0/2);
    bitRx = r>0;
    errore = bitTx~=bitRx;
    Pe_b(i) = mean(errore);
    % calcolo la P(e) per l'SNR specifico dell'iterazione, come 
    % #volte ricevuto un altro segnale / numero di segnali trasmessi, ossia MonteCarlo
    fprintf('SNRdB=%d -> %d err su %d trasm -> P(e)= %f (PAM)\n', SNRdB(i), sum(errore), MonteCarlo, Pe_b(i));
    % pause
end

Pe_b_teoria = qfunc(sqrt(2*SNR));

semilogy(SNRdB,Pe_b,'ro','MarkerSize',8)
hold on
semilogy(SNRdB,Pe_b_teoria,'k-','LineWidth',2)
xlabel('SNR in dB')
ylabel('Probabilità di errore di bit')
set(gca,'FontSize',16)
grid minor