function proj_estimate_Pe_diversity(SNRdB, Cost, MC, L)
%% parametri In-Out
% --INPUT--
% SNRdB: Rapporto segnale rumore per decibel per simbolo
% Cost:  M righe = M regnali, N colonne = dimensionalità
% MC:    numero MonteCarlo di trasmissioni per ogni SNR
% L:     numero di ritrasmissioni per la tecnica di diversità

%% parametri utili
SNRnom = 10.^(SNRdB/10);
Eav = 1;
dev = 1/sqrt(2);
N0 = 1;
M = length(Cost(:,1));
N = length(Cost(1,:));
Pe_s_Selection = zeros(1,length(SNRnom));
Pe_s_Maximal = zeros(1,length(SNRnom));
Pe_s_EqualG = zeros(1,length(SNRnom));
%% calcolo Ps(e)
for ii=1:length(SNRnom)
    errori_Selection = zeros(1,MC);
    errori_Maximal = zeros(1,MC);
    errori_EqualG = zeros(1,MC);
    for jj=1:MC
        indexTx = randi(M);
        s = Cost(indexTx,:);
        
        SNRrv = raylrnd(,1,L);
        rVett = zeros(L,N);
        rSelection = zeros(1,N);
        rMaximal = zeros(1,N);
        rEqualG = zeros(1,N);

        %% SELECTION COMBINING       
        
        rSelection = s + randn(1,N)*sqrt(N0/2);
        
        d_min = norm(rSelection - Cost(1,:));
        indexRx = 1;
        for zz=2:M
           d_tmp = norm(rSelection - Cost(zz,:));
           if(d_tmp < d_min)
                d_min = d_tmp;
                indexRx = zz;
           end           
        end       
        errori_Selection(jj) = indexTx~=indexRx; 

        %% MAXIMAL-RATIO COMBINING
        for zz=1:L
            rVett(zz,:) = SNRrv(zz)*s + randn(1,N)*sqrt(N0/2);
        end
        rMaximal = sum(SNRrv*rVett);
        
        d_min = norm(rMaximal - Cost(1,:));
        indexRx = 1;
        for zz=2:M
           d_tmp = norm(rMaximal - Cost(zz,:));
           if(d_tmp < d_min)
                d_min = d_tmp;
                indexRx = zz;
           end           
        end
        errori_Maximal(jj) = indexTx~=indexRx;

        %% EQUAL GAIN COMBINIG
        rEqualG = sum(rVett);

        d_min = norm(rEqualG - Cost(1,:));
        indexRx = 1;
        for zz=2:M
           d_tmp = norm(rEqualG - Cost(zz,:));
           if(d_tmp < d_min)
                d_min = d_tmp;
                indexRx = zz;
           end           
        end
        errori_EqualG(jj) = indexTx~=indexRx;

    end
    Pe_s_Selection(ii) = mean(errori_Selection);
    Pe_s_Maximal(ii) = mean(errori_Maximal);
    Pe_s_EqualG(ii) = mean(errori_EqualG);
end

%% Stampa 
semilogy(SNRdB, Pe_s_Selection, 'bo','MarkerSize', 6, 'MarkerFaceColor', 'b')
hold on;
semilogy(SNRdB, Pe_s_Maximal, 'vo','MarkerSize', 6, 'MarkerFaceColor', 'v')
semilogy(SNRdB, Pe_s_EqualG, 'ro','MarkerSize', 6, 'MarkerFaceColor', 'r')

title("3 tecniche diversità -> "+M+" segnali - "+N+" Dim - "+L+" ritrasmissioni")
lgd = legend('P_s(e) per Selection Combining', ...
    'P_s(e) per Maximal-Ratio Combining', ...
    'P_s(e) per Equal Gain Combing');
lgd.FontSize = 13;



