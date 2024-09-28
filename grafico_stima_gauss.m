%edit grafico -> crea il file come touch
FS=16;
LW=2;
nvett=round(logspace(0,5,10));
%logspace genera 6 numeri a partire da 10^0 a 10^5
mu=9;
v=1;
%ripetiamo l'esperimento prima 10 volte, poi 100, poi 1000,....

for i=1:length(nvett)
    y(i)=stima_va_gaussiana(nvett(i),mu,v);
    %nvett(i) quante volte ripeto l'esperimento
end

%clear per puliore il workspace -> variabili vecchie sovrascrivono
%who -> le variabili del workspace
%clear, close all, grafico
%close all per chiudere tutti i grafici
%se non mettiamo close all allora si sovrappongo i grafici, buono per
%confrontare i grafici cambiando v=1, v=.1, v=.01
%plot(nvett,y) non mi interessa la scala lineare -> voglio la scala

%logaritmica -> semilogx
%bo- = blu + marca i punti con pallini o + linee continue -
%linewidth con LW pe aumentare lo spessore della linea
semilogx(nvett,y,'bo-','LineWidth',LW)
hold on %blocca il grafico -> adesso disegna sullo stesso grafico 
%ones(1,9) vettori tutti 1 n volte
%--r = -- linea tratteggiata + red
semilogx(nvett,mu*ones(1,length(nvett)),'--r','LineWidth',LW)
xlabel('numero esperimenti')
ylabel('stima della media')
%settato il grafico con un font size FS
set(gca,'FontSize',FS)
