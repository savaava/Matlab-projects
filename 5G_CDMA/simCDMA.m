% Parametri del sistema
N = 50; % Numero di utenti/dispositivi
Lc = 128; % Numero di chip per bit (spreading factor)
Eb = 1; % Energia del segnale per bit (normalizzata a 1)
num_trials = 1e5; % Numero di simulazioni Monte Carlo
SNR_dB = -20:30; % Gamma di SNR in dB per simulazione

% Preallocazione risultati
BER = zeros(size(SNR_dB));

% Loop sulle diverse SNR
for idx = 1:length(SNR_dB)
    SNR_linear = 10^(SNR_dB(idx)/10); % Converti SNR in scala lineare
    var_interf = (N - 1) * Eb / Lc; % Varianza dell'interferenza (CLT)
    var_noise = Eb / (2 * SNR_linear); % Rumore derivato da SNR (2o punto)
    
    % Simulazione Monte Carlo
    errors = 0; % Contatore errori
    for trial = 1:num_trials
        % Bit trasmesso dall'utente target (+1 o -1)
        bit_tx = 2 * randi([0, 1]) - 1;
        
        % Interferenza modellata come distribuzione gaussiana (CLT)
        interference = sqrt(var_interf) * randn; % Interferenza gaussianizzata
        
        % Segnale ricevuto (senza AWGN, solo interferenza)
        received_signal = sqrt(Eb) * bit_tx + interference;%sqrt(var_noise)*randn; % Con il rumore sembra funzionare, senza no!
        
        % Decisione
        bit_rx = sign(received_signal);
        
        % Verifica errore
        if bit_rx ~= bit_tx
            errors = errors + 1;
        end
    end
    
    % Calcolo BER per questa SNR
    BER(idx) = errors / num_trials;
end

% Plot dei risultati
figure;
semilogy(SNR_dB, BER, 'r-o', 'LineWidth', 1.5);
grid on;
xlabel('SNR (dB)');
ylabel('BER');
title('Prestazioni CDMA non ortogonale (approssimazione CLT)');
legend(['N = ', num2str(N)]);
