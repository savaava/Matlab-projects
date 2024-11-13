function Prestazioni_TecnicheDiversita(SNRdB, Cost, MC, L)
%% Parametri di Input
% SNRdB: Rapporto segnale rumore in decibel per simbolo su ogni ramo
% Cost:  Matrice MxN con   
% MC:    numero MonteCarlo di trasmissioni per ogni SNR
% L:     numero di ritrasmissioni (rami) dello stesso segnale s per le tecniche di diversità

%% Parametri di utilità
SNR = 10.^(SNRdB/10);
sigma = 1/sqrt(2); % parametro>0 della v. a. di Rayleigh (parametro di scala)
N0 = 1;
E = SNR*N0; % queste sono le energie usate per trasmettere il segnale 

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

    errori_NoFading  = zeros(1,MC);
    errori_Fading    = zeros(1,MC);
    errori_Selection = zeros(1,MC);
    errori_Maximal   = zeros(1,MC);
    errori_EqualG    = zeros(1,MC);

    for jj=1:MC
        % scelta del segnale da trasmettere, tra gli M equiprobabili
        indexTx = randi(M);
        s = Cost(indexTx,:);
        
        % alpha è la v. a. di Rayleigh
        %alpha = raylrnd(,1,L);
        rVett = zeros(L,N); 

        %% No Fading
        rNoFading = s + randn(1,N)*sqrt(N0/2);
    
        indexRx = Decisore_MinDist(rNoFading, Cost);
        errori_NoFading(jj) = indexTx ~= indexRx;

        %% Fading
        rFading = raylrnd(sigma)*s + randn(1,N)*sqrt(N0/2);
 
        indexRx = Decisore_MinDist(rFading, Cost);
        errori_Fading(jj) = indexTx ~= indexRx;

        % %% Selection Combining (massimo SNR)      
        % 
        % rSelection = s + randn(1,N)*sqrt(N0/2);
        % 
        % indexRx = Decisore_MinDist(rFading, Cost);   
        % errori_Selection(jj) = indexTx ~= indexRx; 
        % 
        % %% Maximal-Ratio Combining
        % for zz=1:L
        %     rVett(zz,:) = alpha(zz)*s + randn(1,N)*sqrt(N0/2);
        % end
        % rMaximal = sum(alpha*rVett);
        % 
        % indexRx = Decisore_MinDist(rFading, Cost); 
        % errori_Maximal(jj) = indexTx ~= indexRx;
        % 
        % %% Equal Gain Combining
        % rEqualG = sum(rVett);
        % 
        % indexRx = Decisore_MinDist(rFading, Cost);
        % errori_EqualG(jj) = indexTx ~= indexRx;

    end
    P_NoFading(ii)  = mean(errori_NoFading);
    P_Fading(ii)    = mean(errori_Fading);
    P_Selection(ii) = mean(errori_Selection);
    P_Maximal(ii)   = mean(errori_Maximal);
    P_EqualG(ii)    = mean(errori_EqualG);
end

%% Stampa delle P(e)
semilogy(SNRdB, P_NoFading, 'bo','MarkerSize', 6, 'MarkerFaceColor', 'b')
hold on;
semilogy(SNRdB, P_Fading, 'ro','MarkerSize', 6, 'MarkerFaceColor', 'r')
% semilogy(SNRdB, P_Selection, 'bo','MarkerSize', 6, 'MarkerFaceColor', 'b')
% semilogy(SNRdB, P_Maximal, 'go','MarkerSize', 6, 'MarkerFaceColor', 'g')
% semilogy(SNRdB, P_EqualG, 'ro','MarkerSize', 6, 'MarkerFaceColor', 'r')

grid on;

title(M+" segnali - "+N+" Dim - "+L+" ritrasmissioni")

% lgd = legend( ...
%     'P(e) No Fading', ...
%     'P(e) Fading', ...
%     'P(e) per Selection Combining', ...
%     'P(e) per Maximal-Ratio Combining', ...
%     'P(e) per Equal Gain Combing');
lgd = legend( ...
    'P(e) No Fading', ...
    'P(e) Fading');
lgd.FontSize = 13;

hold off;



