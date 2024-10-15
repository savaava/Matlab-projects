function out=Constellation(type,M)
% function out=Constellation(type,M)
%
% constellation points for various modulations with unit average energy
% 
% INPUT:
% type (string): any of the following 'PAM', 'PPM', 'PSK', 'QAM'
% M (integer, power of two): number of signals
% OUTPUT:
% out (M-by-N matrix) costellation points, 
% each row is a constellation point (i.e., an N-vector, 
% where N depends on the constellation type)
%
% Example of call:
% out=Constellation('QAM',16)
%
% [S.M. October 2024]
%

switch type
    case 'PAM'
        out=-(M-1):2:(M-1);
        out=out/sqrt(mean(out.^2));
        out=out(:);
    case 'PPM'
        out=diag(ones(1,M));
    case 'PSK'
        out=zeros(M,2);
        for i=1:M
            out(i,1:2)=[cos((i-1)*(2*pi)/M),sin((i-1)*(2*pi)/M)];
        end
    case 'QAM'
        k=log2(M);
        if rem(k,2)==0   % k is even
            M1=2^(k/2);
            [x,y] = meshgrid(-(M1-1):2:(M1-1));
            out=[x(:),y(:)];
            out=out/sqrt(mean(out(:,1).^2+out(:,2).^2));
        else   % k is odd
            k2=floor(k/2);
            k1=k2+1;
            M1=2^(k1);
            M2=2^(k2);
            [x,y] = meshgrid(-(M1-1):2:(M1-1),-(M2-1):2:(M2-1));
            out=[x(:),y(:)];
            out=out/sqrt(mean(out(:,1).^2+out(:,2).^2));
        end
end
