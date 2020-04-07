function thresh_histo3D(file,outdir)


%
% Limiriza as imagens registradas com a RM e cria mascaras binarias para
% calculo do erro.
%

%
% FILE: .nii or .mgz registered histology volume fullpath
% OUTDIR: dir to place binary files
% 
%

if outdir(end) ~= '/'
    outdir = [outdir '/'];
end

fprintf('Loading histology registered masks...\n');
vol = MRIread(file);
volume = vol.vol;

[rows cols N] = size(volume);


fprintf('Thresholding masks...\n');
for s=1:N
    
    fprintf('%d of %d\n', s,N);
    
    %img = gscale(volume(:,:,s));
    img = volume(:,:,s);
    
    level = graythresh(img);
    img2 = im2bw(img,level);
    
    volume(:,:,s) = img2;
    
    %se = strel('disk',6);
    %mask = imclose(img2,se);
    
    %mask = img2;
    
%     mask = img;
%     mask(mask < T) = 0;
%     mask(mask >= T) = 255;
%     mask2 = imfill(mask,'hole');
%     
%     voltmp = cat(3,voltmp,mask2);
    
    %filename = strcat(outdir,'histo_',num2str(s),'.tif');
    %imwrite(mask,filename,'TIFF');
    %MRIwrite(mask2,filename);
    
end

fprintf('Cleaning spurious structures...\n');
CC = bwconncomp(volume);
numPixels = cellfun(@numel,CC.PixelIdxList);

idx = find(numPixels < 100);

for i=idx
    idx2 = CC.PixelIdxList{i};
    volume(idx2) = 0;
end

fprintf('Saving masks...\n');
for s=1:N
    mask = volume(:,:,s);
    
    filename = strcat(outdir,'histo_',num2str(s),'.tif');
    imwrite(mask,filename,'TIFF');
end

% fprintf('Saving binary volume...\n');
% volname = strcat(outdir,'histo_masks.nii');
% vol.vol = volume;
% MRIwrite(vol,volname);





