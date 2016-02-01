function success = devtest(type,version)

if ~nargin
    devtest cvep 4
    devtest p300 5
    return
end

devinit;

[params,generate,run] = devsettings(type,version);

epoch = zeros(params.nStepSamples,8,'int32');
for t = 1:params.nStepSamples:params.nSamples
    for n = 1:params.nStepSamples
        epoch(n,3:7) = generate(int32(t+n-1),params)';
    end
    [~,~,successPerf,falsePerf,checksum] = run(epoch',params);
end

if successPerf > 99.9 && falsePerf == 0 && checksum == params.checksum
    success = true;
else
    success = false;
end

return
