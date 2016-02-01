%% Function signal_generator generates signal,
%which have two different forms in two conditions:
%condition 1: non-target stimulus presents, signal form - n100
%condition 2: target stimulus presents, signal form - n100+p300
%also generates myographic, oculographic artifacts and alpha-waves
% Args:
% source_ch

% prm_vector - contains [duration of experiment in seconds, ...
% amplitude of power-supply noise, ...
% amplitude of gaussian noise, ...
% amplitude of P300 (Oz), ...
% amplitude of N100 (0z)]

% prm_table -
%matlab table which contents start_times, durations, amplitudes of different
%events (oculographic, myographic artifacts or alpha-waves)

%Example: channels ('Oz', [30 2 2 10 20], prm_table)
%%
function[t,main_f]=signal_generator(source_coord,ch,prm_vector,prm_table,chan_vector)

if nargin<1
    source_coord=[228,279];
    ch='Cz';
    prm_vector=[30 2 2 0.1 0.1];
    prm_table=readtable('prm_table_fin.csv');
    chan_vector=['Pz';'Cz';'Oz';'O1';'O2'];
end

R=3;
source_ch=chan_vector(1);

sources=[];
for i=1:length(chan_vector)
    s=strmatch(chan_vector(i,1:2),prm_table.source_channels);
    if size(s)>0
        source(i).chan=[sources; chan_vector(i,1:2)];  
        source(i).string=s;
    end
end

for i=1:9
    switch i
        case 1, ch_h='Cz'; x_y=[224,229]; 
        case 2, ch_h='Pz'; x_y=[228,279];
        case 3, ch_h='Oz'; x_y=[227,355]; 
        case 4, ch_h='O1'; x_y=[181,346]; 
        case 5, ch_h='O2'; x_y=[270,344]; 
        case 6, ch_h='PO7'; x_y=[139,326]; 
        case 7, ch_h='PO8'; x_y=[309,326]; 
        case 8, ch_h='P3'; x_y=[167,282]; 
        case 9, ch_h='P4'; x_y=[285,283]; 
    end
    
    if strcmp(ch_h,ch)==1
        ch_coord=x_y;
    end
    
    for s=1:length(source)
        if strcmp(source(s).chan,ch_h)==1
            source(s).coord=x_y;   
        end
    end
end

for s=1:length(source)
        dot=[ch_coord(1),source(s).coord(2)];
        a=source(s).coord(1)-dot(1);
        b=ch_coord(2)-dot(2);
        c(s)=sqrt(a^2+b^2)/100;

    if ch==source(s).chan
        c(s)=1/R;
    end
end

%% SIMPLE EEG
%% power-supply noise
%sampling frequency - 250 Ãö
t=0:0.004:prm_vector(1); % full experiment time (samples)
ps_f=prm_vector(2)*sin(2*pi*50*t); % power-supply noise function

%% gaussian noise
rng('shuffle');
shum=(rand(1,length(t))-0.5)*2; % generation of gaussian noise
gn_f=shum*prm_vector(3); % gaussian noise function

%% main function
main_f=ps_f+gn_f; % main function

%% N100 AND P300
%% imposition of N100 and P300 waves:
% if target stimuli presents - N100+P300
% if non-target stimuli presents - N100
% stimulus duration (flicker) - 150 ms, interstimulus interval - 150 ms
% if sample rate 250 Hz, then 300 ms - 75 samples(300/4), 100 ms - 25 samples(100/4)

%%
n100_str=strmatch('n100',prm_table.event);
p300_str=strmatch('p300',prm_table.event);

n100_s(length(n100_str)).time=zeros(0,0); p300_s(length(n100_str)).time=zeros(0,0);
n100_s(length(n100_str)).func=zeros(0,0); p300_s(length(n100_str)).func=zeros(0,0);
% 
% n100_start=prm_table.start_time(n100_str)*250+1;
% p300_start=prm_table.start_time(p300_str)*250+1;

for i=1:length(source)
     num1=find(n100_str(1) < source(i).string & source(i).string<p300_str(1));
     source(i).n100str=source(i).string(num1);
     num2=find(source(i).string>n100_str(end));
     source(i).p300str=source(i).string(num2);
end

for s=1:length(source)
    
for i=1:length(source(s).n100str)
    n100_s(i).time=0:0.004:prm_table.duration(source(s).n100str(i)); 
    n100_w=2*pi*5;
    n100_s(i).time=n100_s(i).time*n100_w;
    
    n100_amp=prm_table.amplitude(source(s).n100str(i))/(c(s)*R)
    n100_s(i).func=n100_amp*sin(n100_s(i).time); 
    
    n100_start=prm_table.start_time(source(s).n100str(i))*250+1
    main_f(n100_start:n100_start+length(n100_s(i).func)-1)=...
        main_f(n100_start:n100_start+length(n100_s(i).func)-1)+n100_s(i).func;
end

for i=1:length(source(s).p300str)
    p300_s(i).time=0:0.004:prm_table.duration(source(s).p300str(i)); 
    p300_w=2*pi*5;
    p300_s(i).time=p300_s(i).time*p300_w;
    
    p300_amp=prm_table.amplitude(source(s).p300str(i))/(c(s)*R)
    p300_s(i).func=p300_amp*sin(p300_s(i).time);
    
    p300_start=prm_table.start_time(source(s).p300str(i))*250+1
    main_f(p300_start:p300_start+length(p300_s(i).func)-1)=...
        main_f(p300_start:p300_start+length(p300_s(i).func)-1)+p300_s(i).func;
end
end

%% ARTIFACTS
%% myographic artifacts
myo_str=strmatch('myo',prm_table.event);
m_s(length(myo_str)).time=zeros(0,0);
m_s(length(myo_str)).func=zeros(0,0);
for i=1:length(myo_str)
    m_s(i).time=0:0.004:prm_table.duration(myo_str(i)); % myo.artif. time (samples)
    m_w=2*pi*30;
    m_s(i).time=m_s(i).time*m_w;
    m_s(i).func=prm_table.amplitude(myo_str(i))*sin(m_s(i).time); %myographic artifacts function
    str=find(t==prm_table.start_time(myo_str(i)));
    main_f(str:str+length(m_s(i).func)-1)=...
         main_f(str:str+length(m_s(i).func)-1)+m_s(i).func;
end

%% oculographic artifacts
eye_str=strmatch('oculo',prm_table.event);
e_s(length(eye_str)).time=zeros(0,0);
e_s(length(eye_str)).func=zeros(0,0);
for i=1:length(eye_str)
    e_s(i).time=0:0.004:prm_table.duration(eye_str(i));
    e_fr=2;
    e_w=2*pi*e_fr;
    e_s(i).time=e_s(i).time*e_w;
    e_s(i).func=prm_table.amplitude(eye_str(i))*sin(e_s(i).time);
    str=find(t==prm_table.start_time(eye_str(i)));
    main_f(str:str+length(e_s(i).func)-1)=...
         main_f(str:str+length(e_s(i).func)-1)+e_s(i).func;
end

%% generation of alpha waves
alpha_str=strmatch('alpha',prm_table.event); 
a_s(length(alpha_str)).time=zeros(0,0);
a_s(length(alpha_str)).func=zeros(0,0);
for i=1:length(alpha_str)
    a_s(i).time=0:0.004:prm_table.duration(alpha_str(i));
    a_w=2*pi*8;
    a_s(i).time=a_s(i).time*a_w;
    a_s(i).func=prm_table.amplitude(alpha_str(i))*sin(a_s(i).time);
    str=find(t==prm_table.start_time(alpha_str(i)));
    main_f(str:str+length(a_s(i).func)-1)=...
         main_f(str:str+length(a_s(i).func)-1)+a_s(i).func;
end

end

