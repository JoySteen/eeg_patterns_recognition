clear;

Hd4 = filter_4Hz();
Hd7 = filter_7Hz();
Hd10 = filter_10Hz();
Hd14 = filter_14Hz();
Hd15 = filter_15Hz();

for ches=218
%for ches=217:217

    load([num2str(ches),'.mat']);
    [perf0,err0]=process(num2str(ches));

    for i= 3:7
        Fx1 = data(:,i);

        Fxo15 = filter(Hd15,double(Fx1));
        Fxo15 = [Fxo15(32:end);zeros(31,1)];

        data(:,i) = Fx1 - int32(Fxo15);
    end

    save([num2str(ches),'_filtered.mat']);
    [perf15]=process([num2str(ches),'_filtered']);

    load([num2str(ches),'.mat']);

    for i= 3:7
        Fx1 = data(:,i);

        Fxo14 = filter(Hd14,double(Fx1));
        Fxo14 = [Fxo14(32:end);zeros(31,1)];

        data(:,i) = Fx1 - int32(Fxo14);
    end

    save([num2str(ches),'_filtered.mat']);
    [perf14]=process([num2str(ches),'_filtered']);
    
    load([num2str(ches),'.mat']);

    for i= 3:7
        Fx1 = data(:,i);

        Fxo10 = filter(Hd10,double(Fx1));
        Fxo10 = [Fxo10(32:end);zeros(31,1)];

        data(:,i) = Fx1 - int32(Fxo10);
    end

    save([num2str(ches),'_filtered.mat']);
    [perf10]=process([num2str(ches),'_filtered']);
    
    load([num2str(ches),'.mat']);

    for i= 3:7
        Fx1 = data(:,i);

        Fxo7 = filter(Hd7,double(Fx1));
        Fxo7 = [Fxo7(32:end);zeros(31,1)];

        data(:,i) = Fx1 - int32(Fxo7);
    end

    save([num2str(ches),'_filtered.mat']);
    [perf7]=process([num2str(ches),'_filtered']);
    
    load([num2str(ches),'.mat']);

    for i= 3:7
        Fx1 = data(:,i);

        Fxo4 = filter(Hd4,double(Fx1));
        Fxo4 = [Fxo4(32:end);zeros(31,1)];

        data(:,i) = Fx1 - int32(Fxo4);
    end

    save([num2str(ches),'_filtered.mat']);
    [perf4]=process([num2str(ches),'_filtered']);
    
    load([num2str(ches),'.mat']);

    for i= 3:7
        Fx1 = data(:,i);

        Fxos = double(Fx1) - smooth(double(Fx1),40);

        data(:,i) = int32(Fxos);
    end

    save([num2str(ches),'_filtered.mat']);
    [perfs,err]=process([num2str(ches),'_filtered']);
    
    fprintf('Set %s %d result %d%%(-smooth_40 err %d%%) %d%%(-filt_15Hz) %d%%(-filt_14Hz) %d%%(-filt_10Hz) %d%%(-filt_7Hz) %d%%(-filt_4Hz) was %d%%\n',subject,ches,int32(perfs*100),int32(err*100),int32(perf15*100),int32(perf14*100),int32(perf10*100),int32(perf7*100),int32(perf4*100),int32(perf0*100));

end;