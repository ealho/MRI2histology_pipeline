%Author:Eduardo Alho
%Date:18/03/2017
%removes white background of grayscale images
%root dir :for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')



function white2black_rgb(root_dir)



files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);

for f=1:nFiles
    fprintf ('removing white background from rgb image %s...\n',files(f).name);
     name = strcat(root_dir,files(f).name);
     
     
     
     
     I =imread(name);
     redChannel = I(:,:,1);
greenChannel = I(:,:,2);
blueChannel = I(:,:,3);


thresholdValue = 200; % Whatever you define white as.
whitePixels = redChannel > thresholdValue & greenChannel > thresholdValue & blueChannel > thresholdValue;
redChannel(whitePixels) = 0;
greenChannel(whitePixels) = 0;
blueChannel(whitePixels) = 0;
I2 = cat(3, redChannel, greenChannel, blueChannel);
     imwrite (I2,name);
end
end





