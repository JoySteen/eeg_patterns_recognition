% создает файл с картинками для показа на матрице
function devmovie(type,version)

if ischar(version), version = str2double(version); end
[params,~,~,devpatterns,devshow] = devsettings(type,version);
patterns = devpatterns();

movie = zeros(8,8,0);
for t = 1:params.nFrameSamples:params.nSamples
    selection = devshow(t,params);
    image = zeros(8,8,'uint8');
    image(1:4,1:4) = patterns(1:4,1:4,selection(1)+1);
    image(1:4,5:8) = patterns(1:4,5:8,selection(2)+1);
    image(5:8,1:4) = patterns(5:8,1:4,selection(3)+1);
    image(5:8,5:8) = patterns(5:8,5:8,selection(4)+1);
    movie(:,:,end+1) = image; %#ok<AGROW>
end

frameRate = params.frameRate;
params.fileName = sprintf('%s-v%i',type,version);
save(params.fileName,'params','movie','frameRate')
fprintf('Сохранен\t%.1f Hz\t\t%s\n',frameRate,params.fileName);

return
