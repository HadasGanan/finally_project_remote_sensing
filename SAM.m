clc
close all force
fullname = "tree(5-17).mat";
temp = load(fullname);
fn = fieldnames(temp);
MM = temp.(fn{1});
MM = rot90(MM, 3);
fullname = "wavelengths.mat";
temp = load(fullname);
fn = fieldnames(temp);
Wvl = temp.(fn{1});

info = enviinfo("coverCrop.hdr");
endmem = multibandread('coverCrop.sli',...
   [info.Height info.Width info.Bands],...
  info.DataType,info.HeaderOffset,info.Interleave,info.ByteOrder);
endmem = transpose(endmem);
endmemnam = info.SpectraNames;
firstBand = 1;
lastBand = 204;
threshold = 0.05;
endmem = endmem(firstBand:lastBand, :);
MM = MM(:, :, firstBand:lastBand);
Wvl = Wvl(firstBand:lastBand, :);

%normalize reflectance hyperspectral image
minVal = min(MM(:));
maxVal = max(MM(:));
normalizedM = MM - minVal;
endmem = endmem - minVal;


[h, w, p] = size(normalizedM);
M = reshape(normalizedM, w*h, p).';
[p, N] = size(M);

%plot spectral signatures
figure,
plot(Wvl,endmem),legend(endmemnam)

roispec = endmem(:, 1); %choose the flower signature
selectedsamRadians = zeros(1,N);
 for k=1:N
     tmp = M(:,k); 
     selectedsamRadians(k) = acos(dot(tmp, roispec) / (norm(roispec) * norm(tmp)));
 end
selectedsammap = reshape(selectedsamRadians,w,h);

figure
subplot(2,2,1),image(imread("tree(5-17).png")),title('RGB image')
subplot(2,2,2),plot(Wvl,roispec), title('Selected pixel spectrum')
subplot(2,2,3),imagesc(selectedsammap),title('SAM map')
S = selectedsammap > threshold;
selectedsammap(S) = 1;
colormap("sky")
subplot(2,2,4),imagesc(selectedsammap),title('SAM map with threshold')
datacursormode on


% Count the number of zeros in the binary matrix S
numZeros = sum(S(:) == 0);

% Count the number of zeros in the binary matrix S
numZeros = sum(S(:) == 0);

% Calculate the total number of elements in the matrix S
totalElements = numel(S);

% Calculate the percentage of zeros
percentageZeros = (numZeros / totalElements) * 100;

% Display the result
disp(['Number of zeros in S: ', num2str(numZeros)]);
disp(['Percentage of zeros in S: ', num2str(percentageZeros), '%']);



