close all force


[MM, normalized, minVal] = loadAndNormalize("tree(4-11).mat");
fullname = "עותק של wavelengths.mat";
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
lastBand = 100;
threshold = 0.10;
endmem = endmem(firstBand:lastBand, :);
MM = MM(:, :, firstBand:lastBand);
Wvl = Wvl(firstBand:lastBand, :);

%normalize reflectance hyperspectral image

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
subplot(2,2,1),image(imread("1_2814.png")),title('RGB image')
subplot(2,2,2),plot(Wvl,roispec), title('Selected pixel spectrum')
subplot(2,2,3),imagesc(selectedsammap),title('SAM map')
S = selectedsammap > threshold;
selectedsammap(S) = 1;
colormap("sky")
subplot(2,2,4),imagesc(selectedsammap),title('SAM map with threshold')
datacursormode on