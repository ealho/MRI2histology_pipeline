%Author:Eduardo Alho
%date:06/09/2016
%Applies 2D transformations to binary masks segmented from original
%histology, builds a volume (Case01) from 2D slices, centralizes to the original volume and saves in nifti format ready for 3D transforms 
%%mask_dir: directory where original folders with masks are
%The masks should be preprocessed by Preprocess_masks.m and will be in a
%directory called preprocessed_masks_mask_name (eg: preprocessed_masks_cau)
%%mask_name:name of the mask to be transformed
%lta_dir: full path of where the .lta transforms are located
%eg: '/Users/erichfonoff/Desktop/Eduardo_Alho/Rereg/reg1/'
% vox_size: voxel dimensions (e.g. [0.5 0.5 0.1]) In this script voxel size
% is set to Case 01
%Case 01 [0.2220 0.2220 0.4300], Case 04 [0.2660 0.2650 0.4740]
%names: name of the final mask in mgz format eg: 'caudate.mgz'

%lta_dir for applying alignment from align slices is
%/Users/erichfonoff/Desktop/Eduardo_Alho/Enviar_Horn/Enviados/Aligned_align_slices/original/lta/

function apply_2DT(mask_dir,lta_dir,names)


reg2D_dir = fullfile (mask_dir, '/reg2D_new/');
mkdir(reg2D_dir)


%Applies LTA transforms to the binary masks



%mask_dir = '/Users/erichfonoff/Desktop/Eduardo_Alho/Teste_masks/histology_seg/';
%lta_dir = '/Users/erichfonoff/Desktop/Eduardo_Alho/Rereg/reg1/';
%reg2D_dir = '/Users/erichfonoff/Desktop/Eduardo_Alho/Teste_masks/orig_masks/copy/preprocessed_masks_copy/reg2D/';

files = dir(strcat(lta_dir,'*.lta'));
nFiles = length(files);

for f = 1:nFiles
    
    fprintf('\nProcessing %s.\n',files(f).name);

    name = files(f).name;
    
    lta_name = strcat(lta_dir,name);

    idx = strfind(name,'.'); idx = idx(end);
    
    mask_name = strcat(mask_dir,fixName(name(1:idx-1)));
    out_name = strcat(reg2D_dir,fixName(name(1:idx-1)));
    %nii_name = strcat(changeExt(out_name,'nii'))
    nii_name = strcat(out_name,'.nii');
    mask_name2=strcat(mask_name,'.tif');
    tif_name=strcat(out_name,'.tif');
    
%     img = imread(mask_name);
%     m = max(img(:));
%     if m <= 0
%         continue; % nao processa se a mascara estiver vazia, economiza tempo computacional
%     end

    %-------------------------    
    % run mri_robust_register
    %-------------------------
    
     %convert to TIFF
     %command = sprintf('ConvertImagePixelType %s %s 1',mask_name,mask_name);
     %[status, result] = system(command);
     %if status ~= 0
      %  fprintf('Could not convert from TIFF to TIFF uncompressed.\n');
       % disp(result);
       % continue;
    % end 

    command = sprintf('mri_convert --apply_transform %s %s %s', lta_name, mask_name2, nii_name);
        
    fprintf('Running mri_convert...\n');

    [status, result] = system(command);
    if status ~= 0
        fprintf('Error running MRI_CONVERT in file %s.\n', files(f).name);
        disp(result);
        continue;
    end
    
    %convert to TIFF
     command = sprintf('ConvertImagePixelType %s %s 1',nii_name,tif_name);
        
        [status, result] = system(command) ;
        if status ~= 0
            fprintf('Could not convert from Nifti to TIFF.\n');
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


%buid volume
% vox_size = [0.2220 0.2220 0.4300];
%voxel_size_HD
vox_size=[0.222 0.222 0.430];
 
 
ext = '.tif';
%reg_dir = strcat(reg_dir,'histology/regblock/');

vol_dir = strcat(reg2D_dir,'volume/');
mkdir(vol_dir)

%vol3D_dir = strcat(reg2D_dir,'3Dvolume/');
%mkdir(vol3D_dir)

files = dir(strcat(reg2D_dir,'*',ext));
%files = sortfiles(files);
nFiles = length(files);

volume = [];

fprintf('Loading files...\n');
for f=1:nFiles
    name = strcat(reg2D_dir,files(f).name);
    img = imread(name);
    volume = cat(3, volume, img);
end

fprintf('Writing MGZ...\n');
mgz.vol = volume;
mgz_name = fullfile(vol_dir,strcat('histo_volume_',names));
MRIwrite(mgz,mgz_name);

%set voxel size
if ~isempty(vox_size)
    fprintf('Setting MGZ vox2ras0...\n');
    mgz = MRIread(mgz_name);
    x = vox_size(1);
    y = vox_size(2);
    z = vox_size(3);
    M = [x 0 0 0; 0 y 0 0; 0 0 z 0; 0 0 0 1];
    mgz.vox2ras0 = mgz.vox2ras0*M;
    MRIwrite(mgz,mgz_name);
end

%Centralizes and scales the volume to Case 01

mask_file = fullfile(vol_dir,'histo_volume.mgz');
mask_file=mgz_name;
mask_file2 = (fullfile(vol_dir,strcat('2Dvol_',names)));



M1 = [1.037190929055214e-01 1.169511914253235e+00 4.802832007408142e-01 -3.742477416992188e+02;
-1.195467352867126e+00 1.035460308194160e-01 2.260998263955116e-02 5.246303100585938e+02;
-4.741829354315996e-03 -1.173828020691872e-01 1.076207041740417e+00 -1.752008361816406e+02;
0.000000000000000e+00 0.000000000000000e+00 0.000000000000000e+00 1.000000000000000e+00];

M2 = [9.884304404258728e-01 6.518174707889557e-02 2.502135634422302e-01 6.507696533203125e+01;
-5.673512816429138e-02 9.967442154884338e-01 -5.829420685768127e-02 -4.727566528320312e+01;
-7.855468243360519e-02 1.338601857423782e-02 9.905126690864563e-01 6.847873687744141e+01;
0.000000000000000e+00 0.000000000000000e+00 0.000000000000000e+00 1.000000000000000e+00];

M = M1*M2;

mgz = MRIread(mask_file);
mgz.vox2ras0 = mgz.vox2ras0*M;
MRIwrite(mgz,mask_file2);


%Converts the final 2D volume from .mgz to .nii format


 files = dir(strcat(vol_dir,'*.mgz'));
nFiles = length(files);

for f=1:nFiles
    name = files(f).name;
    name = strcat(vol_dir,name);
    nii_name = strcat(changeExt(name,'nii'));
    

 command = sprintf('mri_convert %s %s',name,nii_name);
  system(command);

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

