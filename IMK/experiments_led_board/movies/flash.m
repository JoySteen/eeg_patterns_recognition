function flash(pattern)

patterns.check1 = [
    1 0 1 0 1 0 1 0
    0 1 0 1 0 1 0 1
    1 0 1 0 1 0 1 0
    0 1 0 1 0 1 0 1
    1 0 1 0 1 0 1 0
    0 1 0 1 0 1 0 1
    1 0 1 0 1 0 1 0
    0 1 0 1 0 1 0 1
    ]; %#ok<*NASGU>

patterns.check2 = [
    1 1 0 0 1 1 0 0 
    0 0 1 1 0 0 1 1
    1 1 0 0 1 1 0 0 
    0 0 1 1 0 0 1 1
    1 1 0 0 1 1 0 0 
    0 0 1 1 0 0 1 1
    1 1 0 0 1 1 0 0 
    0 0 1 1 0 0 1 1
    ];

patterns.check4 = [
    1 1 1 1 0 0 0 0
    1 1 1 1 0 0 0 0
    1 1 1 1 0 0 0 0
    1 1 1 1 0 0 0 0
    0 0 0 0 1 1 1 1
    0 0 0 0 1 1 1 1
    0 0 0 0 1 1 1 1
    0 0 0 0 1 1 1 1
    ];

patterns.squares = [
    0 0 0 0 1 1 1 1
    0 1 1 0 1 0 0 1
    0 1 1 0 1 0 0 1
    0 0 0 0 1 1 1 1
    1 1 1 1 0 0 0 0
    1 0 0 1 0 1 1 0
    1 0 0 1 0 1 1 0
    1 1 1 1 0 0 0 0
    ];

patterns.solid = ones(8);

movie = patterns.(pattern);
movie(:,:,2) = 1 - movie;
save(['flash-' pattern],'movie')

return
