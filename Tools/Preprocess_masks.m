%Author:Eduardo Alho
%date:05/09/2016
%Prepares masks originated from segmentation in photoshop original
%histology to enter the Apply_transforms2masks.m script
%root_dir: directory where original folders with masks are
%eg: '/Users/erichfonoff/Desktop/Eduardo_Alho/Teste_masks/orig_masks/lapm'
%name:name of the mask to be prepared
%eg: 'lapm'


function Preprocess_masks(root_dir,name)



%Rename to 003 digit format

%this can be found also as a separated function: rename_better.m



if root_dir(end) ~= '/'
    root_dir = [root_dir '/'];
end
mask_dir= strcat(root_dir,name);
preprocess_dir = fullfile(mask_dir,strcat('/preprocessed_masks_',name));

mkdir(preprocess_dir)


dirData = dir(fullfile (mask_dir,'*.tif'));        %# Get the selected file data
fileNames = {dirData.name} ;
num_files_to_rename = numel(fileNames);



for ii=1:num_files_to_rename
   
     curr_file = fileNames{ii};

    %locates the period in the file name (assume there is only one)
    period_idx = findstr(curr_file ,'.');

    %takes everything to the left of the period (excluding the period)
    file_name = str2num(curr_file(1:period_idx-1));

    %zeropads the file name to 3 spaces using a 0
    new_file_name = sprintf('%03d.tif',file_name);
    
    A = fullfile(mask_dir,curr_file);
    B = fullfile(preprocess_dir,new_file_name);

    %you can uncomment this after you are sure it works as you planned
    movefile(A,B)
    

end



% Fills with white the hollow masks

files = dir(fullfile(preprocess_dir,'*.tif'));
nFiles = length(files);

for f=1:nFiles
  img_name = fullfile(preprocess_dir,'/',files(f).name);
   img = im2bw(imread(img_name)) ;
   img2 = imfill(img,'holes');
  
   %img2=img;
    
    %Downsample
    
   % img3 = imresize(img2,[563 843]);
    %img4= im2uint8(img3);
    

 %baseFileName=sprintf('%03d.tif',f)
 %fullFileName=fullfile(preprocess_dir,baseFileName) 
 
 imwrite(img2,img_name)
end

end







