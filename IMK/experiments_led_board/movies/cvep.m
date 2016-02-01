function [movie,offsets,sequences] = cvep(patternName,period,version)

switch version
    case 1
        switch period
            case 7
                polynomials = { '6' '6' '6' '6' };
                offsets = [ 0 2 4 6 ];
            case 15
                polynomials = { 'C' 'C' 'C' 'C' };
                offsets = [ 0 4 8 12 ];
            case 31
                polynomials = { '14' '14' '14' '14' };
                offsets = [ 0 8 16 24 ];
            case 63
                polynomials = { '30' '30' '30' '30' };
                offsets = [ 0 16 32 48 ];
            otherwise
                error('Неизвестное значение')
        end
    case 2
        switch period
            case 7
                error('Не предусмотрено')
            case 15
                error('Не предусмотрено')
            case 31
                polynomials = { '12' '14' '17' '1B' };
                offsets = [ 0 18 8 6 ];
            case 63
                polynomials = { '21' '2D' '30' '33' };
                offsets = [ 0 12 2 54 ];
            otherwise
                error('Неизвестное значение')
        end
    otherwise
        error('Неизвестное значение')
end

for k = 1:4
    sequences(k,:) = msequence(polynomials{k}); %#ok<AGROW>
    sequences(k,:) = circshift(sequences(k,:),[0,offsets(k)]); %#ok<AGROW>
end
assert(size(sequences,2)==period)

movie = zeros(8,8,period);
for k = 1:period
    sel = [ 1 1; 1 1 ];
    for n = 1:4
        if sequences(n,k)
            sel(n) = 2;
        end
    end
    movie(:,:,k) = pattern(patternName,sel);
end

if version ~= 1
    offsets = [];
end

return
