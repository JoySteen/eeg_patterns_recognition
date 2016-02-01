clear;
load('nimonitor.mat');

r = 1:15104;
d = data(:,2);

Hd4 = filter_4Hz();
Hd7 = filter_7Hz();
Hd10 = filter_10Hz();
Hd14 = filter_14Hz();
Hd15 = filter_15Hz();

f = filter(Hd4,data(:,2));
f2 = filter(Hd7,data(:,2));
f3 = filter(Hd10,data(:,2));
f3_2 = filter(Hd10,data(:,1));
f3_3 = filter(Hd10,data(:,3));
f3_4 = filter(Hd10,data(:,4));
f4 = filter(Hd14,data(:,2));
f5 = filter(Hd15,data(:,2));

f = [f(32:end);zeros(31,1)];
f2 = [f2(32:end);zeros(31,1)];
f3 = [f3(32:end);zeros(31,1)];
f3_2 = [f3_2(32:end);zeros(31,1)];
f3_3 = [f3_3(32:end);zeros(31,1)];
f3_4 = [f3_4(32:end);zeros(31,1)];
f4 = [f4(32:end);zeros(31,1)];
f5 = [f5(32:end);zeros(31,1)];

Mvl = [];
for k = 101:size(d,1)
    Mvl(k-100) = mean(abs(d(k-100:k)));
end
mvlMax = max(Mvl);
mvlMin = min(Mvl);
p = (mvlMax - mvlMin)*0.1;

%Filter 1
Mvlv = [];
for k = 101:size(f,1)
    Mvlv(k-100) = mean(abs(f(k-100:k)));
end
for k = 101:size(f,1)
    if (Mvlv(k-100) < p)
        f(k) = 0;
    end
end
%Filter 2
Mvlv = [];
for k = 101:size(f2,1)
    Mvlv(k-100) = mean(abs(f2(k-100:k)));
end
for k = 101:size(f2,1)
    if (Mvlv(k-100) < p)
        f2(k) = 0;
    end
end
%Filter 3
Mvlv = [];
for k = 101:size(f3,1)
    Mvlv(k-100) = mean(abs(f3(k-100:k)));
end
for k = 101:size(f3,1)
    if (Mvlv(k-100) < p)
        f3(k) = 0;
    end
end

plot(r,d,r,f+8*10^8,r,f2+16*10^8,r,f3+24*10^8,r,d-f-8*10^8,r,d-f-f2-16*10^8,r,d-f-f2-f3*4/10-24*10^8);
%plot(r,d,r,f+8*10^8,r,f2+16*10^8,r,f3+24*10^8,r,d-f-8*10^8,r,d-f-f2-16*10^8,r,d-f-f2-f3-24*10^8);
%plot(r,d,r,f-8*10^8,r,f2-16*10^8,r,f3-24*10^8,r,f4-32*10^8,r,f5-38*10^8);
%plot(r,f3,r,f3_2-8*10^8,r,f3_3-16*10^8,r,f3_4-24*10^8);