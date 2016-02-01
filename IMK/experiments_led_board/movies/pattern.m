function img = pattern(paternName,sel,len)

arrows = [
    1 1 1 0 0 1 1 1
    1 1 0 0 0 0 1 1
    1 0 1 0 0 1 0 1
    0 0 0 1 1 0 0 0
    0 0 0 1 1 0 0 0
    1 0 1 0 0 1 0 1
    1 1 0 0 0 0 1 1
    1 1 1 0 0 1 1 1
    ];

corners = [
    1 1 1 0 0 1 1 1
    1 1 1 0 0 1 1 1
    1 1 1 0 0 1 1 1
    0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0
    1 1 1 0 0 1 1 1
    1 1 1 0 0 1 1 1
    1 1 1 0 0 1 1 1
    ];

symbols = [
    3 4 4 0 0 4 3 4
    4 3 4 0 0 4 4 4
    4 3 4 0 0 4 3 4
    0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0
    4 4 4 0 0 4 4 4
    4 3 4 0 0 4 3 3
    4 4 4 0 0 4 3 3
    ];

switch paternName
    case 'square'
        patterns = zeros(4,4,3,'uint8');
        patterns(:,:,1) = [ 0 0 0 0; 0 4 4 0; 0 4 4 0; 0 0 0 0 ];
        patterns(:,:,2) = [ 3 3 3 3; 3 4 4 3; 3 4 4 3; 3 3 3 3 ];
        patterns(:,:,3) = [ 2 2 2 2; 2 4 4 2; 2 4 4 2; 2 2 2 2 ];
    case 'solid'
        patterns = zeros(4,4,3,'uint8');
        patterns(:,:,1) = zeros(4);
        patterns(:,:,2) = ones(4)*7;
        patterns(:,:,3) = [ 2 0 0 2; 0 2 2 0; 0 2 2 0; 2 0 0 2 ];
    case 'arrows'
        patterns = zeros(8,8,3,'uint8');
        patterns(:,:,1) = zeros(8);
        patterns(:,:,2) = arrows*7+(1-arrows)*4;
        patterns(:,:,3) = arrows*2;
    case 'corners'
        patterns = zeros(8,8,3,'uint8');
        patterns(:,:,1) = zeros(8);
        patterns(:,:,2) = corners*7;
        patterns(:,:,3) = corners*2;
    case 'symbols'
        patterns = zeros(8,8,3,'uint8');
        patterns(:,:,1) = zeros(8);
        patterns(:,:,2) = symbols;
        patterns(:,:,3) = (symbols~=0)*2;
end

if size(patterns,1) == 4
    img = [
        patterns(:,:,sel(1)), patterns(:,:,sel(3))
        patterns(:,:,sel(2)), patterns(:,:,sel(4))
        ];
else
    img = [
        patterns(1:4,1:4,sel(1)), patterns(1:4,5:8,sel(3))
        patterns(5:8,1:4,sel(2)), patterns(5:8,5:8,sel(4))
        ];
end

if nargin >= 3
    img = repmat(img,[1,1,len]);
end

return
