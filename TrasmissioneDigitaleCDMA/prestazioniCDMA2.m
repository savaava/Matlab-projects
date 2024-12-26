function prestazioniCDMA2(Lc, N, MC, SNRdB)
    %% parametri INPUT
    % Lc: Lunghezza del chirping code
    % N:  vettore i cui elementi rappresentano diversi numeri di utenti.
    % MC: per la stima della P(e)
    % SNRdB: fissato per la simulazione
    
    %% Calcolo della Probabilità di errore
    mediaSommaXk = 0;
    varianzaSommaXk = Lc*(N-1);
    SNR = 10^(SNRdB / 10);
    Pe_emp = zeros(1, length(N));
    Pe2_emp = zeros(1, length(N));
    N0 = 1000; % di w

    for i = 1:length(N)
        errori = zeros(1,MC);
        errori2 = zeros(1,MC);
        for mc = 1:MC
            simboloTx = 2*randi([0,1])-1;

            rumore = sqrt(varianzaSommaXk(i))*randn + mediaSommaXk; % CLT
            w = sqrt(N0/2)*randn;
            segnaleRx = sqrt(SNR)*simboloTx + rumore;
            segnaleRx2 = sqrt(SNR)*simboloTx + rumore + w;

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
        Pe_emp(i) = mean(errori);
        Pe2_emp(i) = mean(errori2);
    end

    %% STAMPA
    fig = figure;
    width = 1300;
    height = 700;
    set(fig, 'Position', [100, 100, width, height]);

    semilogy(N, Pe_emp, 'bo-', 'MarkerSize', 6, 'MarkerFaceColor', 'b');

    hold on;
    grid on;

    semilogy(N, Pe2_emp, 'ko-', 'MarkerSize', 6, 'MarkerFaceColor', 'k');
    
    title("Prestazioni CDMA con SNR fissato a "+SNRdB+"dB ed Lc="+Lc+", al variare di N");
    xlabel('N');
    ylabel('Probabilità di errore P_s(e)');
    lgd = legend('P_{emp}(e) CDMA senza w','P_{emp}(e) CDMA con w');
    lgd.FontSize = 15;
end