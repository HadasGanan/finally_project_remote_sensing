clc
close all force
trained = 0;
%uncomment to reset training data
trainingData = load("trainingData.mat").trainingData;
trainingResult = load("trainingResult.mat").trainingResult;
pca = load("pca.mat").pca;
% trainingData = [];
% trainingResult = [];
while questdlg("collect more data?") == "Yes"
    [trainingDataTemp, trainingResultTemp, pca] = createTrainingData("tree(4-11).mat", "tree(4-11).png");
    trainingData = cat(1, trainingData, trainingDataTemp);
    trainingResult = cat(1, trainingResult, trainingResultTemp);
end
%uncomment to save training data
% save('trainingData.mat', 'trainingData')
% save('trainingResult.mat', 'trainingResult')
sizepca = size(pca);
Mdl = TreeBagger(100, trainingData, trainingResult, Method="classification", OOBPrediction="on");
view(Mdl.Trees{1},Mode="graph")
plot(oobError(Mdl))
xlabel("Number of Grown Trees")
ylabel("Out-of-Bag Classification Error")
p = reshape(pca, [sizepca(1) * sizepca(2), sizepca(3)]);
y = predict(Mdl, p);
y_square = str2double(reshape(y, sizepca(1), sizepca(2)));

figure
subplot(1,2,1),image(imread("tree(4-11).png")),title('RGB image')
colormap("sky")
subplot(1,2,2),imagesc(y_square),title('predicted')
datacursormode on

% figure
% rescalePC = rescale(reducedDataCube,0,1);
% montage(rescalePC,'BorderSize',[10 10],'Size',[1 sizepca(3)]);

% Count the number of zeros in the binary matrix y_square
numZeros = sum(y_square(:) == 1);

% Count the number of zeros in the binary matrix y_square
numZeros = sum(y_square(:) == 1);

% Calculate the total number of elements in the matrix y_square
totalElements = numel(y_square);

% Calculate the percentage of zeros
percentageZeros = (numZeros / totalElements) * 100;

% Display the result
disp(['Number of zeros in y_square: ', num2str(numZeros)]);
disp(['Percentage of zeros in y_square: ', num2str(percentageZeros), '%']);



function [trainingData, trainingResult, pca] = createTrainingData(dataMatrix, imgFile)
    pca_len = 5;
    [~, normalized, ~] = loadAndNormalize(dataMatrix);
    reducedDataCube = hyperpca(normalized,pca_len);
  
    I = imread(imgFile);
    title("select region and double click inside");
    [J,rect] = imcrop(I);
    imshow(J)
    title("mark flowers and press enter");
    [x_flower,y_flower,~] = impixel;
    width = fix(rect(3)) + 1;
    height = fix(rect(4)) + 1;
    m = zeros(height, width);
    xoffset = fix(rect(1));
    yoffset = fix(rect(2));
    for i = 1:length(x_flower)
        m(y_flower(i), x_flower(i)) = 1;
    end
    data = zeros(1, width * height, pca_len);
    result = zeros(width * height, 1);
    counter = 0;
    for y = yoffset:yoffset + height - 1
        for x = xoffset:xoffset + width - 1
            counter = counter + 1;
            data(1, counter, :) = reducedDataCube(y, x, :);
            result(counter) = m(y + 1 - yoffset, x + 1 - xoffset) == 1;
        end
    end
    
    trainingData = reshape(data, [width * height, pca_len]);
    trainingResult = result;
    pca = reducedDataCube;
end





