
%Author:Eduardo Alho
%Date: 28/03/2017
%This script is based on test_dice-2d.m from Maryana Alegro
%Calculates dice coefficient for pairs of slices, inside directories dir1
%and dir2 (full path of the directories)
%Inputs should be binary images, if they are grayscale or rgb, please
%uncomment lines 50 and 51 and comment out lines 53 and 54
%The mean expressed in the workspace cooresponds aproximately to the
%dice_3D


function dices = Dice_2D(dir1,dir2)


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
    error('Different number of files found. Aborting!\n');
end

dices = zeros(1,nFiles1);

files1 = sortfiles(files1);
files2 = sortfiles(files2);

fprintf('Running Dice Coefficient...\n');

%compute nWSD

errors = dices;
for f = 1:nFiles1
    
    fprintf('%d of %d\n', f, nFiles1);
    
    img1 = imread(strcat(dir1,files1(f).name));
    img2 = imread(strcat(dir2,files2(f).name));
    
%     img1b = im2bw(img1);
  %   img2b = im2bw(img2);

    img1b = img1;
    img2b = img2;
       
    try
        dices(f) = dice(img1b,img2b);
    catch
        fprintf('Error: %d \n', f);
        errors(f) = 1;
    end
    
end

figure, plot(dices,'b+');

fprintf('\n Num. errors: %d', sum(errors));

fprintf('\n Mean: %f', mean(dices));

fprintf('\n Standard deviation: %f', std(dices));

xlswrite('dice2D.xls',dices);


end

