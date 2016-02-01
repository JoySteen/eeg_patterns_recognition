%% Function targ_nontarg defines starttimes of light and N100 and P300 waves
% and write this times in file prm_table.csv

% Args:
% source_ch - source of signal (channel)
% filedat - file, which contains information about target and nontarget
% stimuli

% prm_vector [duration of experiment in seconds, ...
% amplitude of N100 (Pz), ...
% amplitide of P300 (Pz)]

% prm_table - table.csv, whisource_ch contain some parameters:
% start_time - start_time of artifact
% duration - duration of artifact
% amplitide - amplitude of artifact
% event - type of artifact (oculographic,myographic artifacts or
% alpha-waves)
% channels - contains name of channel, which was source of signal

% Example: targ_nontarg ('Pz', 'p300-v1-40x3-3.6s-square.mat',[30 10 20],'prm_table.csv')

function [] = targ_nontarg (source_ch,filedat,prm_vector,prm_table)
if nargin<1
    source_ch='Pz';
    prm_vector=[30 1 1];
    filedat='p300-v1-40x3-3.6s-square.mat';
    prm_table=readtable('prm_table.csv');
else
    prm_table=readtable(prm_table);
end

load (filedat) %data from experiment
% stim_duration=1000/params.frameRate; %stimulus duration
cycle_length=length(params.stimuli)/length(params.targets);
%params.stimuli - sequence of all stimuli,
%params.frameRate -frequency of flashes(Hz)

%%
% division into target and nontarget stimuli
targ_matrix=zeros(1,length(params.stimuli));

for i=1:length(params.targets)
    targ=zeros(1,cycle_length);
    n=cycle_length*(i-1);
    find_targ=params.stimuli((1+n):(cycle_length+n))/params.targets(i);
    str=find(find_targ==1);
    targ(str)=targ(str)+1;
    targ_matrix((1+n):(cycle_length+n))=targ;
end

%% define stimuli start time, n100 start time, p300 start time
t=0:0.004:prm_vector(1);
st_number=round(length(t)/75)-1; %number of stimuli matsource_ches to duration of experiments
targ_matrix=targ_matrix(1:st_number);

start_times=1:1:st_number;
start_times=start_times';
start_times=start_times*0.3;
n100_times=start_times+0.1;
str=find(targ_matrix==1);
p300_times=start_times(str)+0.3;

fin_matrix=[start_times; n100_times; p300_times];

duration=0.096;
n100_amp=prm_vector(2);
p300_amp=prm_vector(3);

fin_matrix_end=length(start_times)*2+length(p300_times);
fin_matrix(length(start_times)+1:fin_matrix_end,2)=duration;

fin_matrix(length(start_times)+1:length(start_times)*2,3)=-n100_amp;
fin_matrix(length(start_times)*2+1:fin_matrix_end,3)=p300_amp;

%% string content of final table
n100='n100';
p300='p300';
blank='flick_on';

names=zeros(length(start_times),10);
names_blank=[];
names_source_ch=[];
names_n100=[];
names_p300=[];

for i=1:length(start_times)
   names_source_ch(i,1:length(source_ch))=source_ch;
   names_n100(i,1:length(blank))=[n100,'ssss'];
   names_p300(i,1:length(blank))=[p300,'ssss'];
   names_blank(i,1:length(blank))=blank;
end

names_p300=names_p300(1:length(p300_times),:);

names_all=[names_blank; names_n100; names_p300];
names_all=cellstr(char(names_all));

names_source_ch_all=[names_source_ch;names_source_ch;names_source_ch(1:length(names_p300),:)];
names_source_ch_all=cellstr(char(names_source_ch_all));

%% final table
T=table(fin_matrix(:,1),fin_matrix(:,2),fin_matrix(:,3),names_all,names_source_ch_all, ...
    'VariableNames',{'start_time','duration','amplitude','event','source_channels'});
RES=[prm_table;T];

writetable(RES,'prm_table_fin.csv');
end