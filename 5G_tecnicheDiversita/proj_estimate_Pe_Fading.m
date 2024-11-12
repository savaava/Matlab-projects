function Pe_s = proj_estimate_Pe_Fading(SNRdB, Cost, MC)
%% parametri In-Out
% --INPUT--
% SNRdB: Rapporto segnale rumore per decibel per simbolo
% Cost:  M righe = M regnali, N colonne = dimensionalità
% MC:    numero MonteCarlo di trasmissioni per ogni SNR

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
        SNRrv = myexprnd(SNRnom(ii),1,1);
        N0_now = Eav/SNRrv;
        
        indexTx = randi(M);
        s = Cost(indexTx,:);
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
semilogy(SNRdB, Pe_s, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r')

title("Prestazioni con Fading "+M+" segnali - "+N+" Dim")
lgd = legend('P_s(e) di simulazione senza Fading', ...
    'P_s(e) di simulazione con Fading');

if N==1
    % Calcolo Pe teorica con fading per il PAM
    Pe_s_th_F = zeros(1,length(SNRnom));
    for ii=1:length(SNRnom)
        Pe_s_th_F(ii) = (M-1)/M * (1-sqrt(1/(1+(M^2-1)/(3*SNRnom(ii))) ));
    end
    semilogy(SNRdB, Pe_s_th_F, 'Color', '#FF6506')
    lgd = legend('P_s(e) di simulazione senza Fading', ...
        'P_s(e) teorica senza Fading', ...
        'P_s(e) di simulazione con Fading', ...
        'P_s(e) teorica con Fading');
end
lgd.FontSize = 13;



