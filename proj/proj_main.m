function proj_main(Str, k, SNRdB, MC, flag)
%% Controlli
if k==0
    fprintf('k deve essere maggiore di 0\n')
    return;
end

if flag~=1 && flag~=0
    fprintf(['flag deve essere 1 o 0 \n' ...
        'flag=1 --> simulazione con fading \n' ...
        'flag=0 --> simulazione senza fading\n'])
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
if flag
    proj_stima_Pe_Fading(SNRdB, Cost, MC)
else
    proj_stima_Pe(SNRdB, Cost, MC)
end
%% partecipanti progetto:
%  Savastano Andrea -> 0612707904
%  Zito Mario -> 0612708073
%  Musto Francecso -> 0612707371