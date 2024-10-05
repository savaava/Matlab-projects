function Pe_b = PPM_binario(SNRdB, MonteCarlo)

SNR = 10.^(SNRdB/10);
N0 = 1;
E = SNR*N0;
errore = zeros(1,MonteCarlo);
Pe_b = zeros(1,length(SNR));

for i=1:length(SNR)
    Enow = E(i);
    for z=1:MonteCarlo
        bitTx = randi([0,1]);
        if(bitTx == 1)
            sym = [sqrt(Enow),0]; %trasmetto 1
        else
            sym = [0,sqrt(Enow)]; %trasmetto 0
        end
        r = [sym(1)+randn*sqrt(N0/2), sym(2)+randn*sqrt(N0/2)]; %ricevo 1 o 0 + rumore
        dist1 = norm(r-[sqrt(Enow),0]);
        % dist1 = sqrt((sqrt(Enow)-r(1))^2+(r(2))^2); 
        % distanza punto ricevuto - punto teorico -> per il bit 1
        dist0 = norm(r-[0,sqrt(Enow)]);
        % dist0 = sqrt((r(1))^2+(sqrt(Enow)-r(2))^2); 
        % distanza punto ricevuto - punto teorico -> per il bit 0
        if(dist1 < dist0) %decisore a minima distanza
            bitRx = 1; % r ricevuto è più vicino al s1
        else
            bitRx = 0; % r ricevuto è più vicino al s2
        end
        errore(z) = bitRx~=bitTx; % per vedere se ho sbagliato a ricevere
    end
    Pe_b(i) = mean(errore);
    fprintf('SNRdB=%d -> %d err su %d trasm -> P(e)= %f (2-PPM)\n', SNRdB(i), sum(errore), MonteCarlo, Pe_b(i));
    %pause
end

Pe_b_teoria = qfunc(sqrt(SNR));

semilogy(SNRdB, Pe_b, 'ro', 'MarkerSize',8)
hold on
semilogy(SNRdB,Pe_b_teoria,'b-')
xlabel('SNR in dB')
ylabel('Probabilità di errore di bit')
set(gca,'FontSize',16)
grid minor

