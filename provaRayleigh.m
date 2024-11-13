function provaRayleigh(sigma, MC)

data = raylrnd(sigma, MC, 1);

figure
hold on;

histogram(data, 'Normalization', 'PDF');
title('f_R(\alpha)');
xlabel('\alpha');
ylabel('PDF');

x = 0:0.1:10;
y = raylpdf(x, sigma);
plot(x, y, 'r-', 'LineWidth', 2);
legend('Istogramma campioni', 'PDF teorica');
grid on;