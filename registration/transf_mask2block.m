function transf_mask2block()

%
% Applies LTA transform to the binary masks
%

mask_dir = '/Users/erichfonoff/Desktop/Eduardo_Alho/Atlas2/Orig_masks/AC/preprocessed_masks_AC/';
lta_dir = '/Users/erichfonoff/Desktop/Eduardo_Alho/Rereg/reg1/';
reg2D_dir = '/Users/erichfonoff/Desktop/Eduardo_Alho/Atlas2/Orig_masks/AC/Reg2D/';

files = dir(strcat(lta_dir,'*.lta'));
nFiles = length(files);

for f = 1:nFiles
    
    fprintf('\nProcessing %s.\n',files(f).name);

    name = files(f).name;
    
    lta_name = strcat(lta_dir,name);

    idx = strfind(name,'.'); idx = idx(end);
    
    mask_name = strcat(mask_dir,fixName(name(1:idx-1)));
    out_name = strcat(reg2D_dir,fixName(name(1:idx-1)));
    nii_name = strcat(changeExt(out_name,'nii'));
    
%     img = imread(mask_name);
%     m = max(img(:));
%     if m <= 0
%         continue; % nao processa se a mascara estiver vazia, economiza tempo computacional
%     end

    %-------------------------    
    % run mri_robust_register
    %-------------------------
    
     %convert to TIFF
     command = sprintf('ConvertImagePixelType %s %s 1',mask_name,mask_name);
     [status, result] = system(command);
     if status ~= 0
        fprintf('Could not convert from TIFF to TIFF uncompressed.\n');
        disp(result);
        continue;
     end 

    command = sprintf('mri_convert --apply_transform %s %s %s', lta_name, mask_name, nii_name);
        
    fprintf('Running mri_convert...\n');

    [status, result] = system(command);
    if status ~= 0
        fprintf('Error running MRI_CONVERT in file %s.\n', files(f).name);
        disp(result);
        continue;
    end
    
    %convert to TIFF
     command = sprintf('ConvertImagePixelType %s %s 1',nii_name,out_name);
        
        [status, result] = system(command); 
        if status ~= 0
            fprintf('Could not convert from Nifit to TIFF.\n');
            disp(result);
            continue;
        end
    
%     %convert NIFT to TIFF
%     command = sprintf('ConvertImagePixelType %s %s 1', result_img1, strcat(histo_reg_dir,'mrr_',nii_name));
%     [status, result] = system(command);
%     if status ~= 0
%         fprintf('Error converting %s to %s.\n', result_img1, strcat(histo_reg_dir,'mrr_',nii_name));
%         disp(result);
%         return;
%     end
        
    
end   

end


function n2 = fixName(n)
    l = length(n);
    if l == 1
        n2 = ['00' n];
    elseif l == 2
        n2 = ['0' n];
    else
        n2 = n;
    end
end
  
