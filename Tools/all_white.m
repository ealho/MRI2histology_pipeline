%Author:Eduardo Alho
%Date:28/03/2017
%removes black background of grayscale images
%root dir :for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')


function all_white(root_dir)


files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);




for f=1:nFiles
    fprintf ('transforming to white mask %s...\n',files(f).name);
     name = strcat(root_dir,files(f).name);
     I =imread(name);
     B =im2bw(I,1);
     J = logical(1 - I);
     imwrite (J,name);
end
end


