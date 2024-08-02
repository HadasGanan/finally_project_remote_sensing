close all force
tree = "4-11";
m = load("predict_" + tree + ".mat").y_square;
I = imread("tree(" + tree + ").png");
I = imresize(I, [512 512]);
figure
subplot(1,2,1), image(I),title('RGB image')
colormap("sky")
subplot(1,2,2),imagesc(m),title('predicted')
% datacursormode on

% Count the number of zeros in the binary matrix y_square
numZeros = sum(m(:) == 1);

% Count the number of zeros in the binary matrix y_square
numZeros = sum(m(:) == 1);

% Calculate the total number of elements in the matrix y_square
totalElements = numel(m);

% Calculate the percentage of zeros
percentageZeros = (numZeros / totalElements) * 100;

% Display the result
disp(['Number of zeros in m: ', num2str(numZeros)]);
disp(['Percentage of zeros in m: ', num2str(percentageZeros), '%']);