clear;

hStore = [0,1:1:1000];
nStore = 0;

for ches=217:227
    sNumber =num2str(ches);
    [h]=process(sNumber);


    for smP= 1:1:1000 
        load([num2str(ches),'.mat']);

        Fx2 = data(:,2);
        x = 0:0.004:(size(data,1)-1)/250;
        for i= 3:7
            Fx1 = data(:,i);
            %smP = 20;
            %Fxo = smoo2th(double(Fx1 - mean(Fx1)),smP) - smoo2th(double(Fx2 - mean(Fx2)),smP);
            %Fxo = double(Fx1) - smoo2th(double(Fx1 - mean(Fx1)),smP);
            Fxo = double(Fx1) - smooth(double(Fx1),smP);
            %Fxo = double(Fx1);
            %Fxo = Fx1 - Fx2;
            %Fxo = zeros(size(Fxo,1),1);
            data(:,i) = int32(Fxo);
        end

        Fx1 = Fx1 + 8 * 10^7;
        Fx2 = Fx2 - 8 * 10^7;

        %plot(x,Fx1,x,Fx2,x,Fxo);

        save([num2str(ches),'_smoothed.mat']);
        [perf]=process([num2str(ches),'_smoothed']);
        fprintf('smP=%d result %d%%\n',smP,int32(perf*100));
        h = [h,perf];
    end;
    hx = 0;
    hx = [hx,1:1:1000];
    plot(hx,h);
    hStore = [hStore;h];
    nStore = [nStore;ches];
end;