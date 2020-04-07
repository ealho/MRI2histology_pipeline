
%Author:Eduardo Alho
%Date:13/04/2018
% This script aligns pair of slices of a volume using mri_robust_register.
% It chooses the final slice of the stack to register with the previous .
%The default alignment mode is 3DOF, but affine can be also used.
% Be careful with this option, it can propagate volume errors. 
%root_dir: directory where images are
%for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')




function align_slices2(root_dir)

aligned_dir=fullfile(root_dir,'aligned/');
        nii_dir=fullfile(root_dir,'nifti/');
        lta_dir=fullfile(root_dir,'lta/');
        mkdir(aligned_dir);
        mkdir(lta_dir);
        mkdir(nii_dir);



files = dir(strcat(root_dir,'*.tif'));
    nFiles=length(files);
    fileNames = {files.name};
    TF=isstrprop(fileNames,'digit');
    
    for f=1:nFiles
     name = strcat(root_dir,fileNames{f});
      if name == strcat(root_dir,files(nFiles).name)
     copyfile (name, aligned_dir)
     else
      end
    end
        
   
    
    
    
    for f=nFiles:-1:1
        
       
         
        file_name=fileNames{f};
        
        if file_name==fileNames{1};
            break
        end
        
        
        file_name2=fileNames{[f-1]};
        
       
        
        
        
        idx=find(TF{f});
         ans=fileNames{[f-1]}(idx);
         pure=str2num(ans);
        
        result_nii = sprintf('%03d.nii',pure);
        fixed=strcat(aligned_dir,file_name);
        moving=strcat(root_dir,file_name2);
        result_tif=strcat(aligned_dir,file_name2);
        lta_name = strcat(lta_dir,(sprintf ('%03d.lta',pure)));
        
        result2=strcat(aligned_dir,result_nii);
        name3=strcat(aligned_dir,file_name2);
        
        
     
        
       comand1 = sprintf ('mri_robust_register --mov %s --dst %s --cost ROBENT --satit --iscale --maxit 10 --lta %s --mapmov %s ', moving,fixed,lta_name,result2)

system(comand1);

command2 = sprintf('ConvertImagePixelType %s %s 1', result2,name3)

        system(command2);
        
        
        files3 = dir(strcat(aligned_dir,'*.nii'));
fileNames3 = {files3.name};
nFiles3=length(files3);


 for j=1:nFiles3
 name4 = strcat(aligned_dir,fileNames3{j});
 movefile(name4,nii_dir);
 end
        
     
    end
    end