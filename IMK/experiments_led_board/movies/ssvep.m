function [movie,frameRate,frequencies] = ssvep(patternName)

divisors = [ 24 18 12 10 ]; % делители должны быть четными
frameRate = 125;
frames = 120*3; % количество кадров должно делиться на любой divisors
frequencies = frameRate./divisors; %#ok<*NASGU>

bright = pattern(patternName,ones(2)*2);
bright = bright(1:4,1:4);
dark = pattern(patternName,ones(2));
dark = dark(1:4,1:4);

movie = [];
for n = 1:4
    trend = repmat(bright,[1,1,divisors(n)/2]);
    trend(:,:,end+1:end+divisors(n)/2) = repmat(dark,[1,1,divisors(n)/2]);
    trend = repmat(trend,[1,1,frames/divisors(n)]);
    switch n
        case 1
            movie(1:4,1:4,:) = trend;
        case 2
            movie(1:4,5:8,:) = trend;
        case 3
            movie(5:8,1:4,:) = trend;
        case 4
            movie(5:8,5:8,:) = trend;
    end
end

if ~nargout
    filename = sprintf('ssvep-%s',patternName);
    save(filename,'movie','frameRate','frequencies')
    clear
end

return
