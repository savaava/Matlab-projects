function Pe_s = proj_stima_Pe(SNRdB, Cost, MC)
% INPUT
% Cost -> M righe = M regnali, N colonne = dimensionalità
% SNRdB -> E' L'SNRdB per SIMBOLO 
% MC -> MonteCarlo = numero di trasmissioni o prove per ogni SNR

% OUTPUT
% Pe_s -> Probabilità di errore per simbolo su MC prove e per diversi SNR

%% parametri
SNR = 10.^(SNRdB/10); % per SIMBOLO
Eav = 1; 
N0 = Eav./SNR; %varia N0
M = length(Cost(:,1));
N = length(Cost(1,:));
Pe_s = zeros(1,length(SNR));

%% calcolo P(e)
for ii=1:length(N0)
    N0_now = N0(ii);
    errori = zeros(1,MC);
    for jj=1:MC 
        indexTx = randi(M);
        % scegliamo una delle Mmean righe = una degli M segnali
        s = Cost(indexTx,:);
        r = s + randn(1,N)*sqrt(N0_now/2);
        
        % calcolo della minima distanza
       d_min = norm(r - Cost(1,:));
       indexRx = 1;
       for zz=2:M
           d_tmp = norm(r - Cost(zz,:));
           if(d_tmp < d_min)
                d_min = d_tmp;
                indexRx = zz;
           end           
       end
       
       errori(jj) = indexTx~=indexRx; 
    end
    Pe_s(ii) = mean(errori);
end

%% Stampa 
semilogy(SNRdB, Pe_s, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k')
hold on
title("Prestazioni Modulazione - "+M+" segnali - "+N+" Dim")
xlabel('\gamma_{s,dB}')
ylabel('P_s(e)')
% Cost = [-3*sqrt(0.2); ...; 3*sqrt(0.2)] come prova
% non mettiamo log2(M) perchè SNR è già per simbolo
% Pe_s_th = 2*(M-1)/M * qfunc(sqrt(6/(M^2-1)*SNR));
% semilogy(SNRdB, Pe_s_th, 'k-');
grid on

%% partecipanti progetto:
%  Savastano Andrea -> 0612707904
%  Zito Mario -> 0612708073
%  Musto Francecso -> 0612707371


