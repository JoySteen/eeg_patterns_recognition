function fisheradapttest(fileName)

if nargin
    load(fileName,'params')
    switch params.type %#ok<*NODEF>
        case 'cvep'
            X = processcvep(fileName);
        case 'p300'
            X = processp300(fileName);
    end
    Y = params.targets;
    nVars = size(X,1);
    nTargets = size(X,2);
    nSteps = size(X,3);
    nStimuli = size(X,4);
    artificial = 0;
else % искусственные данные
    ratio = 5; % разность между средними
    nVars = 16*5;
    nTargets = 40;
    nSteps = 6;
    nStimuli = 4;
    mu = randn(nVars,2); %#ok<*UNRCH>
    mu = ratio/sqrt(nSteps)*mu/norm(mu(:,1)-mu(:,2));
    Y = ones(1,nTargets);
    X = zeros(nVars,nTargets,nSteps,nStimuli);
    artificial = 1;
end

tau = nTargets*nSteps*nStimuli/10;
mdl = fisheradapt([nVars,tau,nStimuli]);

ys = [];
yes = [];
h = figure;
it = 0;
for r = 1:10
    if artificial
        X = randn(size(X));
        X(:,:,:,2:end) = bsxfun(@minus,X(:,:,:,2:end),mu(:,1));
        X(:,:,:,1) = bsxfun(@minus,X(:,:,:,1),mu(:,2));
    end
    for i = 1:nTargets
        for k = 1:nStimuli
            if ~ishandle(h)
                break
            end
            x = squeeze(X(:,i,:,k));
            y = Y(i)==k;
            val = mdl.weights*mean(x,2) - mdl.threshold;
             if r == 1
                 mdl = fisheradapt(mdl,x,repmat(y,[1,nSteps]));
             else % после первого цикла обучение несупервизируемое
                 mdl = fisheradapt(mdl,x,repmat(val>0,[1,nSteps]));
             end
            it = it + 1;
            ys(end+1) = y; %#ok<*AGROW>
            yes(end+1) = val>0;
            subplot 211
            hold on
            if y
                plot(it/nStimuli,val,'.r')
            else
                plot(it/nStimuli,val,'.b')
            end
            if length(ys) >= nTargets*nStimuli
                inds = length(ys)-nTargets*nStimuli+1:length(ys);
                subplot 212
                hold on
                r1 = 100*sum(~yes(inds)&ys(inds))/sum(ys(inds));
                r2 = 100*sum(yes(inds)&~ys(inds))/sum(~ys(inds));
                plot(it/nStimuli,r1,'.g')
                plot(it/nStimuli,r2,'.m')
                disp([r r1 r2])
            end
            drawnow
        end
    end
end

%save mdl mdl
