function Cost = proj_PSK_generator(k)
%% parametri In-Out
% --INPUT--
% k:     numero di bit da trasmettere

% --OUTPUT--
% Cost:  Costellazione dei segnali in forma matriciale -> Mx2 (PSK)

%% calcolo matrice Cost
M = 2^k;
D = M/2;
Cost = zeros(M,2);

% Avendo posto Eav=1 i segnali sono equienergetici: Es=1 per ogni m --> r=1
% quindi gli M segnali sono equidistanti dal centro della circonferenza (r=1)
% sx ed sy sono le coordinate dei singoli segnali su x e su y e quindi 
% gli elementi di ogni riga della costellazione Cost.
for ii=1:M
    sx = cos(ii*pi/D);
    sy = sin(ii*pi/D);
    Cost(ii,1) = sx;
    Cost(ii,2) = sy;
end

%% stampa costellazione PSK
plot(Cost(:,1),Cost(:,2),'ko','MarkerSize',6,'MarkerFaceColor','k')
hold on
plot([-1.5 1.5],[0 0],'k-','MarkerSize',6,'MarkerFaceColor','k')
plot([0 0],[-1.5 1.5],'k-','MarkerSize',6,'MarkerFaceColor','k')
title(M+"-PSK")
grid on
axis('square')