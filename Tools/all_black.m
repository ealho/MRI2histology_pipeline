%Author:Eduardo Alho
%Date:28/03/2017
%removes white background of grayscale images
%root dir :for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')


function all_black(root_dir)


files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);




for f=1:nFiles
    fprintf ('transforming to black mask %s...\n',files(f).name);
     name = strcat(root_dir,files(f).name);
     I =imread(name);
     B =im2bw(I,1);
     imwrite (B,name);
end
end
