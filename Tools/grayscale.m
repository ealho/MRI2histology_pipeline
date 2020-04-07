
%Author:Eduardo Alho
%Date:10/03/2017
%transform images in grayscale
%root dir :for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')


function grayscale(root_dir)

seg_dir= fullfile(root_dir,'grayscale/');
mkdir(seg_dir);

files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);

for f=1:nFiles
    fprintf ('transforming RGB to Grayscale %s...\n',files(f).name);
     name = strcat(root_dir,files(f).name);
     name2=strcat(seg_dir,files(f).name);
     I =imread(name);
     Gr=rgb2gray(I);
     imwrite(Gr,name2);
end
end


      
     
     
   