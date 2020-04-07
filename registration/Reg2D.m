% Author:Maryana Alegro
% Used in full brain histology registration.
% Registers the histology slices to their corresponding block face slices.
% Uses mri_robust_register for initial alignment and ANTS for refinement
% ROOT_DIR : case base directory, containing the folders called 'Blockface'
% and 'Histology' inside
% Images to be registered must be in a folder in a format
% Blockface/segmented/grayscale and Histology/segmented/grayscale
% Default mode is just use MRR (linear alignment). If you want to refine
% the aligment with non-linear ANTs algorithm, please set doANTS = 1 (line
% 51). The blockface segmentation should be very accurate for this option
% to work properly.



function Reg2D(root_dir)




if root_dir(end) ~= '/'
    root_dir = [root_dir '/'];
end

bf_dir = strcat(root_dir,'Blockface/')';
histo_dir = strcat(root_dir,'Histology/');

%bf_base = strcat(root_dir,'blockface/');
histo_base = strcat(root_dir,'histology/');

%tmp_bf_dir = strcat(bf_dir,'mgz/');
%tmp_histo_dir = strcat(histo_dir,'mgz/');
tmp_bf_dir = bf_dir;
tmp_histo_dir = histo_dir;
histo_reg_dir = strcat(histo_base,'reg1/');
histo_final_reg_dir = strcat(histo_base,'regblock/');
tmp_dir = strcat(root_dir,'tmp/');

mkdir(tmp_bf_dir);
mkdir(tmp_histo_dir);
mkdir(histo_reg_dir);
mkdir(histo_final_reg_dir);
mkdir(tmp_dir);

ext = '*.tif';
%histo_ext = '*.tif';

files = dir(strcat(bf_dir,ext));
nFiles = length(files); %blockface and histo files should have the same name.;

doMGZ = 0;
doRobustReg = 1;
doANTS = 0;

for f = 1:nFiles
    
    fprintf('\nProcessing %s.\n',files(f).name);
    
    close all;
    
    name = files(f).name;
    idx = strfind(name,'.');
    nii_name = strcat(name(1:idx(1)),'tif');
    out_name = strcat(name(1:idx(1)),'nii.gz');
    
    %------------------
    % convert to MGZ
    %------------------
    if doMGZ == 1
        
        fprintf('Converting images to MGZ...\n');
        
        %set dirs
        tmp_bf_dir = strcat(bf_dir,'mgz/');
        tmp_histo_dir = strcat(histo_dir,'mgz/');
        nii_name = strcat(name(1:idx(1)),'mgz');
        
        %convert blockface
        command = sprintf('mri_convert %s %s', strcat(bf_dir,name), strcat(tmp_bf_dir,nii_name));
        [status_bf, result_bf] = system(command);
        %convert histo
        command = sprintf('mri_convert %s %s', strcat(histo_dir,name), strcat(tmp_histo_dir,nii_name));        
        [status_h, result_h] = system(command);
        
        if status_bf ~=0 || status_h ~= 0
             fprintf('Could no convert %s.\n', name);
             return;
        end       
        
    end
    
    %-------------------------    
    % run mri_robust_register
    %-------------------------
    
    %initial alignment 
    
    %logs what kind of registration method was used
    log_file = strcat(histo_reg_dir,name,'.log'); 
    logfid = fopen(log_file,'w+');
    logstatus = '00';
    
    if doRobustReg == 1  
        
        histo_img = strcat(tmp_histo_dir,nii_name); %histology
        bf_img = strcat(tmp_bf_dir,nii_name); %blockface
        result_img1 = strcat(histo_reg_dir,'mrr_',out_name);
        lta_name = strcat(histo_reg_dir,files(f).name,'.lta');

        %command = sprintf('mri_robust_register --mov %s --dst %s --lta %s --mapmov %s --iscale --satit',histo_img,bf_img,lta_name,result_img1);        
        %command = sprintf('mri_robust_register --mov %s --dst %s --cost ROBENT --radius 7 --satit --iscale --lta %s --mapmov %s  --affine --minsize 130',histo_img,bf_img,lta_name,result_img1);
        command = sprintf('mri_robust_register --mov %s --dst %s --cost ROBENT --satit --iscale --lta %s --mapmov %s --affine',histo_img,bf_img,lta_name,result_img1);
        
        fprintf('Running mri_robust_register...\n');

        [status, result] = system(command);
        if status ~= 0
            fprintf('Error running MRI_ROBUST_REGISTER in file %s.\n', files(f).name);
            disp(result);
            return;
        end
        %convert NIFT to TIFF
        command = sprintf('ConvertImagePixelType %s %s 1', result_img1, strcat(histo_reg_dir,'mrr_',nii_name));
        [status, result] = system(command);
        if status ~= 0
            fprintf('Error converting %s to %s.\n', result_img1, strcat(histo_reg_dir,'mrr_',nii_name));
            disp(result);
            return;
        end
        
        
        
        % Show result    
%         img1 = MRIread(result_img1);
%         img2 = MRIread(bf_img);
%         display_alignment(gscale(img1.vol),gscale(img2.vol));
        
    end
    
    %-------------------------
    % run ANTS
    %-------------------------
    
    % non-rigid registration refinement
    
    if doANTS == 1  
        
        histo_img = strcat(histo_reg_dir,'mrr_',out_name); %MRR registered histology
        bf_img = strcat(tmp_bf_dir,nii_name); %blockface
        result_img1 = strcat(histo_reg_dir,'ants_',out_name);
        
        idx = strfind(result_img1,'.nii.gz');       
        out_prefix = result_img1(1:idx-1);
        %lta_name = strcat(histo_reg_dir,files(f).name,'_def.nii.gz');

        %command = sprintf('/Users/LIM44/Desktop/maryana.alegro/github/registration/regbrains/run_ants.sh %s %s %s %s',histo_img,bf_img,result_img1,out_prefix);
        fprintf('Running ANTS...\n');
        
        %compute transform
        command = sprintf('antsRegistration -d 2 -r [%s,%s,1] -m meansquares[%s,%s,1,32] -t affine[0.10] -c 10000x1100x100 -s 4x2x1vox -f 3x3x1 -l 1 -m mattes[%s, %s, 1,32] -t SyN[0.15] -c 30x30x20 -s 3x3x1vox -f 4x2x2 -l 1 -o [%s]',...
            bf_img,histo_img,bf_img,histo_img,bf_img,histo_img,out_prefix);
        
        [status, result] = system(command);
        if status ~= 0
            fprintf('Error running ANTS in file %s.\n', files(f).name);
            fprintf('Could not compute ANTs transform.\n');
            disp(result);
            continue;
        end
        
        %apply transform
        command = sprintf('antsApplyTransforms -d 2 -i %s -r %s -n linear -t %s1Warp.nii.gz -t %s0GenericAffine.mat -o %s',...
            histo_img,bf_img,out_prefix,out_prefix,result_img1);
        
        [status, result] = system(command);
        if status ~= 0
            fprintf('Error running ANTS in file %s.\n', files(f).name);
            fprintf('Could not apply ANTs transform.\n');
            disp(result);
            continue;
        end
        
        %convert to TIFF
        command = sprintf('ConvertImagePixelType %s %s.tif 1',result_img1,out_prefix);
        
        [status, result] = system(command);
        if status ~= 0
            fprintf('Error running ANTS in file %s.\n', files(f).name);
            fprintf('Could not convert from Nifit to TIFF.\n');
            disp(result);
            continue;
        end  
        
        
        
    end   
    
    %--------------------------------
    % Test ANTS registration quality
    %--------------------------------
    
    if doANTS == 1
        
        final_image = strcat(histo_final_reg_dir,nii_name);
        
        result_mrr = strcat(histo_reg_dir,'mrr_',nii_name);
        result_ants = strcat(histo_reg_dir,'ants_',nii_name);
        ref_img = strcat(tmp_bf_dir,nii_name);
        
        img_mrr = imread(result_mrr);
        img_ants = imread(result_ants);
        img_ref = imread(ref_img);
     
        %compare cross correlation
        score1 = xcorr_coeff(img_ref,img_mrr);
        score2 = xcorr_coeff(img_ref,img_ants);
        
        fprintf('MRR xcorr: %d ANTS xcor: %d\n', score1, score2); 
        
        if score2 < score1 %don't use ANTS result as final image
           fprintf('Using MRR result.\n'); 
           imwrite(img_mrr,final_image,'TIFF');
           % log
           logstatus = '10'; %uses MRR but doesn't use ANTS
        else
           fprintf('Using ANTs result.\n'); 
           imwrite(img_ants,final_image,'TIFF');
           % log
           logstatus = '11'; %uses MRR and uses ANTS
        end
          
    else
        final_image = strcat(histo_final_reg_dir,nii_name);
        result_mrr = strcat(histo_reg_dir,'mrr_',nii_name);
        copyfile(result_mrr,final_image);
        
    end
    
    %write to logfile
    fprintf(logfid,logstatus);
    fclose(logfid);
    
end


end

