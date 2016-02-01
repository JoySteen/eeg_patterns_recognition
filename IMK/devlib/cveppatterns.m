function patterns = cveppatterns
patterns = zeros(8,8,4,'uint8');
background = uint8([
    1 1 1 0 0 1 1 1
    1 1 1 0 0 1 1 1
    1 1 1 0 0 1 1 1
    0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0
    1 1 1 0 0 1 1 1
    1 1 1 0 0 1 1 1
    1 1 1 0 0 1 1 1
    ]);
symbols = uint8([
    0 1 1 0 0 1 0 1
    1 0 1 0 0 1 1 1
    1 0 1 0 0 1 0 1
    0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0
    1 1 1 0 0 1 1 1
    1 0 1 0 0 1 0 0
    1 1 1 0 0 1 0 0
    ]);
patterns(:,:,2) = symbols*4+(background-symbols)*3;
patterns(:,:,3) = background*2;
patterns(:,:,4) = symbols*6+(background-symbols)*3;
return
