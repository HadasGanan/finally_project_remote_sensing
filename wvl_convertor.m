% Specify the Excel file name
excelFileName = 'wvl.xlsx';

% Read the wavelength data from the Excel file
wavelengthTable = readtable(excelFileName);

% Assuming the data is in the first column of the Excel file
wavelength = wavelengthTable{:,1};

% Save the wavelength data to a .mat file
save('wavelengths.mat', 'wavelength');

% Verify the saved data
data = load('wavelengths.mat');
disp(data.wavelength);
