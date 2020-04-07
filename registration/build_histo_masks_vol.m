%Author:Eduardo Alho
%31-07-2019
% vox_size = [0.2220 0.2220 0.4300];
%reg2D_dir='/Users/eduardoalho/Desktop/Eduardo_Alho/High_resolution/Histo_grayscale_HD/aligned/'
%(this is the directory where the .tif masks are
%names: name of the final mask in mgz format eg: 'caudate.mgz


function build_histo_masks_vol(reg2D_dir,vox_size,names)

  
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




 files2 = dir(strcat(vol_dir,'*.mgz'));
nFiles2 = length(files2);

for i=1:nFiles2
    name = files2(i).name;
    name = strcat(vol_dir,name);
    nii_name = strcat(changeExt(name,'nii'));
    

 command = sprintf('mri_convert %s %s',name,nii_name);
  system(command);

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

