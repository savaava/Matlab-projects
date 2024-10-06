function y=graycode(M)
%function y=graycode(M)
% calcola il codice di Gray per la codifica di stringhe di k bit (M =2^k simboli)
% INPUT
% M = numero di simboli
% OUTPUT
% y= codice di Gray
%
% Esempio
% y=graycode(2^3) ==> y=[1 2 4 3 8 7 5 6]
% che equivale alla associazione
% stringa  simbolo
% 000 ---> simbolo 1
% 001 ---> simbolo 2
% 010 ---> simbolo 4
% 011 ---> simbolo 3
% 100 ---> simbolo 8
% 101 ---> simbolo 7
% 110 ---> simbolo 5
% 111 ---> simbolo 6

k=log2(M);
if fix(k)~=k, fprintf('\n graycode ==> Error'), y=[]; return; end
if k==1, y=[1 2];
else
    ytab=[0,1]';
    ii=2;
    while ii<M,
        ii=ii*2;
        gh=[zeros(ii/2,1);ones(ii/2,1)];
        ytab=[ytab; flipud(ytab)];
        ytab=[gh,ytab];
    end
    gh=kron(2.^(k-1:-1:0),ones(M,1));
    indx=sum(gh.*ytab,2)+1;
    y(indx)=1:M;
end