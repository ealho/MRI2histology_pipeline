function thresh_mri(file,outdir,T,plane)

%
% FILE: .nii or .mgz MRI volume fullpath
% OUTDIR: dir to place binary files
% T: threshold value 
%

if outdir(end) ~= '/'
    outdir = [outdir '/'];
end

fprintf('Loading MRI volume...\n');
vol = MRIread(file);
volume = vol.vol;

voltmp = [];

[rows cols N] = size(volume);

fprintf('Processing image plane...\n');
if plane == 3 %plano sagital da RM
    for s=1:N  
        %img = gscale(volume(:,:,s));
        img = volume(:,:,s);
        mask = procslice(img,T);
        voltmp = cat(3,voltmp,mask);   
    end
end

if plane == 2 %plano coronal da RM
    for s=1:cols  
        %img = gscale(volume(:,s,:));
        img = volume(:,s,:);
        img = squeeze(img);
        mask = procslice(img,T);
        mask = reshape(mask,rows,1,N);
        voltmp = cat(2,voltmp,mask);   
    end
end

if plane == 1 %plano axial da RM
    for s=1:rows  
        %img = gscale(volume(s,:,:));
        img = volume(s,:,:);
        img = squeeze(img);
        mask = procslice(img,T);
        mask = reshape(mask,1,cols,N);
        voltmp = cat(1,voltmp,mask);   
    end
end

volume = voltmp;

[rows cols N] = size(volume);

% fprintf('Thresholding masks... ');
% for r=1:rows
%     
%     fprintf('%d of %d\n', r,N);
%     
%     %img = gscale(volume(r,:,:));
%     img = volume(r,:,:);
%     
%     mask = squeeze(img);
%     mask(mask < T) = 0;
%     mask(mask >= T) = 255;
%     mask2 = imfill(mask,'hole');
%     
% %     filename = strcat(outdir,'mri',num2str(s),'.tif');
% %     imwrite(mask2,filename,'TIFF');
% 
%     volume(r,:,:) = mask2;
%     
% end


fprintf('Cleaning spurious structures... ');
CC = bwconncomp(volume);
numPixels = cellfun(@numel,CC.PixelIdxList);

idx = find(numPixels < 100);

for i=idx
    idx2 = CC.PixelIdxList{i};
    volume(idx2) = 0;
end


fprintf('Saving... ');
for s=1:N
    
    fprintf('%d of %d\n', s,N);
    
    mask = volume(:,:,s);
    
    filename = strcat(outdir,'mri_',num2str(s),'.tif');
    imwrite(mask,filename,'TIFF');
    
end


end

 
%
% limiariza mascara
%
function mask2 = procslice(img,t)
    mask = img;
    mask(mask < t) = 0;
    mask(mask >= t) = 255;
    mask2 = imfill(mask,'hole');
end



