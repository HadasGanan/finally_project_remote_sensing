% Load the .mat file
loadedData = load('selectedsammap_binary.mat');

% Extract the binary matrix from the loaded data
binaryMap = loadedData.binaryMap;

% Display the binary matrix in the Command Window
disp('Binary map matrix:');
disp(binaryMap);

% Optionally, display the size of the matrix
disp('Size of the binary map matrix:');
disp(size(binaryMap));
