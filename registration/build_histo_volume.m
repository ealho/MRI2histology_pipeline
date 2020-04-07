%Author:Eduardo Alho
%date:06/09/2016
%Creates 3D histology volume from the registered histo plates
%reg2D_dir: directory where the target images are located
%vox_size: voxel dimensions (e.g. [0.5 0.5 0.1])



%example:
%reg2D_dir='/Users/eduardoalho/Desktop/Eduardo_Alho/High_resolution/Histo_grayscale_HD/aligned/'
%vox_size=[0.250 0.250 0.430]   : This is the voxel size for high
%resolution histology of Case 01




function build_histo_volume(reg2D_dir,vox_size)



if reg2D_dir(end) ~= '/'
    reg2D_dir = [reg2D_dir '/'];
end

ext = '.tif';
%reg_dir = strcat(reg_dir,'histology/regblock/');
vol_dir = strcat(reg2D_dir,'volume/');
mkdir(vol_dir);

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
mgz_name = strcat(vol_dir,'histo_volume.mgz');
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




 files2 = dir(strcat(vol_dir,'*.mgz'));
nFiles2 = length(files2);

for i=1:nFiles2
    name = files2(i).name;
    name = strcat(vol_dir,name);
    nii_name = strcat(changeExt(name,'nii'));
    

 command = sprintf('mri_convert %s %s',name,nii_name);
  system(command);

end
end
