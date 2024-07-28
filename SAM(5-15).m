clc
close all force

% Load and process the first file
fullname = "tree(5-15).mat";
temp = load(fullname);
fn = fieldnames(temp);
MM = temp.(fn{1});
MM = rot90(MM, 3);

% Load and process the wavelengths file
fullname = "wavelengths.mat";
temp = load(fullname);
fn = fieldnames(temp);
Wvl = temp.(fn{1});

% Load and process the hyperspectral image data
info = enviinfo("coverCrop.hdr");
endmem = multibandread('coverCrop.sli',...
   [info.Height info.Width info.Bands],...
   info.DataType, info.HeaderOffset, info.Interleave, info.ByteOrder);
endmem = transpose(endmem);
endmemnam = info.SpectraNames;

% Define the bands range and threshold
firstBand = 1;
lastBand = 100;
threshold = 0.05;

% Reduce the data to the defined bands range
endmem = endmem(firstBand:lastBand, :);
MM = MM(:, :, firstBand:lastBand);
Wvl = Wvl(firstBand:lastBand, :);

% Normalize the reflectance hyperspectral image
minVal = min(MM(:));
normalizedM = MM - minVal;
endmem = endmem - minVal;

% Reshape the normalized image
[h, w, p] = size(normalizedM);
M = reshape(normalizedM, w*h, p).';
[p, N] = size(M);

% Plot spectral signatures
figure,
plot(Wvl, endmem), legend(endmemnam)

% Choose the flower signature
roispec = endmem(:, 1);

% Calculate SAM map
selectedsamRadians = zeros(1, N);
for k = 1:N
    tmp = M(:, k); 
    selectedsamRadians(k) = acos(dot(tmp, roispec) / (norm(roispec) * norm(tmp)));
end
selectedsammap = reshape(selectedsamRadians, w, h);

% Convert to real values for display
selectedsammap_real = abs(selectedsammap);

% Display results
figure
subplot(2,2,1), image(imread("tree(5-15).png")), title('RGB image')
subplot(2,2,2), plot(Wvl, roispec), title('Selected pixel spectrum')
subplot(2,2,3), imagesc(selectedsammap_real), title('SAM map')
S = selectedsammap_real > threshold;
selectedsammap_real(S) = 1;
colormap("sky")
subplot(2,2,4), imagesc(selectedsammap_real), title('SAM map with threshold')
datacursormode on

% Count the number of zeros in the binary matrix S
numZeros = sum(S(:) == 0);
totalElements = numel(S);
percentageZeros = (numZeros / totalElements) * 100;

% Display the result
disp(['Number of zeros in S: ', num2str(numZeros)]);
disp(['Percentage of zeros in S: ', num2str(percentageZeros), '%']);
