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

f = filter(Hd4,d);
f2 = filter(Hd7,d);
f3 = filter(Hd10,d);
f3_2 = filter(Hd10,d);
f3_3 = filter(Hd10,d);
f3_4 = filter(Hd10,d);
f4 = filter(Hd14,d);
f5 = filter(Hd15,d);

f = [f(32:end);zeros(31,1)];
f2 = [f2(32:end);zeros(31,1)];
f3 = [f3(32:end);zeros(31,1)];
f3_2 = [f3_2(32:end);zeros(31,1)];
f3_3 = [f3_3(32:end);zeros(31,1)];
f3_4 = [f3_4(32:end);zeros(31,1)];
f4 = [f4(32:end);zeros(31,1)];
f5 = [f5(32:end);zeros(31,1)];

sf3 = smooth(double(f3),1000);

plot(r,d,r,f+max(d)*2,r,f2+max(d)*4,r,f3+max(d)*6,r,f5+max(d)*8,r,sf3+max(d)*10,r,d-f-max(d)*2,r,d-f2-max(d)*4,r,d-f3-max(d)*6,r,d-f5-max(d)*8);
%plot(r,d,r,f+8*10^8,r,f2+16*10^8,r,f3+24*10^8,r,d-f-8*10^8,r,d-f-f2-16*10^8,r,d-f-f2-f3-24*10^8);
%plot(r,d,r,f-8*10^8,r,f2-16*10^8,r,f3-24*10^8,r,f4-32*10^8,r,f5-38*10^8);
%plot(r,f3,r,f3_2-8*10^8,r,f3_3-16*10^8,r,f3_4-24*10^8);