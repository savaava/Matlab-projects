function Pb=prova(SNRdB,MonteCarlo)

SNR=10.^(SNRdB/10);
N0=1;
Ene=SNR*N0;

for i=1:length(SNR)
    Enenow=Ene(i);
    bitTx=randi(2,1,MonteCarlo)-1;
    sym=bitTx*(2*sqrt(Enenow))-sqrt(Enenow);
    r=sym+randn(1,MonteCarlo)*sqrt(N0/2);
    bitRx=r>0;
    Pb(i)=mean(bitTx~=bitRx);
end

Pbteoria=qfunc(sqrt(2*SNR));

semilogy(SNRdB,Pb,'ro','MarkerSize',8)
hold on
semilogy(SNRdB,Pbteoria,'k-','LineWidth',2)
xlabel('SNR in dB')
ylabel('Probabilità di errore di bit')
set(gca,'FontSize',16)
grid minor