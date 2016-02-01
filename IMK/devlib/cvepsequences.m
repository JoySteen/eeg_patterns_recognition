nBits = 16;
nums = [];
sds = [];
seqs = zeros(0,nBits);
for n = 1:2^nBits
    bits = bitget(n-1,1:nBits);
    if sum(bits) ~= nBits/2
        continue
    end
    f = fft(bits);
    sd = std(abs(f(2:nBits/2-1)));
    if all(f(2:nBits/2-1)==0)
        continue
    end
    if sd > 0.333
        continue
    end
    found = false;
    for k = 1:size(seqs,1)
        for l = 1:nBits-1
            x = circshift(bits,[0,l]);
            if all(x==seqs(k,:))
                found = true;
                break
            end
        end
        if found
            break
        end
    end
    if found
        continue
    end
    seqs(end+1,:) = bits;
    hold all
    plot(abs(f))
    sds(end+1) = sd;
    nums(end+1) = n;
end

seqs

c = zeros(size(seqs,1),nBits-1);
for n = 1:size(seqs,1)
    bits = seqs(n,:);
    for l = 1:nBits-1
        x = circshift(bits,[0,l]);
        c(n,l) = corr(x',bits');
    end
end
c
