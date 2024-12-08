function prestazioniCDMA(Lc, N, MC, SNRdB)

% 2-PAM
Es = 1; % Energia per simbolo o per bit di un segnale
SNR = 10.^(SNRdB/10);
Ps = zeros(1,length(SNRdB));

% generiamo i chirping code
matriceCCode = 2*randi([0,1],N,Lc)-1;

muXkVett = zeros(1,Lc);
varXkVett = zeros(1,Lc);
XkVett = zeros(1,Lc);

for ii = 1:Lc
    % Calcolo di Xk escluso il primo utente
    tmp = sum(matriceCCode(2:N, ii)); % Somma degli altri utenti

    % Calcolo media e varianza
    muXkVett(ii) = tmp / (N - 1); % Media
    varXkVett(ii) = sum((matriceCCode(2:N, ii) - muXkVett(ii)).^2) / (N - 1);
    XkVett(ii) = tmp * matriceCCode(1, ii); % Correlazione con il primo utente
end
% XkVett è un vettore riga con Xk indipendenti

% fprintf("Matrice chirping code (Lc colonne e N righe): \n");
% disp(matriceCCode);
% fprintf("Ogni singolo Xk: \n");
% disp(XkVett);
% fprintf("Media di ogni singolo Xk: \n");
% disp(muXkVett);
% fprintf("Varianza di ogni singolo Xk: \n");
% disp(varXkVett);
muNoise = sum(muXkVett);
varNoise = sum(varXkVett);
fprintf("\nMedia del rumore: "+muNoise+" -> 0 \n");
fprintf("Varianza del rumore: "+varNoise+"\n\n");

EsVett = SNR * varNoise;
%display(EsVett);
for ii=1:length(SNR)
    errori = zeros(1,MC);
    sVett = [-1*EsVett(ii) EsVett(ii)]';
    for jj=1:MC
        indexTx = randi(2); % perchè è un 2-PAM
        r = sVett(indexTx) + sqrt(varNoise) * randn + muNoise;
        
        d1 = abs(r-sVett(1));
        d2 = abs(r-sVett(2));
        if d1 < d2
            indexRx = 1;
        else
            indexRx = 2;
        end
        
        errori(jj) = indexTx ~= indexRx;
        % fprintf("indexTx: "+indexTx ...
        %     +" | indexRx: "+indexRx ...
        %     +" (SNRdB="+SNRdB(ii) ...
        %     +") -> err="+errori(jj) ...
        %     +" norme: "+d1+" e "+d2+" \n");
    end
    Ps(ii) = mean(errori);
end

figure;
semilogy(SNRdB, Ps, 'bo-','MarkerSize', 6)
hold on;
grid on;


