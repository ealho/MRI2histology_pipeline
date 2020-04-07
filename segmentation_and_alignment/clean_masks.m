
% Author:Eduardo Alho
%Date:07/06/2017
%clean masks by finding biggest connected area component
%sigma for gaussian blur (5 is a good start)
%n= number of rois desired. If n=1, only the bigger connected volume will
%show up, n=2, 2 rois are showing up (bigger and second bigger), and so on
%use 1 by default, if there are more than one non connected rois desired,
%than select the appropriate number

function clean_masks(root_dir,sigma,n)


clean_dir= fullfile(root_dir,'cleaned/');
mkdir(clean_dir);

files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);

for f=1:nFiles
    fprintf ('Cleaning %s...\n',files(f).name);
    name = strcat(root_dir,files(f).name);
    name2=strcat(clean_dir,files(f).name);
    
    I=imread(name);
    Ig= imgaussfilt (I,sigma);
    Bw=im2bw(Ig,0.3);
    BW2 = bwareafilt(Bw,n);
    Fill=imfill(BW2,'holes');
    masked = bsxfun(@times, I, cast(Fill,class(I)));
    imwrite(masked,name2);
end
end
