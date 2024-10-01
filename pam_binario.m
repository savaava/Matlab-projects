% PAM binario k=1
function Pbe = pam_binario(SNRdb, Montecarlo)
%posso mettere in uscita uno o più elementi [] vettore
%[bitTx,bitRx]

% il . sta per: deve farlo elemento per elemento
SNR=10.^(SNRdb/10);

% possiamo fissare N0 o E:
N0 = 1;
Ene = SNR*N0;

%ad ogni ciclo il SNR è sempre più grande
%ad ogni iterazione varia SNR e cambio il vettore sym nuovamewnte
for i=1:length(SNR)
    Enecurr=Ene(i);

    %bit Trasmessi
    bitTx = randi(2,1,Montecarlo)-1;
    % per simulare i bit

    % simbolo trasmesso -> o è 1 o 0 quindi è sqrt(E) o -sqrt(E):
    sym = bitTx*(2*sqrt(Enecurr))-sqrt(Enecurr);
    r = sym + randn(1,Montecarlo)*sqrt(N0/2);
    bitRx = r>0; %se r è maggiore di 0 restituisce 1 altrimenti 0
    Pbe(i) = mean(bitTx~=bitRx); %Pbe in base a SNR di ogni iterazione
    %pause % per vedere ogni iterazione
end
%sym è un vettore dove ogni elemento rappresenta quale segnale ho
%trasmesso: 1 o 0: sqrt E o -sqrt E
%sum(tx~=rx)/10, monecarlo=10
%mean(tx~=rx) 

Pbteoria = qfunc(sqrt(2*SNR));

semilogy(SNRdb, Pbe, 'ro', 'MarkerSize', 8)
hold on
semilogy(SNRdB, Pbteoria, 'k-', 'LineWidth', 2)
xlabel('SNR in dB')
ylabel('Probabilità di err di bit')
set(gca, 'FontSize', 16)


