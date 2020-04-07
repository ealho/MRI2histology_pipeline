

%Author:Eduardo Alho
%date:28/04/2018
%Applies 2D transformations to binary masks segmented from original
%to work, masks have to be in grayscale, not binary (use bitmap2gray to
%transform if they are in bitmap)



function DT2_align(mask_dir,lta_dir)

reg2D_dir = fullfile (mask_dir, '/reg2D/');
mkdir(reg2D_dir)


files = dir(strcat(mask_dir,'*.tif'));
nFiles=length(files);
fileNames = {files.name};
TF=isstrprop(fileNames,'digit');





for f=1:nFiles
    
    fprintf('\nProcessing %s.\n',files(f).name);
    
    
idx=find(TF{f});
ans=fileNames{f}(idx);
file_name=str2num(ans);
    

mask = sprintf('%03d.tif',file_name);
lta = sprintf ('%03d.lta',file_name);
nii= sprintf('%03d.nii',file_name);

     mask_name = strcat(mask_dir,mask);
    lta_name = strcat(lta_dir,lta);
    nii_name = strcat(mask_dir,nii);
    reg_name = strcat(reg2D_dir,mask);
        
    
    
   % nao processa se a mascara estiver vazia, economiza tempo computacional 
   % img = imread(mask_name);
   % m = max(img(:));
    %if m <= 0
     %   continue; 
   % end
    
    %Apply transform
    command = sprintf('mri_convert --apply_transform %s %s %s', lta_name, mask_name, nii_name);
        
    fprintf('Running mri_convert...\n');

    [status, result] = system(command);
    
    
     %convert to TIFF
     command = sprintf('ConvertImagePixelType %s %s 1',nii_name,reg_name);
        
        [status, result] = system(command) ;
        if status ~= 0
            fprintf('Could not convert from Nifti to TIFF.\n');
            disp(result);
            continue;
        end
end
end
