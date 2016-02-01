% �������� ��������� �����
%	2 ����: 3
%   3 ����: 6
%   4 ����: 9 C
%   5 ���: 12 14 17 1B 1D 1E
%   6 ���: 21 2D 30 33 36 39
%
function [seq,bits] = msequence(poly)
if ischar(poly)
    poly = hex2dec(poly);
end
bits = 1+fix(log2(poly));
poly = bitget(poly,1:bits);
n = zeros(1,bits);
n(1) = 1;
seq = zeros(1,2^bits-1);
for k = 1:length(seq)
    seq(k) = n(1);
    n = [ rem(sum(poly.*n),2), n(1:end-1) ];
end
return
