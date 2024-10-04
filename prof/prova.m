function Pe = prova(SNRdB,MonteCarlo)

SNR = 10.^(SNRdB/10);
% il . sta per: deve farlo elemento per elemento
N0 = 1;
E = SNR*N0;
Pe = zeros(1, length(SNR));

for i=1:length(SNR)
    Enow = E(i);
    bitTx = randi([0,1],1,MonteCarlo);
    sym = bitTx*(2*sqrt(Enow))-sqrt(Enow);
    r = sym+randn(1,MonteCarlo)*sqrt(N0/2);
    bitRx = r>0;
    Pe(i) = mean(bitTx~=bitRx);
end

Peteoria = qfunc(sqrt(2*SNR));

semilogy(SNRdB,Pe,'ro','MarkerSize',8)
hold on
semilogy(SNRdB,Peteoria,'k-','LineWidth',2)
xlabel('SNR in dB')
ylabel('Probabilità di errore di bit')
set(gca,'FontSize',16)
grid minor