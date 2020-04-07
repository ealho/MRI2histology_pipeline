%Author:Eduardo Alho
%date:04/09/2016
%Uses ANTs Registration for registering 3D volumes
%It can be used for Histo/MRI registration or MRI/MRI
%root_dir:full path of the directory containing the volumes ref and mov
%ref0= reference volume
%mov0=volume to be registered
%outp= name under transforms should be stored
%out=final registered volume in nifti format
%examples:


%root_dir='/Users/erichfonoff/Desktop/Eduardo_Alho/Rereg/'
%%ref0='ants_histo2mri_interp_hw_0.33.nii'
%%mov0='brainmask_case1.nii'
%outp='Freesurfermask_to_histo'


function Reg3D (root_dir,ref0,mov0,outp)

ext = '*.nii';
ref = strcat(root_dir,ref0);
mov = strcat(root_dir,mov0);
out = strcat(outp,'.nii');
warp1 = strcat(outp,'1InverseWarp.nii.gz');
warp2 = strcat(outp,'1Warp.nii.gz');
warp3 = strcat(outp,'0GenericAffine.mat');

transform_dir=strcat (root_dir,'/3D_transforms');
mkdir(transform_dir);

 files = dir(strcat(root_dir,ext));
nFiles = length(files);

for f=1:nFiles
    name = files(f).name;
    name = strcat(root_dir,name);
    
  %compute transforms
 command = sprintf('antsRegistration -d 3 -r [%s,%s,1] -m meansquares[%s,%s,1,32] -t affine[0.10] -c 20x10x0 -s 4x2x1vox -f 3x3x1 -l 1 -m mattes[%s, %s,1,32] -t SyN[0.15] -c 30x30x20 -s 3x3x1vox -f 4x2x2 -l 1 -o [%s]',ref,mov,ref,mov,ref,mov,outp);  
  [status, result] = system(command);
        if status ~= 0
            fprintf('Error running ANTS in file %s.\n', files(f).name);
            fprintf('Could not compute ANTs transform.\n');
            disp(result);
            continue;
 
end
        
        %apply transforms
        
        command = sprintf('antsApplyTransforms -d 3 -i %s -r %s -n linear -t %s1Warp.nii.gz -t %s0GenericAffine.mat -o %s',mov,ref,outp,outp,out);
        [status, result] = system(command);
        if status ~= 0
            fprintf('Error running ANTS in file %s.\n', files(f).name);
            fprintf('Could not apply ANTs transform.\n');
            disp(result);
            continue;
        end
        
        
        %moving files
        
       % movefile(out,root_dir);
        movefile(warp1,transform_dir);
        movefile(warp2,transform_dir);
        movefile(warp3,transform_dir);
end
        
end