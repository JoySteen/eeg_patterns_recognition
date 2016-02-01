function results = processcvep(fileName,trainInds,testInds)

[epochs, params] = loadcvep(fileName);

% вывод данных для fisheradapttest
if nargin == 1
    assert(params.version~=2)
    for o = 1:params.nStimuli
        offset = - params.offsets(o)*params.sampleRate/params.frameRate;
        vects = cvepfeatures(offset,epochs,params);
        vects = permute(vects,[1,3,2]);
        if o == 1
            results = zeros([size(vects),params.nStimuli]);
        end
        results(:,:,:,o) = vects;
    end
    %mdl = cveptrain(params.targets,epochs,params);
    return
end

%show(epochs,params);

mdl = cveptrain(params.targets(trainInds),epochs(:,:,trainInds),params);

%show_weights(mdl.weights)

results = cvepdetect(mdl,epochs(:,:,testInds),params);

return

% показывает графики последнего электрода
function show(epochs,params)
vects = cvepfeatures(0,epochs(end,:,:),params);
vects = squeeze(mean(vects,2));
maxval = max(abs(vects(:)));
bins = (-10:10)/10*maxval;
ranges = (-10.5:10.5)/10*maxval;
dim1 = ceil(sqrt(size(vects,1)));
dim2 = ceil(size(vects,1)/dim1);
clf
for n = 1:size(vects,1)
    subplot(dim1,dim2,n)
    hold all
    h = zeros(4,length(ranges));
    for k = 1:4
        h(k,:) = histc(vects(n,k==params.targets),ranges);
        h(k,:) = h(k,:)/sum(h(k,:));
    end
    plot(bins,h(:,1:end-1)')
    if n <= (params.period-1)/2
        freq = n*params.frameRate/params.period;
        title(sprintf('%.1f Hz',freq))
    end
end
return

function show_weights(weights)
figure(182634)
w = reshape(weights,[5,7,2]);
x = 0:0.001:2*pi;
for n = 1:5
    y = zeros(size(x));
    for k = 1:7
        y = y + w(n,k,1)*cos(x*k)+w(n,k,2)*sin(x*k);
    end
    subplot(2,3,n)
    hold on
    plot(x,y)
end
return
