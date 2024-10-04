function y=distribuzione_gaussiana(n,mu,v)
data = sqrt(v)*randn(1,n)+mu;

hold on;
histogram(data, 'Normalization', 'pdf');
title('Distribuzione Gaussiana');
xlabel('Valore');
ylabel('PDF');