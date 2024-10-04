function z=ker_ort(x,rho_b,M)
% function z=ker_ort(x,rho_b,M)
% Kernel per integrazione numerica

k=log2(M);
z=(1-(1-q(x)).^(M-1)).*exp(-(x-sqrt(2*rho_b*k)).^2/2) / sqrt(2*pi) ;
