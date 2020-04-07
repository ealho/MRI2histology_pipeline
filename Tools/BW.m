function BW()

%
% Tansforms masks in binary images
%

mask_dir = '/Users/erichfonoff/Desktop/Eduardo_Alho/Enviar_Horn/High_resolution/Masks_HD/AC/preprocessed_masks_AC/reg2D/';


files = dir(strcat(mask_dir,'*.tif'));
nFiles = length(files);

for f=1:nFiles
    name = files(f).name;
    name2 = strcat(mask_dir,name);
    
    img = imread(name2);
  
    img2 = im2bw(img,0.1);
    img3 =imfill(img2, 'holes');
    
    imwrite(img3,name2) 
end

