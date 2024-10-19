function proj_main(Str, k, SNRdB, MC, flag, L)
%% parametri In
% --INPUT--
% Str:   è la modulazione da utilizzare 
% k:     numero di bit da trasmettere
% SNRdB: Rapporto segnale rumore per decibel per simbolo
% MC:    numero MonteCarlo di trasmissioni per ogni SNR
% flag:  a 1 per simulare il fading
% L:     numero di ritrasmissioni per la tecnica di diversità (flag=1)

%% Controllo
if k==0
    fprintf('k deve essere maggiore di 0\n')
    return;
end

%% Scelta modulazione
if strcmpi(Str,'PAM')
    Cost = proj_PAM_generator(k);    
elseif strcmpi(Str,'PPM')
    Cost = proj_PPM_generator(k);
elseif strcmpi(Str,'PSK')
    Cost = proj_PSK_generator(k);
elseif strcmpi(Str,'QAM')
    Cost = proj_QAM_generator(k);
else
    fprintf('Str deve essere PAM / PPM / PSK / QAM \n')
    return;
end

%% Simulazione con o senza Fading
proj_estimate_Pe(SNRdB, Cost, MC);
if flag
    proj_estimate_Pe_Fading(SNRdB, Cost, MC);
    if L>1
        proj_estimate_Pe_diversity(SNRdB, Cost, MC, L);
    end
end
%% partecipanti progetto:
%  Musto Francecso -> 0612707371
%  Savastano Andrea -> 0612707904
%  Zito Mario -> 0612708073