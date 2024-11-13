function Cost = PAM_Generator(k)
%% parametri In-Out
% --INPUT--
% k:     numero di bit da trasmettere

% --OUTPUT--
% Cost:  Costellazione dei segnali in forma matriciale -> Mx1 (PAM)

%% calcolo matrice Cost
M = 2^k;
Am = linspace(-(M-1), M-1, M);
Eg = 3/(M^2-1);
Cost = (Am*sqrt(Eg))';

%% stampa costellazione PAM
% plot(Cost,zeros(1,M),'ko-','MarkerSize',6,'MarkerFaceColor','k')
% hold on
% title(M+"-PAM")
% grid on