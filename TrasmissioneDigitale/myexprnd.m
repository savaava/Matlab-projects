function y=myexprnd(mu,r,c)
%
% function y=myexprnd(mu,r,c)
%
% exponentially distributed random numbers
%
% INPUT:
% mu (positive number): mean of the exponential random variable
% r,c (positive integers): size of the output
% OUTPUT:
% y (r-by-c matrix) exponentially distributed random numbers with mean mu
%
%
% Example of call:
% y=myexprnd(2,1,1e3)
%
% [S.M. October 2024]
%

y=-mu*log(rand(r,c));

