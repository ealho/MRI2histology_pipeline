
%Author:Eduardo Alho
%Date: 28/03/2017
%This script is based on test_dice_3d.m from Maryana Alegro
%Calculates dice coefficient for 2 volumes (the volumes are still 2D slices, in .tif format)
%inside directories dir1 and dir2 (full path of the directories)
%Inputs should be binary images, if they are grayscale or rgb, please
%uncomment lines 52 and 53 and comment out lines 55 and 56
%It corresponds approximately to the mean of Dice_2D



function dice3d = Dice_3D(dir1,dir2)

if dir1(end) ~= '/'
    dir1 = [dir1 '/'];
end

if dir2(end) ~= '/'
    dir2 = [dir2 '/'];
end

files1 = dir(strcat(dir1,'*.tif'));
files2 = dir(strcat(dir2,'*.tif'));

nFiles1 = length(files1);
nFiles2 = length(files2);

if nFiles1 ~= nFiles2
    error('Different number of files found. Aborting!');
end

%dice3d = zeros(1,nFiles1);

files1 = sortfiles(files1);
files2 = sortfiles(files2);

fprintf('Running Dice Coefficient test...\n');

%compute DICE

vol1 = [];
vol2 = [];

fprintf('Creating 3d volumes...\n');
for f = 1:nFiles1
    
    fprintf('%d of %d\n', f, nFiles1);
    
    img1 = imread(strcat(dir1,files1(f).name));
    img2 = imread(strcat(dir2,files2(f).name));
    
    %img1b = im2bw(img1);
    %img2b = im2bw(img2);
    
    img1b = img1;
    img2b = img2;
    
    vol1 = cat(3,vol1,img1b);
    vol2 = cat(3,vol2,img2b);
    
end

fprintf('Computing errors...\n');
% try
        %nwsd = WESD(vol1, vol2, 'num', 100, 'norm_type', 3, 'element_spacing', [0.33 0.33 0.4]);
        %nwsd = WESD(vol1, vol2, 'num', 50, 'norm_type', 3, 'element_spacing', [0.33 0.33 0.4]);
        %nwsd = WESD(vol1, vol2);
dice3d = dice(vol1,vol2);
        
        %fprintf('nSWD: %d \n', nwsd(f));
% catch
%         fprintf('Error\n');
% end


xlswrite('dice3D.xls',dice3d);

end

