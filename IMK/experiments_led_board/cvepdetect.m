% Функция детектирования
function result = cvepdetect(mdl,epochs,params)

labels = zeros(4,size(epochs,3));
if params.version == 2
    nStimuli = size(params.sequences,1);
    vects = cvepfeatures(0,epochs,params);
    for k = 1:nStimuli
        for n = 1:size(vects,3)
            labels(k,n) = mean(mdl{k}.weights*vects(:,:,n)) > mdl{k}.threshold;
        end
    end
else
    for o = 1:length(params.offsets)
        offset = - params.offsets(o)*params.sampleRate/params.frameRate;
        vects = cvepfeatures(offset,epochs,params);
        for n = 1:size(vects,3)
            labels(o,n) = mean(mdl.weights*vects(:,:,n)) > mdl.threshold;
        end
    end
end

[~,result] = max(labels,[],1);
result(sum(labels,1)~=1) = 0;

return

