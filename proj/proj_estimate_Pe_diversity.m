function Pe_s = proj_estimate_Pe_diversity(SNRdB, Cost, MC, L)
%% parametri In-Out
% --INPUT--
% SNRdB: Rapporto segnale rumore per decibel per simbolo
% Cost:  M righe = M regnali, N colonne = dimensionalità
% MC:    numero MonteCarlo di trasmissioni per ogni SNR
% L:     numero di ritrasmissioni per la tecnica di diversità

% --OUTPUT--
% Pe_s:  Probabilità di errore per simbolo su MC prove e per diversi SNR

%% parametri utili
SNRnom = 10.^(SNRdB/10);
Eav = 1;
M = length(Cost(:,1));
N = length(Cost(1,:));
Pe_s = zeros(1,length(SNRnom));
%% calcolo Ps(e)
for ii=1:length(SNRnom)
    errori = zeros(1,MC);
    for jj=1:MC
        indexTx = randi(M);
        s = Cost(indexTx,:);

        SNRrv = myexprnd(SNRnom(ii),1,L);        
        N0_now = Eav/max(SNRrv);        
        r = s + randn(1,N)*sqrt(N0_now/2);
        
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
semilogy(SNRdB, Pe_s, 'o','Color', '#006e18','MarkerSize', 6, 'MarkerFaceColor', '#006e18')

title("Prestazioni con Fading con diversità -> "+M+" segnali - "+N+" Dim - "+L+" ritrasmissioni")
lgd = legend('P_s(e) di simulazione senza Fading', ...
    'P_s(e) di simulazione con Fading', ...
    'P_s(e) di simulazione con Fading + tecnica diversità');

if N==1
    lgd = legend('P_s(e) di simulazione senza Fading', ...
        'P_s(e) teorica senza Fading', ...
        'P_s(e) di simulazione con Fading', ...
        'P_s(e) teorica con Fading', ...
        'P_s(e) di simulazione con Fading + tecnica diversità');
end
lgd.FontSize = 13;



