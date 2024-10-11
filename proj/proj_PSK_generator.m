function Cost = proj_PSK_generator(k)

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