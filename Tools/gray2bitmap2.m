%Author:Eduardo Alho
%Date:29/04/2018
%transform grayscale images in binary (reduces size of masks)
%root dir :for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')


function gray2bitmap2(root_dir)


files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);

for f=1:nFiles
    fprintf ('transforming grayscale to bitmap   %s...\n',files(f).name);
     name = strcat(root_dir,files(f).name);
     
     I =imread(name);
     BM=im2bw(I,0.1);
     BM=imfill(BM,'holes');
     imwrite(BM,name);
end
end
