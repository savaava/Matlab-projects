function Cost = proj_PPM_generator(k)
% INPUT
% k = num. di bit 

% OUTPUT
% Cost = Costellazione dei segnali in forma matriciale -> MxM

M = 2^k;
Cost = eye(M);
% tutti gli M segnali sono equienergetici e Es = 1 per ogni m
% quindi Eav = 1 