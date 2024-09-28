function y=stimap(n)
x=randi(6,1,n)
y=sum(x>4)/n;

mediavett=[1:n];
for i=1:n
    mediavett(i)=sum(x(1:i))/i;
end

hold on
plot(1:n,x,'o-')
plot(1:n,mediavett,'o-')