t=0:1/8192:1;
y=cos(2*pi*100*t);
j=10*cos(2*pi*1000*t);
c=rand
sound(y+j)sound(y.*c)
r=s.*c+j
sound(r)
sound(s+j.*c/(sqrt(10000)))