close all force
clc

% Step 1: Load the hyperspectral image
hyperspectralImage = 'tree(4-11).mat';
data = hyperspectralImage;


% Verify the dimensions of the hyperspectral image
[rows, cols, bands] = size(hyperspectralImage);
disp(['Image dimensions: ', num2str(rows), ' x ', num2str(cols), ' x ', num2str(bands)]);

% Ensure the image is numeric
hyperspectralImage = double(hyperspectralImage);

% Flatten the image for classification
img_flattened = reshape(hyperspectralImage, [], bands);

% Step 2: Load or define training data

% Example of creating training data and saving it
% X_train is a matrix of features
% Y_train is a vector of labels
X_train = []; % Fill this with your feature data
Y_train = []; % Fill this with your label data

% Save to a .mat file
save('training_data.mat', 'X_train', 'Y_train');

% Replace this with your actual training data loading or definition
load('training_data.mat'); % This file should contain X_train and Y_train
% X_train should be a matrix of size (num_samples x num_features)
% Y_train should be a vector of size (num_samples x 1)

% Check the number of features in the flattened image
disp(['Number of features in the image: ', num2str(size(img_flattened, 2))]);

% Ensure the number of columns matches the number of features the model was trained on
numFeatures = size(X_train, 2); % Number of features used for training
if size(img_flattened, 2) ~= numFeatures
    error('The number of features in the image (%d) does not match the number of features used for training (%d).', size(img_flattened, 2), numFeatures);
end

% Step 3: Train the Random Forest model (if not already trained)
% You should only need this if you haven't trained the model yet
numTrees = 100; % Example: number of trees in the forest
rfModel = TreeBagger(numTrees, X_train, Y_train, 'OOBPredictorImportance', 'On');

% Step 4: Predict the classes for each pixel
predictions = predict(rfModel, img_flattened);
predictions = str2double(predictions); % Convert string predictions to numeric if necessary

% Reshape the predictions to the original image shape
predictions_image = reshape(predictions, [rows, cols]);

% Step 5: Save or display the classified image
imagesc(predictions_image);
title('Classified Image');
colorbar;
