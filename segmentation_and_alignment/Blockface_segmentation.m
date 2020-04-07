% Author:Eduardo Alho
%Date:10/03/2017
%Uses k-means clustering for blockface  segmentation
%root_dir: directory where images are
%sigma= standard deviation of gaussian distribution for gaussian blur
%filter, for blockface segmentation 5 is a good start (more blur with
%higher numbers)
%clusters: number of color clusters the image should be divided
%for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/',5,2)
%resize: set 1 for image downsampling in 0.15 or [] to mantain original
%size





function Blockface_segmentation (root_dir,sigma,clusters,resize)


seg_dir= fullfile(root_dir,'segmented/');
mkdir(seg_dir);

files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);

for f=1:nFiles
    fprintf ('Segmenting %s...\n',files(f).name);
    name = strcat(root_dir,files(f).name);
    name2=strcat(seg_dir,files(f).name);
    
    if resize == 1;
    img=imread(name);
    I = imresize(img,0.15);
    else
        I=imread(name);
    end
    
    %gaussian filter before segmenting
    Ig= imgaussfilt (I,sigma);
    
    %transform image to Lab space
    cform=makecform('srgb2lab');
    lab_he=applycform(Ig,cform);
    
    ab = double(lab_he(:,:,2:3));
    nrows = size(ab,1);
    ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);
    nColors=clusters;
    
    
% use k-means clustering to select colors and repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);


    segmented_images = cell(1,nColors);
    rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = I;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

    %organizes cluster index in order. Yellow has the highest value in black
%background


    mean_cluster_value = mean(cluster_center,2);
   [tmp, idx] = sort(mean_cluster_value) ;
  
   I2=segmented_images{idx(nColors)};
    %Transforms the cluster into a white mask. The threshold 0.2 used here can be changed in different cases for better result 
    BW=im2bw(I2,0.2);
   Fill=imfill(BW,'holes');
   final = bsxfun(@times, I, cast(Fill,class(I)));
   
   
   fprintf ('Saving %s...\n',files(f).name);
   imwrite(final,name2);
   
end

end



