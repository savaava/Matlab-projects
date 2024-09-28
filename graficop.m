nvett=round(logspace(0,5,10));
for i=1:length(nvett)
    y(i)=stimap(nvett(i));
end

semilogx(nvett,y,'bo-')
hold on
semilogx(nvett,1/3*ones(1,length(nvett)),'--r')
xlabel('numero esperimenti')
ylabel('stima della media')
set(gca,'FontSize',FS)
