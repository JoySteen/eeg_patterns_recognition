clear;
[t,mf] = signal_generator();
mf = mf';

r = 1:size(mf,1);
d = mf;

Hd4 = filter_4Hz();
Hd7 = filter_7Hz();
Hd10 = filter_10Hz();
Hd14 = filter_14Hz();
Hd15 = filter_15Hz();

f3 = filter(Hd10,d);
f3 = [f3(32:end);zeros(31,1)];

f3_3 = filter(Hd10,d-f3);
f3_3 = [f3_3(32:end);zeros(31,1)];

f3_3_3 = filter(Hd10,d-f3-f3_3);
f3_3_3 = [f3_3_3(32:end);zeros(31,1)];

f3_3_3_3 = filter(Hd10,d-f3-f3_3-f3_3_3);
f3_3_3_3 = [f3_3_3_3(32:end);zeros(31,1)];

f3_3_3_3_3 = filter(Hd10,d-f3-f3_3-f3_3_3-f3_3_3_3);
f3_3_3_3_3 = [f3_3_3_3_3(32:end);zeros(31,1)];

plot(r,d,r,f3+max(d)*2,r,f3_3+max(d)*4,r,f3_3_3+max(d)*6,r,f3_3_3_3+max(d)*8,r,f3_3_3_3+max(d)*10,r,d-f3-max(d)*2,r,d-f3-f3_3-max(d)*4,r,d-f3-f3_3-f3_3_3-max(d)*6,r,d-f3-f3_3-f3_3_3-f3_3_3_3-max(d)*8,r,d-f3-f3_3-f3_3_3-f3_3_3_3-f3_3_3_3_3-max(d)*10);
%plot(r,d,r,f+8*10^8,r,f2+16*10^8,r,f3+24*10^8,r,d-f-8*10^8,r,d-f-f2-16*10^8,r,d-f-f2-f3-24*10^8);
%plot(r,d,r,f-8*10^8,r,f2-16*10^8,r,f3-24*10^8,r,f4-32*10^8,r,f5-38*10^8);
%plot(r,f3,r,f3_2-8*10^8,r,f3_3-16*10^8,r,f3_4-24*10^8);