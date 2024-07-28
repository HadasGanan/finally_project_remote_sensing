clc
close all force
% Opening Hyperspectral Data File
[filename, foldername] = uigetfile('*.mat','Open Hyperspectral Data');
if isequal(filename,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(foldername,filename)]);
end
fullname = fullfile(foldername, filename);
temp = load(fullname);
fn = fieldnames(temp);
M = temp.(fn{1});
M = double(M);
minVal = min(M(:));
maxVal = max(M(:));

normalizedM = M - minVal;

[h, w, p] = size(normalizedM);
M = reshape(normalizedM, w*h, p).';
[p, N] = size(M);

% Remove mean from original data
u = mean(M.').';
for k=1:N
    M(:,k) = M(:,k) - u;
end

% Compute the covariance of signal + noise 
u = mean(M.').';
for k=1:N
    M(:,k) = M(:,k) - u;
end
sigma = (M*M.')/(N-1);

% Reshape new M as image-cube
M = reshape(M.', h, w, p); 

% Estimate the covariance of the noise
dX = zeros(h-1, w, p);
for i=1:(h-1)
    dX(i, :, :) = M(i, :, :) - M(i+1, :, :);
end
dX = reshape(dX, w*(h-1), p).';

% Compute the covariance of the noise 
[pdX, NdX] = size(dX);

udX = mean(dX.').';
for k=1:NdX
    dX(:,k) = dX(:,k) - udX;
end

sigmaN = (dX*dX.')/(NdX-1);

% Remove noise
tmp = sigmaN*inv(sigma);
[A, mu] = eigs(tmp,p);
noiseFractions = diag(mu);

% MNF transformation
M = reshape(M, w*h, p).';
M_mnf = A.'*M;

% Reshape MNF components as image-cube
M_mnf_img = reshape(M_mnf.', h, w, p); 

% Show the results
implay(M_mnf_img,2)

% Save the MNF image-cube as a .mat file
mnfFilename = 'M_mnf_img.mat'; % Specify the filename
save(mnfFilename, 'M_mnf_img'); % Save the variable to the file
disp(['MNF image-cube saved to ', mnfFilename]);

% Opening Wavelengths File
[filename, foldername] = uigetfile('*.mat','Open Wavelengths File');
if isequal(filename,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(foldername,filename)]);
end
fullname = fullfile(foldername, filename);
temp = load(fullname);
fn = fieldnames(temp);
Wvl = temp.(fn{1});

Rbandnorm = normalizedM(:,:,16);
Gbandnorm = normalizedM(:,:,8);
Bbandnorm = normalizedM(:,:,1);

HypRGBnorm = cat(3,Rbandnorm,Gbandnorm,Bbandnorm);

figure;
imshow(HypRGBnorm);
title('Select pixel spectrum');
[xBack, yBack] = ginput(1);
xBack  = round(xBack);
yBack  = round(yBack);
close;

spec = normalizedM(xBack,yBack,:);
spec = spec(:);

compnum = (1:p);
MNFsig = M_mnf_img(xBack,yBack,:);
MNFsig = MNFsig(:);

figure,
subplot(2,2,1), imagesc(normalizedM(:,:,1)),title('B1 Original Image'),colormap('gray')
subplot(2,2,2),plot(Wvl,spec), title('Pixel Ref Spectrum')
subplot(2,2,3), imagesc(M_mnf_img(:,:,1)),title('Component 1 MNF Image')
subplot(2,2,4),plot(compnum,MNFsig), title('MNF plot across components')

figure;
plot(noiseFractions, 'o-');
xlabel('MNF Component');
ylabel('Noise Fraction');
title('Noise Fractions of MNF Components');

%Keep components with noise fractions below a certain threshold
threshold = 0.1; % Set your threshold based on the plot
keepComponents = find(noiseFractions < threshold);


% Filtered MNF components
M_filtered = M_mnf_img(:,:,keepComponents);

% Save the MNF image-cube as a .mat file
mnfFilename2 = 'M_filtered.mat'; % Specify the filename
save(mnfFilename2, 'M_filtered'); % Save the variable to the file
disp(['M_filtered saved to ', mnfFilename2]);


% % Alternatively, if you want to keep a fixed number of components:
% numComponentsToKeep = 5; % For example
% [~, sortedIndices] = sort(noiseFractions);
% keepIndices = sortedIndices(1:numComponentsToKeep);
% M_filtered = M_mnf_img(:,:,keepIndices);

for i = 1:length(keepComponents)
    figure;
    imagesc(M_filtered(:,:,i));
    colormap('gray');
    title(['Filtered MNF Component ', num2str(i)]);
end


