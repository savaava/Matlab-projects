function Pe_s = proj_stima_Pe_Fading(SNRdB, Cost, MC)
% INPUT
% Cost -> M righe = M regnali, N colonne = dimensionalità
% SNRdB -> E' L'SNRdB per SIMBOLO 
% MC -> MonteCarlo = numero di trasmissioni o prove per ogni SNR

% OUTPUT
% Pe_s -> Probabilità di errore per simbolo su MC prove e per diversi SNR

%% parametri
SNRnom = 10.^(SNRdB/10); % SNR nominale per SIMBOLO
Eav = 1;
M = length(Cost(:,1));
N = length(Cost(1,:));
Pe_s = zeros(1,length(SNRnom));
%% calcolo Ps(e)
for ii=1:length(SNRnom)
    errori = zeros(1,MC);
    for jj=1:MC 
        % simuliamo il Fading: SNR come v.a. per ogni trasmissione
        SNRrv = myexprnd(SNRnom(ii),1,1);
        N0_now = Eav/SNRrv;
        
        % scegliamo una delle M righe = uno degli M segnali
        indexTx = randi(M);
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
figure 
semilogy(SNRdB, Pe_s, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r')
hold on
title("Prestazioni con Fading "+M+" segnali - "+N+" Dim")
xlabel('\gamma_{s,dB}')
ylabel('P_s(e)')
legend('P_s(e) di simulazione con Fading')

if N==1 % la modulazione è il PAM
    % non mettiamo log2(M) perchè SNR è già per simbolo
    SNR=SNRnom;
    Pe_s_th = 2*(M-1)/M * qfunc(sqrt(6/(M^2-1)*SNR));
    semilogy(SNRdB, Pe_s_th, 'b-');
    legend('P_s(e) di simulazione con Fading','P_s(e) teorica senza Fading')
end
grid on



