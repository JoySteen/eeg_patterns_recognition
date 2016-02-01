% Возвращает фичи сигнала epochs
%   epochs: [ каналы, время, цели ]
%   vects: [ каналы * частоты * 2,  шаги, цели ]
function vects = cvepfeatures(offset,epochs,params)

nSteps = 1+fix((size(epochs,2)-fix(params.nEpochSamples))/params.nStepSamples);
vects = zeros([size(epochs,1),length(params.frequencies),nSteps,size(epochs,3)],'single');
vects = complex(vects,vects);

for s = 1:nSteps
    for t = 1:size(epochs,3)
        start = fix(params.nStepSamples*(s-1));
        sig = epochs(:,start+(1:fix(params.nEpochSamples)),t);
        sig = [ sig, zeros(size(sig,1),params.nWindowSamples-size(sig,2)) ]; %#ok<AGROW>
        sig = sig.*repmat(params.window,[size(epochs,1),1]);
        fsig = fft(sig,[],2);
        fsig = fsig(:,params.frequencies);
        shift = exp(-1i*(1:params.nFrequencies)*2*pi*single(start+offset)/params.nEpochSamples); % ?
        fsig = fsig .* repmat(shift,[size(epochs,1),1]);
        vects(:,:,s,t) = fsig;
    end
end

%vects = vects(:,1:end,:,:);
%vects = vects(:,2:end,:,:)./vects(:,1:end-1,:,:);
%vects = vects./abs(vects);
vects = reshape(vects,[size(vects,1)*size(vects,2),size(vects,3),size(vects,4)]);
vects = [ real(vects); imag(vects) ];
vects = single(vects);

return
