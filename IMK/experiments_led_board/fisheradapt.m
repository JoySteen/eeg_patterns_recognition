% mdl = fisheradapt([nVars,tau,nStimuli])
% mdl = fisheradapt(mdl,features,group)
function mdl = fisheradapt(arg,features,groups)
persistent Z mu tau nStimuli

reg = single(0.001); % уровень регул€ризации

if nargin == 1
    settings = arg;
    nVars = settings(1);
    tau = settings(2);
    nStimuli = settings(3);
    Z = zeros(nVars,'single');
    mu = zeros(nVars,2,'single');
    mdl = struct;
    mdl.weights = zeros(1,nVars,'single');
    mdl.threshold = single(0);
    return
end

if isempty(nStimuli)
    error('internal error')
end

mdl = arg;
for k = 1:size(features,2)
    ye = groups(k) + 1;
    if groups(k)
        rate = nStimuli;
    else
        rate = nStimuli/(nStimuli-1);
    end
    mu(:,ye) = mu(:,ye)*(1-rate/tau) + rate/tau*features(:,k);
    Z = Z*(1-rate/tau) + rate/tau*(features(:,k)-mu(:,ye))*(features(:,k)-mu(:,ye))';
    tr = trace(Z)/size(Z,1);
    if tr == 0
        continue
    end
    mdl.weights = mdl.weights - 1/tau/tr*( mdl.weights*Z + mdl.weights*reg*tr - (mu(:,2)-mu(:,1))' );
end
mu1 = mdl.weights*mu(:,1);
mu2 = mdl.weights*mu(:,2);
mdl.threshold = (mu2+mu1)/2;
%sigma2 = mdl.weights*Z*mdl.weights';
%mdl.threshold = (mu2+mu1)/2 - sigma2/2/6/(mu2-mu1)*log(P);

return
