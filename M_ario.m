function Pe_s = M_ario(SNRdB, k, MonteCarlo)
M = 2^k;
% per simbolo
SNR = 10.^(SNRdB/10)
Eav = .1;
N0 = Eav*SNR.^(-1)
M = 2^k;
% N=M=dimensionalità
errori = zeros(1,MonteCarlo);
Pe_s = zeros(1,length(SNR));

% i segnali sono equienergetici: Es1=Esm, per ogni m -> Eav=Esm
syms = sqrt(Eav)*eye(M) % Matrice quadrata identità 4x4
% ogni rigo è un simbolo che rappresenta una stringa di k bit.
        % ogni riga della matrice syms rappresenta un simbolo:
        % (k=3 -> M=8)
        % riga 1 -> [2.361  0  0  0  0  0  0  0] -> 000 = 0
        % riga 2 -> 001 = 1
        % riga 3 -> 010 = 2
        % riga 4 -> 011 = 3
        % riga 8 -> 111 = 7
% è l'insieme di tutti i possibili segnali che si possono trasmettere

for i=1:length(N0)
    N0_now = N0(i);
    for z=1:MonteCarlo
        bitTx = randi([0,M-1]);
        % io posso trasmettere una stringa di k bit: 
        % 0,1,2,...,M-1 = 2^k-1   uno di questi M possibili segnali
        sym = syms(bitTx+1,:)
        % sym è il segnale trasmesso, ossia un vettore 1xM 
        % ed è una delle righe della matrice syms
        % ad es: sym = [0  2.2361  0  0  0  0  0  0] -> ho trasmesso 001 = 1
        r = sym+randn*sqrt(N0_now/2)
        % ad es: r = [2  5.2361  2  2  2  2  2  2] -> ho trasmesso ???
        % calcolo la minima distanza
        min_dist = norm(r-syms(1,:));
        bitRx = 0;
        fprintf('bit tx = %d   -   bit rx = %d\n', bitTx, bitRx);
        % suppongo che il segnale trasmesso è il primo e quindi bitRx = 0
        for ii=2:M
            tmp = norm(r-syms(ii,:));
            %fprintf('r: %f     possibile sym: %f\n', r, syms(ii,:));
            if(tmp < min_dist)
                min_dist = tmp;
                bitRx = ii-1;
                fprintf('bit tx = %d   -   bit rx = %d\n', bitTx, bitRx);
                % -1 perchè per indicare le righe della matrice syms devo
                % partire da 1
            end
        end
        errori(z) = bitRx~=bitTx; 
    end
    Pe_s(i) = mean(errori);
    fprintf('SNRdB= %d -> %d err su %d trasm -> P(e)= %f (%d-PPM)\n', SNRdB(i), sum(errori), MonteCarlo, Pe_s(i), M);
    pause
end

semilogy(SNRdB, Pe_s, 'ro', 'MarkerSize',8)
hold on
xlabel('SNR in dB')
ylabel('Probabilità di errore di simbolo')
set(gca,'FontSize',16)
grid minor
