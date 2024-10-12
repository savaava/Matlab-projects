
M=64;
psk_symbols = pskmod(0:M-1, M);
Cost(:,1) = real(psk_symbols); 
Cost(:,2) = imag(psk_symbols);
disp(Cost)

plot(Cost(:,1),Cost(:,2),'ko','MarkerSize',6,'MarkerFaceColor','k')
hold on
plot([-1.5 1.5],[0 0],'k-','MarkerSize',6,'MarkerFaceColor','k')
plot([0 0],[-1.5 1.5],'k-','MarkerSize',6,'MarkerFaceColor','k')
title(M+"-PSK")
grid on