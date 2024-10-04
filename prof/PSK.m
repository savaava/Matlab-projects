function [P_sym, P_bit]=PSK(string_length,k,SNRdB,og)
% function [P_sym, P_bit]=PSK(string_length,k,SNRdB,og)
% Simulazione di una trasmissione PSK M-aria
%
% INPUT
% string_length= lunghezza della stringa di bit emessa dalla sorgente
%                (modificato dal programma, se necessario)
% k= numero di bit per simbolo
% SNRdB= rapporto segnale rumore di bit in decibel
% og=1 produce l'output grafico, og=0 lo inibisce
% OUTPUT
% P_sym= probabilità di errore di simbolo stimata
% P_bit= probabilità di errore di bit stimata
%



%------------> parametri ausiliari

M=2^k;     % numero di simboli
SNR=10^(SNRdB/10);  % rapporto segnale rumore per bit in valori naturali
string_length=k*ceil(string_length/k);  % rende string_length divisibile per k
N0=1;          % densità spettrale del rumore AWGN = N0/2
Eb=SNR*N0;     % energia per singolo bit
phi_m=angle(exp(sqrt(-1)*2*pi/M*(0:M-1)));     % fase dei simboli
Eg=Eb*2*k;     % energia dell'impulso base

gc=graycode(M);      % codice di Gray


%--------------------> simulazione

b=rand(1,string_length)>0.5;    % stringa di bit emessi dalla sorgente
bmat=reshape(b,k,string_length/k);   % stringa di bit in forma matriciale: in ogni colonna c'è un simbolo

if k>1,
    gh=sum(bmat.*kron(2.^(k-1:-1:0),ones(string_length/k,1))'); % traduce in valori decimali
    indx=gc(gh+1);  % indice dei simboli tramsessi (implementando la codifica di Gray)
else
    indx=b+1;
end

phi=phi_m(indx);    % fasi trasmesse sul canale
s=sqrt(Eg/2)*exp(sqrt(-1)*phi); % simboli trasmessi sul canale
n=sqrt(N0/2)*(randn(size(s))+sqrt(-1)*randn(size(s)));  % campioni di rumore introdotti dal canale AWGN
r=s+n; % vettore ricevuto (poiezione del segnale r(t) sulla base)

hatphi=zeros(1,length(s));   % inizializza il vettore di output al decisore (simboli)
hatbmat=-1*ones(size(bmat));  % inizializza il vettore di output al decisore (bit)
hatindx=zeros(1,length(indx)); % inizializza il vettore di output al decisore (indice di simbolo)

%---------->  (-pi pi) ---> (0,2*pi)
phi_m(phi_m<0)=phi_m(phi_m<0)+2*pi;
fase_di_r=angle(r);
fase_di_r(fase_di_r<0)=fase_di_r(fase_di_r<0)+2*pi;

for ii=2:length(phi_m),
    gh=find(abs(fase_di_r-phi_m(ii))<(pi/M));  % trova la fase a minima distanza
    if ~isempty(gh),
        hatphi(gh)=phi_m(ii);           % assegna i valori stimati
        hatindx(gh)=ii;                % indice dei valori stimati
        dummy=find(gc==ii)-1;
        hatbmat(1:k,gh)=kron((abs(dec2bin(dummy,k))==abs('1'))',ones(1,length(gh)));
    end
end
%----> considera la prima regione di decisione
gh=find(hatphi==0);
if ~isempty(gh),
    %hats(gh)=phi_m(1);           % assegna i valori stimati
    hatindx(gh)=1;                % indice dei valori stimati
    dummy=find(gc==1)-1;
    hatbmat(1:k,gh)=kron((abs(dec2bin(dummy,k))==abs('1'))',ones(1,length(gh)));
end



hatb=reshape(hatbmat,1,length(b));

errsym=hatindx~=indx; % segnala eventi di errore sul simbolo
errbit=hatb~=b;   % segnala eventi di errore sul bit

%-------> stima delle prob. di errore
P_sym=sum(errsym)/length(indx);  % probabilità stimata di errore sul simbolo
P_bit=sum(errbit)/length(b);  % probabilità stimata di errore sul bit


%--------------------> output grafico


if og,
    %------> inizializzazione della finestra grafica
    %--------> prima finestra grafica
    figure;
    plot(sqrt(Eg/2)*cos(phi_m),sqrt(Eg/2)*sin(phi_m),'o','MarkerSize',6), hold on
    plot(real(r),imag(r),'.','MarkerSize',20),
    plot(real(r(errsym)),imag(r(errsym)),'.','MarkerSize',20,'MarkerEdgeColor',[1 0 0]),
    axis(2*sqrt(Eg/2)*[-1 1 -1 1]), axis('square'), axis('off')
    plot(2*sqrt(Eg/2)*linspace(-1,1),zeros(1,100),'b',zeros(1,100),linspace(-1,1)*2*sqrt(Eg/2),'b')
    pause
    %-------> seconda finestra grafica
    numrow=24;
    numcol=fix(15/k);
    g1=figure;
    set(g1,'NumberTitle','off','Name',mfilename)
    scrsz = get(0,'ScreenSize');
    pos_win=fix([scrsz(1), scrsz(2)+10, scrsz(3) scrsz(4)-50]);
    set(g1,'Units','pixels','position',pos_win);
    main_pos=get(g1,'Position');
    alt=fix(main_pos(4)/numrow);
    larg=fix(main_pos(3));
    head1=NaN(1,numrow/3);
    for ii=1:3:numrow,
        head1(ii)=uicontrol(g1,'Style','Text','FontSize',14);
        pos=fix([0, alt*(numrow-ii), larg, alt]);
        set(head1(ii),'Position',pos)
        set(head1(ii),'String',num2str(ii));
    end
    set(head1(1),'String','stringa binaria emessa dalla sorgente');
    set(head1(4),'String','simbolo di k bit');
    set(head1(7),'String','indice del simbolo trasmesso (con codifica di Gray)');
    set(head1(10),'String','fase (/pi) del simbolo in trasmissione');
    set(head1(13),'String','fase (/pi) del simbolo in ricezione');
    set(head1(16),'String','decisione (fase/pi)');
    set(head1(19),'String','decisione (indice del simbolo)');
    set(head1(22),'String','stringa di bit in uscita al decisore');
    
    alt=fix(main_pos(4)/numrow);
    larg=fix(main_pos(3)/numcol/k);
    headbit=NaN(1,k*numcol); headhatbit=NaN(1,k*numcol);
    for jj=1:k*numcol,
        headbit(jj)=uicontrol(g1,'Style','Text','FontSize',14);
        pos=fix([larg*(jj-1), alt*(numrow-2), larg, alt]);
        set(headbit(jj),'Position',pos)
        headhatbit(jj)=uicontrol(g1,'Style','Text','FontSize',14);
        pos=fix([larg*(jj-1), alt*(numrow-23), larg, alt]);
        set(headhatbit(jj),'Position',pos)
    end
    
    
    alt=fix(main_pos(4)/numrow);
    larg=fix(main_pos(3)/numcol);
    head2=NaN(length(5:3:numrow-3),numcol);
    for ii=5:3:numrow-3,
        for jj=1:numcol,
            head2(ii,jj)=uicontrol(g1,'Style','Text','FontSize',14);
            pos=fix([larg*(jj-1), alt*(numrow-ii), larg, alt]);
            set(head2(ii,jj),'Position',pos)
        end
    end
    
    %--------------------------> produce l'output
    for ii=1:length(s)-numcol;
        nowb=b(k*(ii-1)+1:k*(ii+numcol-1));
        nowindx=indx(ii:ii+numcol-1);
        nowphi=phi(ii:ii+numcol-1)/pi;
        nowfase_di_r=fase_di_r(ii:ii+numcol-1)/pi;
        nowhatphi=hatphi(ii:ii+numcol-1)/pi;
        nowhatindx=hatindx(ii:ii+numcol-1);
        nowerrsym=errsym(ii:ii+numcol-1);
        nowhatb=hatb(k*(ii-1)+1:k*(ii+numcol-1));
        nowerrbit=errbit(k*(ii-1)+1:k*(ii+numcol-1));
        for jj=1:numcol*k
            set(headbit(jj),'String',sprintf('%d ',nowb(jj)))
            set(headhatbit(jj),'String',sprintf('%d ',nowhatb(jj)),'ForegroundColor',[0 0 0])
            if nowerrbit(jj),
                set(headhatbit(jj),'ForegroundColor',[1 0 0]),
            end
        end
        for jj=1:numcol,
            set(head2(5,jj),'String',sprintf('%d',nowb((jj-1)*k+1:jj*k)))
            set(head2(8,jj),'String',sprintf('%d',nowindx(jj))),
            set(head2(11,jj),'String',sprintf('%5.4f',nowphi(jj))),
            set(head2(14,jj),'String',sprintf('%5.4f',nowfase_di_r(jj))),
            set(head2(17,jj),'String',sprintf('%5.4f',nowhatphi(jj)),'ForegroundColor',[0 0 0]),
            set(head2(20,jj),'String',sprintf('%d',nowhatindx(jj)),'ForegroundColor',[0 0 0]),
            
            if nowerrsym(jj),
                set(head2(17,jj),'ForegroundColor',[1 0 0]),
                set(head2(20,jj),'ForegroundColor',[1 0 0]),
            end
        end
        pause
    end
end


