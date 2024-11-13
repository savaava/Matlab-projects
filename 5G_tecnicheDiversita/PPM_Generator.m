function Cost = PPM_Generator(k)
%% parametri In-Out
% --INPUT--
% k:     numero di bit da trasmettere

% --OUTPUT--
% Cost:  Costellazione dei segnali in forma matriciale -> MxM (PPM)

%% calcolo matrice Cost
%tutti gli M segnali sono equienergetici e Es = 1 per ogni m
%quindi Eav = = Esm = 1
M = 2^k;
Cost = eye(M); 