function prestazioniCDMA(Lc, N, MC, SNRdB)
    % Lc: Numero di colonne (lunghezza del chirping code)
    % N: Numero di utenti
    % MC: Numero di prove Monte Carlo per la somma di Xk e per la stima della P(e)
    % SNRdB: per la simulazione

    %% Sezione 1: Calcolo della Media e della Varianza della Somma di Xk
    sommaXk_MC = zeros(1,MC);
    mediaTeoricaSommaXk = 0;
    varianzaTeoricaSommaXk = Lc*(N-1); % Somma delle varianze indipendenti

    for mc = 1:MC
        matriceCCode = 2*randi([0,1],N,Lc)-1;
        Xk = zeros(1,Lc);
        % Calcolo di Xk per ogni colonna
        for ii=1:Lc
            Xk(ii) = sum(matriceCCode(2:N,ii))*matriceCCode(1,ii);
        end

        % Somma di tutte le Xk
        sommaXk_MC(mc) = sum(Xk);
    end

    % Calcolo empirico
    mediaEmpiricaSommaXk = mean(sommaXk_MC); % Media della somma
    varianzaEmpiricaSommaXk = var(sommaXk_MC); % Varianza della somma

    fprintf("\nMedia    empirica della somma di Xk indipendenti: %f\n" ...
        , mediaEmpiricaSommaXk);
    fprintf("Varianza empirica della somma di Xk indipendenti: %f\n\n" ...
        , varianzaEmpiricaSommaXk);

    figure;
    histogram(sommaXk_MC, 'Normalization', 'pdf');
    hold on;
    % x = linspace(min(sommaXk_MC), max(sommaXk_MC), 1000);
    % pdf_gauss = normpdf(x, mediaTeoricaSommaXk, sqrt(varianzaTeoricaSommaXk));
    % plot(x, pdf_gauss, 'r-', 'LineWidth', 2);
    title('Distribuzione gausiana della somma degli Xk indipendenti');
    xlabel('Somma di Xk indipendenti');
    ylabel('pdf');
    %legend('Empirica', 'Gaussiana teorica');
    legend('Empirica');
    grid on;

    %% Sezione 2: Calcolo della Probabilità di errori
    %Es = 1; % Energia per simbolo o per bit
    SNR = 10.^(SNRdB / 10); % SNR non in dB
    Pe = zeros(1, length(SNR)); % Probabilità di errore per simbolo o di bit
    Pe2 = zeros(1, length(SNR)); % Probabilità di errore per simbolo o di bit, in presenza di w
    N0 = 1000; % per il rumore aggiuntivo w

    for i = 1:length(SNR)
        errori = zeros(1,MC);
        errori2 = zeros(1,MC);
        for mc = 1:MC
            % Simbolo trasmesso (2-PAM: +1 | -1)
            simboloTx = 2*randi([0,1])-1;

            rumore = sqrt(varianzaEmpiricaSommaXk) * randn + mediaEmpiricaSommaXk;            
            w = sqrt(N0/2)*randn; % rumore w aggiuntivo per la seconda Pe2

            segnaleRx = sqrt(SNR(i))*simboloTx + rumore;
            segnaleRx2 = sqrt(SNR(i))*simboloTx + rumore + w;

            simboloRx = sign(segnaleRx);
            simboloRx2 = sign(segnaleRx2);
            if simboloRx == 0
                simboloRx = 1;
            end
            if simboloRx2 == 0
                simboloRx2 = 1;
            end

            errori(mc) = simboloRx ~= simboloTx;
            errori2(mc) = simboloRx2 ~= simboloTx;
        end
        Pe(i) = mean(errori);
        Pe2(i) = mean(errori2);
    end

    figure;
    semilogy(SNRdB, Pe, 'bo-', 'MarkerSize', 6);
    hold on;    
    grid on;
    semilogy(SNRdB, Pe2, 'ro-', 'MarkerSize', 6);
    title("Prestazioni CDMA con N="+N+" utenti ed Lc="+Lc);
    xlabel('SNR_{dB}');
    ylabel('Probabilità di errori P_b(e)');
    legend('P_b(e) senza w','P_b(e) con w');
end