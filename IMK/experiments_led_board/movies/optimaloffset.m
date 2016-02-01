function optimaloffset(offsets)

%polys = { '12' '14' '17' '1B' };
polys = { '21' '2D' '30' '33' };

%polys = { '14' '14' '14' '14' };
%polys = { 'C' 'C' 'C' 'C' };
%polys = { '30' '30' '30' '30' };
for n = 1:length(polys)
    seq(n,:) = msequence(polys{n});
end

if nargin
    val = offsetcorr(seq,offsets)
    return
end

minval = inf;
len = size(seq,2);
for n2 = 0:len-1
    for n3 = 0:len-1
        for n4 = 0:len-1
            offsets = [ 0, n2, n3, n4 ];
            val = offsetcorr(seq,offsets);
            if val < minval
                minval = val;
                minoff = offsets ;
            end
            
        end
    end
end

minval
minoff

return


function val = offsetcorr(seq,offsets)
for n = 1:4
    seq(n,:) = circshift(seq(n,:),[0,offsets(n)]);
end
CI = [ 0 1 1 1; 0 0 1 1; 0 0 0 1; 0 0 0 0 ];
C = corr(seq');
val = max(abs(C(CI~=0)));
return
