function Covertor_to_mat()
    % Prompt the user to select a TIFF file
    [filename, foldername] = uigetfile('*.tif', 'Open TIFF File');
    if isequal(filename, 0)
        disp('User selected Cancel');
        return;
    else
        disp(['User selected ', fullfile(foldername, filename)]);
    end

    % Get the full path of the selected file
    fullname = fullfile(foldername, filename);

    % Load the TIFF file
    imageData = imread(fullname);

    % Save the loaded image data to a .mat file
    [~, name, ~] = fileparts(filename);
    matFileName = fullfile(foldername, [name, '.mat']);
    save(matFileName, 'imageData');
    disp(['Image data saved as ', matFileName]);

%     % Display the image
%     % Check if the image is grayscale or RGB
%     if ndims(imageData) == 2
%         % Grayscale image
%         imshow(imageData, []);
%     elseif ndims(imageData) == 3
%         % Check if the third dimension is 3 (RGB)
%         if size(imageData, 3) == 3
%             % RGB image
%             imshow(imageData);
%         else
%             % Multi-plane image (e.g., hyperspectral)
%             % Display all planes as a video
%             figure;
%             for k = 1:size(imageData, 3)
%                 imshow(imageData(:,:,k), []);
%                 title(['Frame ' num2str(k)]);
%                 pause(0.1); % Pause to create a video effect
%             end
%         end
%     else
%         disp('Unsupported image format');
%     end
% end