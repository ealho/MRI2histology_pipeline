
function dices = dice_alho (dir1,dir2)


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

fprintf('Running nWSD test...\n');


errors = dices;

for f = 1:nFiles1
    
    fprintf('%d of %d\n', f, nFiles1);
    
    img1 = imread(strcat(dir1,files1(f).name));
    img2 = imread(strcat(dir2,files2(f).name));

    
    try
        dices(f) = 2*nnz(img1&img2)/(nnz(img1) + nnz(img2));
    catch
        fprintf('Error: %d \n', f);
        errors(f) = 1;
    end
    
end

figure, plot(dices,'b+');

fprintf('\n Num. errors: %d', sum(errors));

fprintf('\n Média: %f', mean(dices));

fprintf('\n Desvio-padrão: %f', std(dices));



end
