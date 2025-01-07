function prestazioniCDMA1(Lc, N, MC, SNRdB)
    %% parametri INPUT
    % Lc: Numero di colonne (lunghezza del chirping code)
    % N:  Numero di utenti
    % MC: Numero di prove Monte Carlo per la somma di Xk e per la stima della P(e)
    % SNRdB: per la simulazione

    %% esempio di input:
    % prestazioniCDMA1(100, 10, 1e5, -20:30)

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
    fprintf("Media    teorica  della somma di Xk indipendenti: %f\n" ...
        , mediaTeoricaSommaXk);
    fprintf("Varianza empirica della somma di Xk indipendenti: %f\n" ...
        , varianzaEmpiricaSommaXk);
    fprintf("Varianza teorica  della somma di Xk indipendenti: %f\n\n" ...
        , varianzaTeoricaSommaXk);

    fig = figure;
    width = 1300;
    height = 700;
    set(fig, 'Position', [100, 100, width, height]);

    histogram(sommaXk_MC, 'Normalization', 'pdf');

    hold on;
    x = linspace(min(sommaXk_MC), max(sommaXk_MC), 1000);
    pdf_gauss = normpdf(x, mediaTeoricaSommaXk, sqrt(varianzaTeoricaSommaXk));
    plot(x, pdf_gauss, 'r-', 'LineWidth', 2);
    title("Distribuzione gaussiana della somma degli Xk indipendenti, N="+N+" utenti e L_c="+Lc);
    xlabel('Somma di Xk indipendenti');
    ylabel('pdf');
    lgd = legend("Gaussiana Empirica\simN("+mediaEmpiricaSommaXk+", "+varianzaEmpiricaSommaXk+")", ...
                 "Gaussiana teorica\simN("+mediaTeoricaSommaXk+", "+varianzaTeoricaSommaXk+") per il CLT");
    lgd.FontSize = 15;
    grid on;

    %% Sezione 2: Calcolo della Probabilità di errore
    SNR = 10.^(SNRdB / 10); % SNR non in dB
    Pe_emp = zeros(1, length(SNR)); % Probabilità CDMA di errore per simbolo o di bit
    Pe2_emp = zeros(1, length(SNR)); % Probabilità CDMA di errore per simbolo o di bit, in presenza di w
    Pe3_emp = zeros(1, length(SNR)); % Probabilità di errore per simbolo o di bit, in presenza solo di w.
    N0 = 1000; % per il rumore aggiuntivo w

    for i = 1:length(SNR)
        errori = zeros(1,MC);
        errori2 = zeros(1,MC);
        errori3 = zeros(1,MC);
        for mc = 1:MC
            % Simbolo trasmesso (2-PAM: +1 | -1)
            simboloTx = 2*randi([0,1])-1;

            rumore = sqrt(varianzaTeoricaSommaXk) * randn + mediaTeoricaSommaXk; % CLT           
            w = sqrt(N0/2)*randn; % rumore w aggiuntivo per la seconda Pe2_emp

            segnaleRx = sqrt(SNR(i))*simboloTx + rumore;
            segnaleRx2 = sqrt(SNR(i))*simboloTx + rumore + w;
            segnaleRx3 = sqrt(SNR(i))*simboloTx + w;

            simboloRx = sign(segnaleRx);
            simboloRx2 = sign(segnaleRx2);
            simboloRx3 = sign(segnaleRx3);
            if simboloRx == 0
                simboloRx = 1;
            end
            if simboloRx2 == 0
                simboloRx2 = 1;
            end
            if simboloRx3 == 0
                simboloRx3 = 1;
            end

            errori(mc) = simboloRx ~= simboloTx;
            errori2(mc) = simboloRx2 ~= simboloTx;
            errori3(mc) = simboloRx3 ~= simboloTx;
        end
        Pe_emp(i) = mean(errori);
        Pe2_emp(i) = mean(errori2);
        Pe3_emp(i) = mean(errori3);
    end

    %% P(e) teoriche
    SNR1 = SNR/(2*varianzaTeoricaSommaXk);
    Pe_th = qfunc(sqrt(2*SNR1));

    SNR2 = SNR/(2*varianzaTeoricaSommaXk+N0);
    Pe2_th = qfunc(sqrt(2*SNR2));

    SNR3 = SNR/N0;
    Pe3_th = qfunc(sqrt(2*SNR3));

    %% STAMPA
    fig = figure;
    width = 1300;
    height = 700;
    set(fig, 'Position', [100, 100, width, height]);

    semilogy(SNRdB, Pe_emp, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');

    hold on;    
    grid on;

    semilogy(SNRdB, Pe2_emp, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');
    semilogy(SNRdB, Pe3_emp, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
    semilogy(SNRdB, Pe_th,  'b-');
    semilogy(SNRdB, Pe2_th, 'k-');
    semilogy(SNRdB, Pe3_th, 'r-');

    title("Prestazioni CDMA con N="+N+" utenti e L_c="+Lc);
    xlabel('SNR_{dB}');
    ylabel('Probabilità di errore P_s(e)');
    lgd = legend('P_{emp}(e) CDMA senza w','P_{emp}(e) CDMA con w','P_{emp}(e) solo con w', ...
        'P_{th}(e) CDMA senza w', 'P_{th}(e) CDMA con w', 'P_{th}(e) solo con w');
    lgd.FontSize = 15;
end