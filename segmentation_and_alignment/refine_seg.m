% Author:Eduardo Alho
%Date:10/03/2017
%Refines segmentation based on luminescence Layer of the image
%the images that need to be refined have to be put on a new folder
%(root_dir) eg :
%'/Users/erichfonoff/Desktop/Eduardo_Alho/seg/segmentation_test/segmented/'
%thresh = threshold for segmentation. from 0 to 1 : eg 0.2 or 0.5
%sigma for gaussian blur (5 is a good start)


function refine_seg (root_dir,thresh,sigma)

seg_dir= fullfile(root_dir,'refined/');
mkdir(seg_dir);

files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);

for f=1:nFiles
    fprintf ('Refining %s...\n',files(f).name);
    name = strcat(root_dir,files(f).name);
    name2=strcat(seg_dir,files(f).name);
    
    I=imread(name);
    Ig= imgaussfilt (I,sigma);
    
   cform = makecform('srgb2lab');
   lab_he2 = applycform(Ig,cform);
   L = lab_he2(:,:,1);
   BW=im2bw(L,thresh);
   Fill=imfill(BW,'holes');
   final = bsxfun(@times, I, cast(Fill,class(I)));
   
   
   fprintf ('Saving %s...\n',files(f).name);
   imwrite(final,name2);
end






I=imread('081.tif');
 cform = makecform('srgb2lab');
   lab_he2 = applycform(I,cform);
   L = lab_he2(:,:,1);
   BW=im2bw(L,0.4);
   Fill=imfill(BW,'holes');
   final = bsxfun(@times, I, cast(Fill,class(I)));