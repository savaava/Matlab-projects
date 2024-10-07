function [P_sym, P_bit]=PAM(string_length,k,SNRdB,og)
% function [P_sym, P_bit]=PAM(string_length,k,SNRdB,og)
% Simulazione di una trasmissione PAM M-aria
%
% INPUT
% string_length= lunghezza della stringa di bit emessa dalla sorgente
%                (modificato dal programma, se necessario)
% k= numero di bit per simbolo
% SNRdB= rapporto segnale rumore per bit in decibel
% og=1 produce l'output grafico, og=0 lo inibisce
%
% OUTPUT
% P_sym= probabilità di errore di simbolo stimata
% P_bit= probabilità di errore di bit stimata
%



%------------> parametri ausiliari

M=2^k;     % numero di simboli
SNR=10^(SNRdB/10);  % rapporto segnale rumore per bit in valori naturali
string_length=k*ceil(string_length/k);  % rende string_length divisibile per k
N0=1;          % densità spettrale del rumore AWGN = N0/2
Eavb=SNR*N0;   % energia media per singolo bit
Am_norm=(2*(1:M)-1-M);     % ampiezze normalizzate dei simboli
Eg=3*k/(M^2-1)*Eavb;  % energia dell'impulso base
Am=Am_norm*sqrt(Eg); % ampiezze dei simboli
dmin=2*sqrt(Eg);     % distanza minima tra i segnali
sig2=N0/2;           % varianza dei campioni di rumore
gc=graycode(M);      % codice di Gray



%--------------------> simulazione

b=rand(1,string_length)>0.5;    % stringa di bit emessi dalla sorgente
bmat=reshape(b,k,string_length/k);   % stringa di bit in forma matriciale: ogni colonna rappresenta un simbolo

if k>1,
    gh=sum(bmat.*kron(2.^(k-1:-1:0),ones(string_length/k,1))'); % traduce in valori decimali
    indx=gc(gh+1);  % indice dei simboli tramsessi (implementando la codifica di Gray)
else
    indx=b+1;
end

s=Am(indx);    % simboli trasmessi
n=sqrt(sig2)*randn(size(s));  % campioni di rumore introdotti dal canale AWGN
r=s+n; % simboli in ricezione

hats=zeros(1,length(s));   % inizializza il vettore di output al decisore (simboli)
hatbmat=-1*ones(size(bmat));  % inizializza il vettore di output al decisore (bits)
hatindx=zeros(1,length(indx)); % inizializza il vettore di output al decisore (indice di simbolo)

thres=[-inf, Am(1:end-1)+dmin/2, inf]; % valori di soglia
for ii=1:M;
    gh=find(r>thres(ii) & r<=thres(ii+1));
    hats(gh)=Am(ii);               % assegna i valori stimati
    hatindx(gh)=ii;                % indice dei valori stimati
    dummy=find(gc==ii)-1;
    hatbmat(1:k,gh)=kron((abs(dec2bin(dummy,k))==abs('1'))',ones(1,length(gh)));
end

hatb=reshape(hatbmat,1,length(b));

errsym=hatindx~=indx; % eventi errore sul simbolo
errbit=hatb~=b;   % eventi errore sul bit

%-------> stima delle prob. di errore
P_sym=sum(errsym)/length(indx);  % probabilità stimata di errore sul simbolo
P_bit=sum(errbit)/length(b);  % probabilità stimata di errore sul bit


%--------------------> output grafico

if og,
    %--------> prima finestra grafica
    figure;
    for kk=1:length(r)
        plot(linspace(Am(1)-4*sqrt(N0/2),Am(end)+4*sqrt(N0/2),1000),zeros(1,1000),'-','Linewidth',2),hold on
        text(0,-.1,'0','FontSize',12)
        plot(Am,zeros(size(Am)),'o','MarkerSize',8),
        plot(r(1:kk),zeros(1,kk),'.','MarkerSize',20),
        %plot(r(find(errsym(1:kk))),zeros(size(find(errsym(1:kk)))),'.','MarkerSize',20,'MarkerEdgeColor',[1 0 0]),
        plot(r(errsym(1:kk)),zeros(size(find(errsym(1:kk)))),'.','MarkerSize',20,'MarkerEdgeColor',[1 0 0]),
        axis([Am(1)-4*sqrt(N0/2),Am(end)+4*sqrt(N0/2), -1, 1]), axis('off')
        ax=linspace(-4+s(kk),4+s(kk),1000);
        plot(ax,1/sqrt(2*pi*sig2)*exp(-(ax-s(kk)).^2)/(2*sig2)), hold off
        pause
    end
    plot(linspace(Am(1)-4*sqrt(N0/2),Am(end)+4*sqrt(N0/2),1000),zeros(1,1000),'-','Linewidth',2),hold on
    text(0,-.1,'0','FontSize',12)
    plot(Am,zeros(size(Am)),'o','MarkerSize',8),
    plot(r,zeros(size(r)),'.','MarkerSize',20),
    plot(r(errsym),zeros(size(find(errsym))),'.','MarkerSize',20,'MarkerEdgeColor',[1 0 0]),
    axis([Am(1)-4*sqrt(N0/2),Am(end)+4*sqrt(N0/2), -1, 1]), axis('off')
    
    
    %--------> seconda finestra grafica
    %------> inizializzazione della finestra grafica
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
    set(head1(10),'String','simbolo in trasmissione');
    set(head1(13),'String','simbolo in ricezione');
    set(head1(16),'String','decisione (simbolo)');
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
        nows=s(ii:ii+numcol-1);
        nowr=r(ii:ii+numcol-1);
        nowhats=hats(ii:ii+numcol-1);
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
            set(head2(11,jj),'String',sprintf('%5.4f',nows(jj))),
            set(head2(14,jj),'String',sprintf('%5.4f',nowr(jj))),
            set(head2(17,jj),'String',sprintf('%5.4f',nowhats(jj)),'ForegroundColor',[0 0 0]),
            set(head2(20,jj),'String',sprintf('%d',nowhatindx(jj)),'ForegroundColor',[0 0 0]),
            
            if nowerrsym(jj),
                set(head2(17,jj),'ForegroundColor',[1 0 0]),
                set(head2(20,jj),'ForegroundColor',[1 0 0]),
            end
        end
        pause
    end
end





