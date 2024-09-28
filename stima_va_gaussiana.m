function y=stima_va_gaussiana(n,mu,v)
%varianza v per cambiare la varianza -> non è più 1 
%media non 0 -> cambiamo con mu

x=sqrt(v)*randn(1,n)+mu;
%somma tutti gli elementi del vettore

y=mean(x);
%media della variabile aleatoria gaussiana a media mu e varianza v

% stimam2(1000,9,1) -> 1000 tentativi, media 9 e varianza 1 -> i valori saranno sempre vicino a 9
%varianza significa dispersione intorno alla media: piccola -> i numeri
%sono molto vicini alla media
% stimam2(677,9,.01) -> ancora più precisa vicino a 9
%format long -> per vedere una migliore approssimazione (matlab lavora con doppia precisione
% però mostra meno cifre)
% stimam2(677,9,1000) -> la stima si allontana di più da 9