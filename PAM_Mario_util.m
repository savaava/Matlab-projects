function [Pe_s, Pe_b]= PAM_Mario_util(SNRdB, k, MC, flag)
% SNRdb -> valore di SNR per simbolo

%% parametri 
M=2^k;
SNR = 10^(SNRdB/10);
N0 = 1;
Ebav = SNR*N0;
Eg = 3*Ebav/(M^2-1); % per ottenere l'energia di g, ossia l'impulso base
Am = linspace(-(M-1), M-1, M); % sono le ampiezze degli M possibili segnali
syms = Am*sqrt(Eg); % sono gli M possibili segnali
syms = syms';
% vettore colonna -> ogni riga è uno degli M possibili segnali,
% tutti equidistanti 2sqrt(Eg)
gc = graycode(M)';
errori = zeros(1,MC);

%% stampa grafico modulazione PAM
if(flag)
    figure;
    hold on;
    plot(syms,zeros(1,M),'ko-','MarkerSize',6,'LineWidth',1,'MarkerFaceColor','k')
    title("Modulazione "+M+"-PAM")
    xlabel(M+" possibili segnali")

    fprintf('codifica di gray per gli M=%d segnali\n',M);
    for ii=1:M
        fprintf('segnale %f  ->  simbolo %d\n', syms(ii), gc(ii)); 
       % c'è la corrispondenza syms(ii) <-> gc(ii)
    end
    pause;
end

%% MC trasmissioni di segnali - calcolo Pe
for ii=1:MC
    indexTx = randi([1,M]);
    sym = syms(indexTx);
    symTx = gc(indexTx);

    r = sym+randn*sqrt(N0/2);
    %fprintf('sgn tx=%f  ->  sym tx=%d    sgn rx=%f\n', sym, symTx, r);

    min_dist = norm(r-syms(1));
    symRx = gc(1);
    for zz=2:M
        tmp = norm(r-syms(zz));
        if(tmp < min_dist)
            min_dist = tmp;
            symRx = gc(zz);
        end
    end
    
    errori(ii) = symTx~=symRx; 
    
    % generazione iterativa del segnale trasmesso rispetto a quello ricevuto
    % if(errori(ii))
    %     color = 'r';
    % else
    %     color = 'g';
    % end
    % marker_tx = plot(sym, 0, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
    % marker_rx = plot(r, 0, 'o', 'MarkerSize', 8, 'MarkerFaceColor', color);
    % fprintf('\nTrasmissione num %d \nsgn tx=%f -> sym tx=%d \nsgn rx=%f -> sym rx=%d -> (errore=%d)\n' ...
    %      , ii, sym, symTx, r, symRx, errori(ii));
    % 
    % pause;
    % delete([marker_tx marker_rx]);
end
Pe_s = mean(errori);
Pe_b = Pe_s/k;
% posso calcolare Pe_b perchè ho usato la codifica di gray, e suppongo
% che SNR sia elevato

%% confronto con la P teorica
Pe_s_th = 2*(M-1)/M * qfunc(sqrt(6*k/(M^2-1)*SNR));
Pe_b_th = Pe_s_th/k;
fprintf('\n(%d-PAM) \nSNRdB= %d -> %d err su %d trasm \nPs(e)   =%f Pb(e)   =%f \nPs_th(e)=%f Pb_th(e)=%f\n\n' ...
    , M, SNRdB, sum(errori), MC, Pe_s, Pe_b, Pe_s_th, Pe_b_th);

