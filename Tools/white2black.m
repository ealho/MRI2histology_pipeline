%Author:Eduardo Alho
%Date:18/03/2017
%removes white background of grayscale images
%root dir :for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')


function white2black(root_dir)


files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);

for f=1:nFiles
    fprintf ('removing white background from grayscale image %s...\n',files(f).name);
     name = strcat(root_dir,files(f).name);
     I =imread(name);
     k = find (I>200);
     I(k)=0;
     imwrite (I,name);
end
end



