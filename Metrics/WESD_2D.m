
%Author:Eduardo Alho
%Date: 28/03/2017
%This script is based on test_nwsd_2d.m from Maryana Alegro
%Calculates nwsd coefficient for pairs of slices, inside directories dir1
%and dir2 (full path of the directories)
%Inputs should be binary images, if they are grayscale or rgb, please
%uncomment lines 51 and 52 and change 59 to img1b and img2b
%Mean corresponds approximately to WESD_3D



function nwsd = WESD_2D(dir1,dir2)

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

nwsd = zeros(1,nFiles1)

files1 = sortfiles(files1);
files2 = sortfiles(files2);

fprintf('Running nWSD test...\n');

%compute nWSD

errors = nwsd;
for f = 1:nFiles1
    
    fprintf('%d of %d\n', f, nFiles1);
    
    img1 = imread(strcat(dir1,files1(f).name));
    img2 = imread(strcat(dir2,files2(f).name));
    
    %transforma as imagens em binarias reais
    %img1b = im2bw(img1);
    %img2b = im2bw(img2);
    
    %img1b = img1;
    %img2b = img2;
    
    
    try
        nwsd(f) = WESD(img1, img2, 'num', 100, 'norm_type', 2, 'element_spacing', [1.0 1.0]);
        fprintf('WESD: %d \n', nwsd(f));
    catch
        fprintf('Error: %d \n', f);
        errors(f) = 1;
    end
    
end

plot(nwsd,'b+');

fprintf('\n Num. errors: %d', sum(errors));

fprintf('\n Mean: %f', mean(nwsd));

fprintf('\n Standard deviation: %f', std(nwsd));

xlswrite('WESD_2D.xls',nwsd);

end

