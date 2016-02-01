% Function channels plots 8 channels
% channel 1: stimulus switched on (max)/switched off(min)
% channel 2-8: signal (from function signal_generator.m)
% Args:
% chan_vector - contains names of channels, which was in use
% the first name of channel - source of signal
% prm_vector - contains [duration of experiment in seconds, ...
% amplitude of power-supply noise, ...
% amplitude of gaussian noise, ...
% amplitude of N100 (Pz), ...
% amplitude of P300 (Pz)]

% prm_table -
%excel table which contents start_times, durations, amplitudes of different
%events (oculographic, myographic artifacts or alpha-waves, ...
% start times of light, n100 and p300 waves)

%Example: channels (['Cz';'Pz';'Oz';'O1';'O2'], [30 2 2 10 20], 'prm_table.csv')

function [chan]=channels(source_ch,source_coord,chan_vector,prm_vector,prm_table)
%% INPUT ARGUMENTS
if nargin<1
    source_ch='Pz';
    source_coord=[226,278];
    chan_vector=['Pz';'Cz';'Oz';'O1';'O2'];
    prm_vector=[30 2 2 10 20];
    prm_table=readtable('prm_table_fin.csv');
else
    prm_table=readtable(prm_table);
end

%%
for i=1:length(chan_vector)
    
    ch=chan_vector(i,:);
    
    [t,chan(i,:)]=signal_generator(source_coord,ch,prm_vector,prm_table,chan_vector);
    
    subplot(length(chan_vector)+1,1,i)
    plot(t,chan(i,:))
    ylim([-100 100])
    text(0.1,60,ch)
end

signal_plot=zeros(1,length(chan));

st_number=round(length(t)/75)-1;
for z=1:st_number
    k=75*z;
    signal_plot(1+k:37+k)=1;
end
chan(8,1:end)=signal_plot;
subplot(8,1,8)
plot(t,chan(8,:))
ylim ([-1 2]);
end
