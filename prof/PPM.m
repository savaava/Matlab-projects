function [P_sym, P_bit]=PPM(string_length,k,SNRdB,og)
% function [P_sym, P_bit]=PPM(string_length,k,SNRdB,og)
% Simulazione di una trasmissione ortogonale equienergetica M-aria
%
% INPUT
% string_length= lunghezza della stringa di bit emessa dalla sorgente
%                (modificato dal programma, se necessario)
% k= numero di bit per simbolo
% SNRdB= rapporto segnale rumore per bit in decibel
% og=1 produce l'output a video, og=0 lo inibisce
%
% OUTPUT
% P_sym= probabilità di errore di simbolo stimata
% P_bit= probabilità di errore di bit stimata
%



%------------> parametri ausiliari

M=2^k;     % numero di simboli
SNR=10^(SNRdB/10);  % rapporto segnale rumore per bit in valori naturali
string_length=k*ceil(string_length/k);  % rende string_length divisibile per k
N0=1;        % densità spettrale del rumore AWGN = N0/2
Eb=SNR*N0;   % energia media per singolo bit
Es=Eb*k;     % energia media per simbolo
sig2=N0/2;   % varianza dei campioni di rumore


%--------------------> simulazione

b=rand(1,string_length)>.5;    % stringa di bit emessi dalla sorgente
bmat=reshape(b,k,string_length/k);   % stringa di bit in forma matriciale: in ogni colonna c'è un simbolo
indx=bin2dec(num2str(bmat'))+1; % indice dei simboli tramsessi 
s=zeros(M,string_length/k);     % inizializzazione matrice s
% simboli in Tx (ogni colonna rappresenta un vettore in Tx)
s(sub2ind([M,string_length/k],indx,(1:length(indx))'))=sqrt(Es);  


n=sqrt(sig2)*randn(M,string_length/k);  % campioni di rumore introdotti dal canale AWGN
r=s+n; % vettori in ricezione (ogni colonna rappresenta un vettore)

%---> decosire ottimo (max correlazione)
[~,hatindx]=max(r);  % indice del simbolo in ricezione
hatb=reshape((dec2bin(([M,hatindx]-1))-'0')',1,string_length+k); % bits in ricezione
hatb=hatb(k+1:end);
errsym=hatindx~=indx'; % eventi errore sul simbolo
errbit=hatb~=b;   % eventi errore sul bit

%-------> stima delle prob. di errore
P_sym=mean(errsym);  % probabilità stimata di errore sul simbolo
P_bit=mean(errbit); % probabilità stimata di errore sul bit


if og,
    fprintf(1,' ****************************\n');
    fprintf(1,' *** result of simulation ***\n');
    fprintf(1,' ****************************\n');
    for ii=1:string_length/k;
        fprintf(1,'\n --symbol interval No. %d \n',ii);
        fprintf(1,' string of k bits at Tx  = '); fprintf(1,'%d ',bmat(:,ii)); fprintf(1,'\n');
        fprintf(1,' index of Tx symbol = %d \n',indx(ii));
        tmp=zeros(1,M); tmp(indx(ii))=sqrt(Es);
        fprintf(1,' symbol sent = ( '); fprintf(1,'%2.3g ',tmp); fprintf(1,')\n');
        tmp2=tmp'+n(:,ii);
        fprintf(1,' vector at the receiver = ( '); fprintf(1,'%2.3g ',tmp2); fprintf(1,')\n');
        fprintf(1,' ML decision chooses symbol No. %d \n',hatindx(:,ii)); 
        tmp3=(dec2bin(([M hatindx(:,ii)]-1))-'0')'; tmp3=tmp3(k+1:end);
        fprintf(1,' string of k bits at Rx  = '); fprintf(1,'%d ',tmp3); fprintf(1,'\n');
        pause
    end
end
    

