%Author:Eduardo Alho
%Date:20/04/2018
%removes black background of grayscale images
%root dir :for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')


function black2white(root_dir)


files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);

for f=1:nFiles
    fprintf ('removing black background from grayscale image %s...\n',files(f).name);
     name = strcat(root_dir,files(f).name);
     I =imread(name);
     k = find (I==0);
     I(k)=255;
     imwrite (I,name);
end
end



