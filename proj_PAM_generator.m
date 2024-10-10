function Cost = proj_PAM_generator(k)
% INPUT
% k = num. di bit 

% OUTPUT
% Cost = Costellazione dei segnali in forma matriciale -> Mx1 (PAM)

M = 2^k;
Am = linspace(-(M-1), M-1, M);
Eg = 3/(M^2-1);
Cost = (Am*sqrt(Eg))';
