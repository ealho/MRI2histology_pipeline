%Author: Eduardo Alho
%26/09/2016
%Uses ANTS ResampleImage to resample MRI to 0.33 x 0.33 x 0.33 resolution to fit histology
%path= full path of the folder where MRI to be up or downsampled is
%image= name of the image within the folder
%Uses linear (default) interpolation
% ResampleImage imageDimension inputImage outputImage MxNxO [size=1,spacing=0] [interpolate type]
 % Interpolation type: 
   % 0. linear (default)
   % 1. nn 
   % 2. gaussian [sigma=imageSpacing] [alpha=1.0]
   % 3. windowedSinc [type = 'c'osine, 'w'elch, 'b'lackman, 'l'anczos, 'h'amming]
   % 4. B-Spline [order=3]



function Resample_Image (path,image)


  
    name = strcat (path,image);
    new_name= fullfile(path,(strcat('upsample_0.33_',image)));
    
    
   command = sprintf('ResampleImage 3 %s %s 0.33x0.33x0.33 0',name,new_name);
   system (command)
    
end






