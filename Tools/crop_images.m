% Author:Eduardo Alho
%Date:13/03/2017
%crops the images selecting an image on the middle of the stack (bigger
%image) as reference for cropping
%to crop the images you have to draw a retangle on the reference image, than right click on the
%retangle and select "crop image"
%root_dir is the directory where images are: example:'/Users/erichfonoff/Desktop/Eduardo_Alho/seg/'
%it works for jpg images or tif images, just add ext ('*.jpg'or '*.tif')

function crop_images (root_dir,ext)

files = dir(strcat(root_dir,ext));
nFiles=length(files);
crop_dir= fullfile(root_dir,'/cropped/');
mkdir(crop_dir);

%detecta se o número de fatias é par ou ímpar e escolhe a imagem do meio da série como referência
if mod (nFiles,2)==0 
    A=nFiles/2;
else
    A=[nFiles-1]/2;
end


%lê imagem de referencia para segmenta'r janela

imagem=imread(strcat(root_dir,files(A,1).name));
%define janela
[I2 rect]=imcrop(imagem);


for f=1:nFiles %executa crop em toda a lista
    fprintf ('Cropping %s...\n',files(f).name);
    name1 = strcat(root_dir,files(f).name);
    name2=strcat(crop_dir,files(f).name);

imagem=imread(name1);
I3=imcrop(imagem,rect);
imwrite(I3,name2);
end
end