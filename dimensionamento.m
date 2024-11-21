function dimensionamento(n,SIRdB,i0,jmax)

% gamma è un intervallo il SIR desiderato in dB

gamma = 10.^(gammadB/10);
i0 = 6;
Ntilde = (i0*gamma).^(2/n);
%N = Ntilde;

k=0;
for ii=0:jmax
    for jj=ii:jmax
        
    end
end

Nadm=sort(Nadm);
SIRdes = 10.^(SIRdB/10);
SIR = 1/10*(sqrt(3*Nadm)).^n;
mask = find(SIR>=SIRdes);


plot(gamma,Ntilde,'ro-','MarkerSize', 6);
hold on
xti
plot(gamma,N,'bo-','MarkerSize', 6);
grid on

lgd = legend("N tilde","N effettivo");
lgd.FontSize = 13;
