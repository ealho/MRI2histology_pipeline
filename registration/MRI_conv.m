 
function MRI_conv ()

mri_dir='/Users/erichfonoff/Desktop/Eduardo_Alho/Wrapper/';

 files = dir(strcat(mri_dir,'*.mgz'));
nFiles = length(files);

for f=1:nFiles
    name = files(f).name;
    name = strcat(mri_dir,name);
    nii_name = strcat(changeExt(name,'nii'));
    

 command = sprintf('mri_convert %s %s',name,nii_name);
  system(command);
 
end


