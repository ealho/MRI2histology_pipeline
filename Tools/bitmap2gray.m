%Author:Eduardo Alho
%Date:10/03/2017
%transform binary images in grayscale
%root dir :for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')


function bitmap2gray(root_dir)


files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);

for f=1:nFiles
    fprintf ('transforming bitmap to Grayscale %s...\n',files(f).name);
     name = strcat(root_dir,files(f).name);
     name2=strcat(root_dir,files(f).name);
     I =imread(name);
     Gr=uint8(I);
     imwrite(Gr,name);
end
end


      

