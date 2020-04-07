
%segmentation for 1 image

 img=imread('004.tif');
 I = imresize(img,0.15);

Ig= imgaussfilt (I,1);



cform = makecform('srgb2lab'); %transform to L*ab space
lab_he = applycform(Ig,cform);

ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 3; % kmeans cluster segmentation
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
                                                              

pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]);  

segmented_images = cell(1,nColors);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = I;
    color(rgb_label ~= k) = 255;
    segmented_images{k} = color;
end

 imshow(segmented_images{1});
 
 
mean_cluster_value = mean(cluster_center,2);
[tmp, idx] = sort(mean_cluster_value); 


%using luminescence layer to refine darker regions that could not be
%separated with kmeans segmentation

I2=segmented_images{idx(1)};
imshow(I2)
%Ig2= imgaussfilt (I2,20);
cform = makecform('srgb2lab');
lab_he2 = applycform(I2,cform);

L = lab_he2(:,:,1);


BW=im2bw(L,0.5);
imshow (BW);
Fill=imfill(BW,'holes');
imshow (Fill);

masked = bsxfun(@times, I, cast(Fill,class(I)));
imshow(masked)
 imwrite(masked,'feito2.jpg');