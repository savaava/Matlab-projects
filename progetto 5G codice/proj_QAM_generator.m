function Cost = proj_QAM_generator(k)
%% parametri In-Out
% --INPUT--
% k:     numero di bit da trasmettere

% --OUTPUT--
% Cost:  Costellazione dei segnali in forma matriciale -> Mx2 (QAM)

%% calcolo matrice Cost
M = 2^k;
qam_symbols = qammod(0:M-1, M);
Cost(:,1) = real(qam_symbols); 
Cost(:,2) = imag(qam_symbols);

Eav = sum(Cost(:,1).^2+Cost(:,2).^2)/M;
Cost = Cost./sqrt(Eav);

%% stampa costellazione PSK
plot(Cost(:,1),Cost(:,2),'ko','MarkerSize',6,'MarkerFaceColor','k')
hold on
plot([-1.5 1.5],[0 0],'k-','MarkerSize',6,'MarkerFaceColor','k')
plot([0 0],[-1.5 1.5],'k-','MarkerSize',6,'MarkerFaceColor','k')
title(M+"-QAM")
grid on
