
addpath ../../device_cvep
expdev 3
addpath ../../device_p300
expdev 3

return

flash solid

expcvep 1 40 3 31 3 symbols		% ~30 Hz
expcvep 1 40 6 15 3 symbols		% ~30 Hz
expcvep 1 40 12 7 3 symbols		% ~30 Hz

expcvep 1 40 4 15 3 symbols		% ~20 Hz
expcvep 1 40 4 7 3 symbols		% ~10 Hz

expcvep 2 40 6 31 3 symbols		% ~60 Hz
expcvep 2 40 3 31 3 symbols		% ~30 Hz
expcvep 2 40 1 63 3 symbols		% ~20 Hz
expcvep 2 40 1 31 3 symbols		% ~10 Hz

expp300 1 40 3 3.6 square         % ~3 Hz
expp300 2 40 3 3.6 square         % ~3 Hz
expp300 2 40 5 3 square           % ~7 Hz
expp300 2 40 7 3 square           % ~9 Hz

ssvep solid
%expssvep 100 solid

disp done
