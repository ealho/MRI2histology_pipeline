%Author:Eduardo Alho
%date:01/10/2016
%Applies 3D transforms of to 3D registered masks or other 3D volumetric
%data stored in a folder named 3Dvolume
%root_dir1 is the folder where the 3D transforms and the reference volume are stored
%eg:'/Users/erichfonoff/Desktop/Eduardo_Alho/Wrapper/'
%ref0 is the name of the reference volume (eg : 'MRI.nii')
%root_dir2 is where the volume to be warped is stored
%eg:'/Users/erichfonoff/Desktop/Eduardo_Alho/Teste_masks/orig_masks/cau/preprocessed_masks_cau/reg2D/'
%mov0 is the name of the moving volume (eg: '3Dvol_cau.nii')
%outp is the name of the original warped volume eg: 'Atlas2MNI'
%out is the output name of the registered mask eg:'3Dvol_cau.nii'

function apply_3DT_general (root_dir1,ref0,root_dir2,mov0,outp,out)

ext= '*.nii';
ref= strcat(root_dir1,ref0);
mov= strcat(root_dir2,mov0);
warp1 = (fullfile (root_dir1,strcat('/3D_transforms/', outp,'1InverseWarp.nii.gz')));
warp2 = (fullfile (root_dir1,strcat('/3D_transforms/',outp,'1Warp.nii.gz')));
warp3 = (fullfile (root_dir1,strcat('/3D_transforms/',outp,'0GenericAffine.mat')));



 files = dir(strcat(root_dir1,ext));
nFiles = length(files);

for f=1:nFiles
    name = files(f).name;
    name = strcat(root_dir1,name);

 command = sprintf('antsApplyTransforms -d 3 -i %s -r %s -n linear -t %s -t %s -o %s',mov,ref,warp2,warp3,out);
        [status, result] = system(command);
        if status ~= 0
            fprintf('Error running ANTS in file %s.\n', files(f).name);
            fprintf('Could not apply ANTs transform.\n');
            disp(result);
            continue;
        end

end


        
        
        %moving files
        
       movefile(out,root_dir2);
        
        
end