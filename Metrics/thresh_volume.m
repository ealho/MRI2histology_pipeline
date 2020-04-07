function thresh_volume(file,outdir,T)

%
% FILE: .nii or .mgz MRI volume fullpath
% OUTDIR: dir to place binary files
% T: threshold value 
%

if outdir(end) ~= '/'
    outdir = [outdir '/'];
end

fprintf('Loading image volume...\n');
vol = MRIread(file);
volume = vol.vol;

[rows cols N] = size(volume);


fprintf('Creating masks... ');
for s=1:N
    
    fprintf('%d of %d\n', s,N);
    
    img_mri = gscale(volume(:,:,s));
    img = uint8(volume(:,:,s));
    
    mask = img;
    mask(mask < T) = 0;
    mask(mask >= T) = 255;
    mask2 = imfill(mask,'hole');
    
    filename = strcat(outdir,num2str(s),'.tif');
    filename2 = strcat(outdir,'gry',num2str(s),'.tif');
    imwrite(mask2,filename,'TIFF');
    imwrite(img_mri,filename2,'TIFF');
    
end






