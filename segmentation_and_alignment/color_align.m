
%Author:Eduardo Alho
% date:12/04/2018
% Applies 2D registration transforms to create color image slices.
%In the root_dir you must have 2 folders: 1 named /lta with the .lta files
%obtained from the trasforms from the alignment of the grayscaled images
%(align_slices.m) and 1 folder named /segmented with the color images
%segmented by the histo_segmentation


function color_align(root_dir)


histo_seg_dir = strcat(root_dir,'segmented/');
lta_dir = strcat(root_dir,'lta/');
final_dir = strcat(root_dir,'final/');
aligned_dir = strcat(final_dir,'aligned/');
tmp_color_dir = strcat(final_dir,'tmp/');


mkdir(final_dir);
mkdir(aligned_dir);
mkdir(tmp_color_dir);


files = dir(strcat(histo_seg_dir,'*.tif'));
nFiles=length(files);
fileNames = {files.name};
TF=isstrprop(fileNames,'digit');
    
    
    
    
    for f = 1:nFiles 
    
     histo_name = strcat(histo_seg_dir,fileNames{f});
     
     idx=find(TF{f});
     ans=fileNames{f}(idx);
     file_name=str2num(ans);
     
     lta_name=sprintf('%03d.lta',file_name);
     R_name=sprintf('R_%03d.tif', file_name);
     G_name=sprintf('G_%03d.tif', file_name);
     B_name=sprintf('B_%03d.tif', file_name);
     R_name_t=sprintf('R_t_%03d.mgz',file_name);
     G_name_t=sprintf('G_t_%03d.mgz',file_name);
     B_name_t=sprintf('B_t_%03d.mgz',file_name);
     color_name=sprintf('%03d.tif',file_name);
     
     lta_file=strcat(lta_dir,lta_name);
     R_file=strcat(tmp_color_dir,R_name);
     G_file=strcat(tmp_color_dir,G_name);
     B_file=strcat(tmp_color_dir,B_name);
     R_file_t =strcat(tmp_color_dir,R_name_t);
     G_file_t =strcat(tmp_color_dir,G_name_t);
     B_file_t =strcat(tmp_color_dir,B_name_t);
     color_file = strcat(aligned_dir, color_name);
     
     
     
     I=imread(histo_name);

R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

    imwrite(R,R_file,'TIFF')
    imwrite(G,G_file,'TIFF')
    imwrite(B,B_file,'TIFF')
    
    command1 = sprintf('mri_convert -at %s -rt cubic %s %s',lta_file, R_file, R_file_t);
    command2 = sprintf('mri_convert -at %s -rt cubic %s %s',lta_file, G_file, G_file_t);
    command3 = sprintf('mri_convert -at %s -rt cubic %s %s',lta_file, B_file, B_file_t);
    system(command1);
    system(command2);
    system(command3);
    
    
    R2 = MRIread(R_file_t);
    G2 = MRIread(G_file_t);
    B2 = MRIread(B_file_t);
    color_img = cat(3,uint8(R2.vol),uint8(G2.vol),uint8(B2.vol));
    imwrite(color_img,color_file,'TIFF');  
     
    end
    end













    

    
    
        