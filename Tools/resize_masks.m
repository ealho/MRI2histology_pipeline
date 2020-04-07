function resize_masks(mask_dir)

%
% Downsample histology
   
files = dir(strcat(mask_dir,'*.png'));
nFiles = length(files);

for f=1:nFiles
     fprintf('\nProcessing %s.\n',files(f).name);
    name = files(f).name;
    name = strcat(mask_dir,name);
    
    img = imread(name);
    img = imresize(img,[562 843]);
    
    imwrite(img,name) 
end

