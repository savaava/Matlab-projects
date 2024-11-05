function Pe_s = proj_estimate_Pe(SNRdB, Cost, MC)
%% parametri In-Out
% --INPUT--
% SNRdB: Rapporto segnale rumore per decibel per simbolo
% Cost:  M righe = M regnali, N colonne = dimensionalità
% MC:    numero MonteCarlo di trasmissioni per ogni SNR

% --OUTPUT--
% Pe_s:  Probabilità di errore per simbolo su MC prove e per diversi SNR

%% parametri utili
SNRnf = 10.^(SNRdB/10); % SNR no fading per SIMBOLO
Eav = 1; 
N0 = Eav./SNRnf; % varia N0
M = length(Cost(:,1));
N = length(Cost(1,:));
Pe_s = zeros(1,length(SNRnf));
%% calcolo Ps(e)
for ii=1:length(SNRnf)
    N0_now = N0(ii);
    errori = zeros(1,MC);
    for jj=1:MC        
        indexTx = randi(M);
        % scegliamo una delle M righe = una degli M segnali
        s = Cost(indexTx,:);
        r = s + randn(1,N)*sqrt(N0_now/2);
        
        % plot del segnale ricevuto
        % if N==1
        %     plot(r,0,'ro','MarkerSize',3);
        % elseif N==2
        %     plot(r(1),r(2),'ro','MarkerSize',3);
        % end

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
semilogy(SNRdB, Pe_s, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b')

hold on
%title("Prestazioni Modulazione - "+M+" segnali - "+N+" Dim")
xlabel('\gamma_{s,dB}')
ylabel('P_s(e)')
%lgd = legend('P_s(e) di simulazione senza Fading');

if N==1 % la modulazione è il PAM
    % non mettiamo log2(M) perchè SNR è già per simbolo
    Pe_s_th = 2*(M-1)/M * qfunc(sqrt(6/(M^2-1)*SNRnf));
    semilogy(SNRdB, Pe_s_th, 'Color','#1f77ba');
    %lgd = legend('P_s(e) di simulazione senza Fading', ...
        %'P_s(e) teorica senza Fading');
end
%lgd.FontSize = 13; 
grid on

%% partecipanti progetto:
%  Savastano Andrea -> 0612707904
%  Zito Mario -> 0612708073
%  Musto Francecso -> 0612707371



