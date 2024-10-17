function Pe_s = proj_estimate_Pe_diversity(SNRdB, Cost, MC, L)
%% parametri
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

        SNRrv = zeros(1,L);
        for zz=1:L
            SNRrv(zz) = myexprnd(SNRnom(ii),1,1);
        end
        
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
semilogy(SNRdB, Pe_s, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', '#FF6506')
title("Prestazioni con Fading con diversità -> "+M+" segnali - "+N+" Dim - "+L+" ritrasmissioni")
legend('P_s(e) di simulazione senza Fading','P_s(e) di simulazione con Fading','P_s(e) di simulazione con Fading + tecnica diversità')

if N==1
    legend('P_s(e) di simulazione senza Fading','P_s(e) teorica','P_s(e) di simulazione con Fading','P_s(e) di simulazione con Fading + tecnica diversità')
end



