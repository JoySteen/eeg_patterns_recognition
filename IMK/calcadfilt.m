clear;

ches_range = [228:258,263:265];
%check
for ches=ches_range
    load([num2str(ches),'.mat']);
end

Hd4 = filter_4Hz();
Hd7 = filter_7Hz();
Hd10 = filter_10Hz();
Hd14 = filter_14Hz();
Hd15 = filter_15Hz();
variants = fullfact([7,7]);
rec = 1;
weights = double(zeros(size(variants,1),size(ches_range,2)));

for ches=ches_range
%for ches=217:217
    load([num2str(ches),'.mat']);
    [perf0]=process(num2str(ches));
    max = perf0;
    better = [0,0,0,0,0,0];
    
    for var = 1:size(variants,1)
        load([num2str(ches),'.mat']);
        for dis = 1:size(variants,2)
            for i= 3:7
                Fx1 = data(:,i);
                Mvl = [];
                for k = 101:size(data,1)
                    Mvl(k-100) = mean(abs(data(k-100:k,i)));
                end
                p = (max(Mvl) - min(Mvl))*0.5;
                
                if (variants(var,dis) == 2)
                    Fxo = filter(Hd15,double(Fx1));
                    Fxo = [Fxo(32:end);zeros(31,1)];
                end
                if (variants(var,dis) == 3)
                    Fxo = filter(Hd14,double(Fx1));
                    Fxo = [Fxo(32:end);zeros(31,1)];
                end
                if (variants(var,dis) == 4)
                    Fxo = filter(Hd10,double(Fx1));
                    Fxo = [Fxo(32:end);zeros(31,1)];
                end
                if (variants(var,dis) == 5)
                    Fxo = filter(Hd7,double(Fx1));
                    Fxo = [Fxo(32:end);zeros(31,1)];
                end
                if (variants(var,dis) == 6)
                    Fxo = filter(Hd4,double(Fx1));
                    Fxo = [Fxo(32:end);zeros(31,1)];
                end
                if (variants(var,dis) == 7)
                    Fxo = smooth(double(Fx1),40);
                end
                
                Mvlv = [];
                for k = 101:size(Fxo,1)
                    Mvlv(k-100) = mean(abs(Fxo(k-100:k,i)));
                end
                for k = 101:size(Fxo,1)
                    if (Mvlv(k) < p)
                        Fxo(k) = 0;
                    end
                end
                
                data(:,i) = Fx1 - int32(Fxo);
            end
        end
        save([num2str(ches),'_filtered.mat']);
        [perf]=process([num2str(ches),'_filtered']);
        weights(var,rec) = perf;
        if (perf > max)
            max = perf;
            better = variants(var,:);
        end
        perf = 0;
    end
    
    fprintf('Set %s %d result %d%% was %d%% better on %d%% \n',subject,ches,int32(max*100),int32(100*perf0),int32((max*100)/perf0)-100);
    disp(better);
    fprintf('\n');
    rec = rec+1;

end;

for i = 1:size(ches_range',1)
    Names(i) = cellstr(['record_',num2str(ches_range(i))]);
end
T = array2table(weights,'VariableNames',Names);
writetable(T,'weights_table.csv');