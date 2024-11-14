function Prestazioni_TecnicheDiversita(SNRdB, N0, sigma, Cost, MC, L)
%% Parametri di Input
% SNRdB: Rapporto segnale rumore in decibel per simbolo SU OGNI RAMO
% sigma: parametro>0 della v. a. di Rayleigh (parametro di scala per raylrnd)
% N0:    il doppio della varianza del rumore AWGN
% Cost:  Costellazione (matrice MxN) in modo che Eav=1
% MC:    numero MonteCarlo di trasmissioni per ogni SNR, o per ogni E usata
% L:     numero di ritrasmissioni (rami) dello stesso segnale s per le tecniche di diversità

%% Parametri di utilità
SNR = 10.^(SNRdB/10);
%SNR = SNR./L; % SNR i-esimo non su ogni ramo, bensì complessivo
E = SNR*N0; % diverse energie usate per trasmettere il segnale

M = length(Cost(:,1)); % Numero dei possibili segnali
N = length(Cost(1,:)); % Numero delle componenti di un segnale (dimensionalità)

P_NoFading  = zeros(1,length(SNR)); % Probabilità errore per simbolo senza fading (andamento esponenziale)
P_Fading    = zeros(1,length(SNR)); % Probabilità errore per simbolo con   fading (andamento iperbolico)
P_Selection = zeros(1,length(SNR)); % Probabilità errore per simbolo usando Selection     Combining
P_Maximal   = zeros(1,length(SNR)); % Probabilità errore per simbolo usando Maximal-Ratio Combining
P_EqualG    = zeros(1,length(SNR)); % Probabilità errore per simbolo usando Equal Gain    Combining

%% Calcolo delle P(e)
for ii=1:length(SNR)
    newCost = sqrt(E(ii))*Cost;
    % ad ogni iterazione i segnali si allontanano sempre di più perchè spendiamo sempre più E

    errori_NoFading  = zeros(1,MC);
    errori_Fading    = zeros(1,MC);
    errori_Selection = zeros(1,MC);
    errori_Maximal   = zeros(1,MC);
    errori_EqualG    = zeros(1,MC);

    for jj=1:MC
        % scelta del segnale da trasmettere, tra gli M equiprobabili
        indexTx = randi(M);
        s = newCost(indexTx,:);

        %% No Fading
        rNoFading = s + randn(1,N)*sqrt(N0/2);
    
        indexRx = Decisore_MinDist(rNoFading, newCost);
        errori_NoFading(jj) = indexTx ~= indexRx;

        %% Fading
        alpha = raylrnd(sigma); % v. a. di Rayleigh (lo riutilizzo nelle tecniche)
        rFading = alpha*s + randn(1,N)*sqrt(N0/2);
 
        indexRx = Decisore_MinDist(rFading, newCost);
        errori_Fading(jj) = indexTx ~= indexRx;

        %% Selection Combining (massimo SNR)      
        alphaVett = raylrnd(sigma,1,L);
        rhoVett = alphaVett.^2*E(ii)/N0; % SNR istantaneo per il ramo i-esimo
        rhoMax = max(rhoVett);
        alpha = sqrt(rhoMax*N0/E(ii));
        rSelection = alpha*s + randn(1,N)*sqrt(N0/2);

        indexRx = Decisore_MinDist(rSelection, newCost);   
        errori_Selection(jj) = indexTx ~= indexRx; 

        %% Maximal-Ratio Combining
        rVett = zeros(L,N);
        for zz=1:L
            rVett(zz,:) = alphaVett(zz) * s + randn(1,N)*sqrt(N0/2); % conservo tutte le L ritrasmissioni
            rVett(zz,:) = alphaVett(zz) * rVett(zz,:); % G=alpha
        end
        rMaximal = sum(rVett); % combinazione lineare con G=alpha

        indexRx = Decisore_MinDist(rMaximal, newCost); 
        errori_Maximal(jj) = indexTx ~= indexRx;

        %% Equal Gain Combining
        for zz=1:L
            rVett(zz,:) = alphaVett(zz) * s + randn(1,N)*sqrt(N0/2); % conservo tutte le L ritrasmissioni
        end
        rEqualG = sum(rVett); % combinazione lineare con G=1

        indexRx = Decisore_MinDist(rEqualG, newCost);
        errori_EqualG(jj) = indexTx ~= indexRx;

    end
    P_NoFading(ii)  = mean(errori_NoFading);
    P_Fading(ii)    = mean(errori_Fading);
    P_Selection(ii) = mean(errori_Selection);
    P_Maximal(ii)   = mean(errori_Maximal);
    P_EqualG(ii)    = mean(errori_EqualG);
end

%% Stampa delle P(e)
figure;
semilogy(SNRdB, P_NoFading, 'bo-','MarkerSize', 6, "MarkerFaceColor", "b")
hold on;
semilogy(SNRdB, P_Fading, 'ro-','MarkerSize', 6, "MarkerFaceColor", "r")
semilogy(SNRdB+10*log10(L), P_Selection, 'ko-','MarkerSize', 6, "MarkerFaceColor", "k")
semilogy(SNRdB+10*log10(L), P_Maximal, 'go-','MarkerSize', 6, "MarkerFaceColor", "g")
semilogy(SNRdB+10*log10(L), P_EqualG, 'o-', "Color", "#A2142F", 'MarkerSize', 6, "MarkerFaceColor", "#A2142F")

grid on;

title("M="+M+"   |   N="+N+"   |   L="+L)
xlabel("SNR_{dB}");
ylabel("P_s(e)");

lgd = legend( ...
    'P(e) No Fading', ...
    'P(e) Fading', ...
    'P(e) Selection Combining', ...
    'P(e) Maximal-Ratio Combining', ...
    'P(e) Equal Gain Combing');
lgd.FontSize = 13;

hold off;



