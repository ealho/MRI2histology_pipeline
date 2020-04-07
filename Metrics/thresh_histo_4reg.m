function thresh_histo_4reg(file,outdir,T,plane)


%
% Limiriza as imagens segmentadas manualmente e depois cria o volume de mascaras binarias que
% sera deformado
%

%
% FILE: .nii or .mgz MRI volume fullpath
% OUTDIR: dir to place binary files
% T: threshold value 
% REFMGZ: full path for reference MGZ file
% PLANE: plane em que as mascaras foram feitas (1 = axial; 2 = coronal; 3 =
% sagital)
%

if outdir(end) ~= '/'
    outdir = [outdir '/'];
end

fprintf('Loading histology images...\n');
vol = MRIread(file);
volume = vol.vol;

[rows cols N] = size(volume);

voltmp = [];


fprintf('Processing image plane...\n');
if plane == 1 %plano axial da histologia
    for s=1:N  
        %img = gscale(volume(:,:,s));
        img = volume(:,:,s);
        mask = procslice(img,T);
        voltmp = cat(3,voltmp,mask);   
    end
end


if plane == 2 %plano coronal da histologia
    for s=1:cols  
        %img = gscale(volume(:,s,:));
        img = volume(:,s,:);
        img = squeeze(img);
        mask = procslice(img,T);
        mask = reshape(mask,rows,1,N);
        voltmp = cat(2,voltmp,mask);   
    end
end

if plane == 3 %plano coronal da histologia
    for s=1:rows  
        %img = gscale(volume(s,:,:));
        img = volume(s,:,:);
        img = squeeze(img);
        mask = procslice(img,T);
        mask = reshape(mask,1,cols,N);
        voltmp = cat(1,voltmp,mask);   
    end
end


fprintf('Creating masks...\n');
[rows2 cols2 N2] = size(voltmp);
for s=1:N2
    
    img = voltmp(:,:,s);
    
    filename = strcat(outdir,'histo_',num2str(s),'.tif');
    imwrite(img,filename,'TIFF');
    %MRIwrite(mask2,filename);
    
end

fprintf('Saving binary volume...\n');
volname = strcat(outdir,'histo_masks.mgz');
vol.vol = voltmp;
MRIwrite(vol,volname);


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


