function [ normalizedM ] = specNormalize( M )
% Normalized data to be in range [0, 1]
% Inputs
%   M - Input data
% Outputs
%   normalizedM - Normalized data

minVal = min(M(:));
maxVal = max(M(:));

normalizedM = M - minVal;
if (maxVal == minVal)
    normalizeData = zeros(size(M));
else
    normalizedM = normalizedM ./ (maxVal-minVal);
end
