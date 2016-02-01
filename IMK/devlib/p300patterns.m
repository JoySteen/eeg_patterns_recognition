function patterns = p300patterns
patterns = zeros(8,8,4,'uint8');
squares = uint8([
    0 0 0 0 0 0 0 0
    0 1 1 0 0 1 1 0
    0 1 1 0 0 1 1 0
    0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0
    0 1 1 0 0 1 1 0
    0 1 1 0 0 1 1 0
    0 0 0 0 0 0 0 0
    ]);
patterns(:,:,1) = squares*4;
patterns(:,:,2) = squares*4+(1-squares)*3;
patterns(:,:,3) = squares*2;
patterns(:,:,4) = squares*2+(1-squares)*3;
return
