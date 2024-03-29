% ������� ��������
function mdl = cveptrain(targets,epochs,params)

if params.version == 2
    vects = cvepfeatures(0,epochs,params);
    X = reshape( vects, [ size(vects,1), params.nSteps*size(vects,3) ]);
    mdl = cell(1,params.nStimuli);
    for k = 1:params.nStimuli
        T = repmat(k==targets,[params.nSteps,1]);
        T = reshape( T, [ 1, size(X,2) ]);
		fishertrain;
        fishertrain(X,T);
        mdl{k} = fishertrain(params.nSteps,params.nStimuli);
    end
else
	fishertrain;
    for o = 1:params.nStimuli
        offset = - params.offsets(o)*params.sampleRate/params.frameRate;
        vects = cvepfeatures(offset,epochs,params);
        for t = 1:length(targets)
            fishertrain(vects(:,:,t),(o==targets(t))*ones(1,params.nSteps));
        end
    end
    mdl = fishertrain(params.nSteps,params.nStimuli);
end

return

