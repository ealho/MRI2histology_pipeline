
%Author:Eduardo Alho
%Date:20/04/2018
%Uses imhistmatch to compensate intensity in color images using an image
%reference (reference)
%root dir :for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')
%the reference used in case 01 is the slice '041.tif'

%root_dir='/Users/erichfonoff/Desktop/Eduardo_Alho/Enviar_Horn/High_resolution/Histo_color_HD/final/aligned/';
%reference='/Users/erichfonoff/Desktop/Eduardo_Alho/Enviar_Horn/High_resolution/Histo_color_HD/final/aligned/041.tif';



function  color_intensity(root_dir)
    
  
%comp_dir = strcat(root_dir,'comp/');
%mkdir(comp_dir);


files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);
fileNames = {files.name};


 if mod (nFiles,2)==0 
    I=nFiles/2;
else
    I=[nFiles-1]/2;
end

for f=1:nFiles
     name = strcat(root_dir,fileNames{f})
     name2 = strcat(root_dir,fileNames{I})
     
      
        if name==name2
        continue
        end    
  img=imread(name);
  ref=imread(name2);
        fprintf('Optimizing %s ...\n',fileNames{f});
        
R_ref=ref(:,:,1);
G_ref=ref(:,:,2);
B_ref=ref(:,:,3);



R_img=img(:,:,1);
G_img=img(:,:,2);
B_img=img(:,:,3);


    B1=imhistmatch(R_img,R_ref);
    B2=imhistmatch(G_img,G_ref);
    B3=imhistmatch(B_img,B_ref);
    
    
    I2 = cat(3, B1, B2, B3);
     imwrite (I2,name2);
end
end