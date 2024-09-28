function y=stimam(n)

%for ii=1:n
%    x(ii)=randn; %media 0 varianza 1
%end

x=randn(1,n) %vettore 1xn 
y=mean(x) %fa direttamente la somma dei valori diviso x, (la media aritmetica)
%y=sum(x)/n;
%questa è la stima della media statistica