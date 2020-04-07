%Author:Eduardo Alho
%Date:22/03/2017
% This script aligns pair of slices of a volume using mri_robust_register.
% It chooses the slice on the middle of the stack and aligns them in
% pairs.The default alignment mode is 3DOF, but affine can be also used.
% Be careful with this option, it can propagate volume errors. 
%root_dir: directory where images are
%for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')



function align_slices(root_dir)
         
        
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
     
      if mod (nFiles,2)==0 
    I=nFiles/2;
else
    I=[nFiles-1]/2;
end
     
     if name == strcat(root_dir,files(I).name)
     copyfile (name, aligned_dir)
     else
     end
    end
    
  
     for f=I:nFiles
         
     idx=find(TF{f});
     ans=fileNames{f}(idx);
     file_name=str2num(ans);
     file_name2=file_name+1; 
     new_file_name = sprintf('%03d.tif',file_name);
     new_file_name2 = sprintf('%03d.tif',file_name2);
     result_name = sprintf('%03d.nii',file_name2);
     name2=strcat(aligned_dir,new_file_name2);
     lta_name = sprintf ('%03d.lta',file_name2);
     
     
     A=exist(new_file_name);
     
     if A==0;
    break
end

  fixed = strcat(aligned_dir,new_file_name);
  moving=strcat(root_dir,new_file_name2);
  result=strcat(aligned_dir,result_name);
% comand1 = sprintf ('mri_robust_register --mov %s --dst %s --cost ROBENT --satit --iscale --lta %s --mapmov %s --transonly', moving,fixed,lta_name,result);
% comand1 = sprintf ('mri_robust_register --mov %s --dst %s --cost ROBENT --satit --iscale --lta %s --mapmov %s --affine', moving,fixed,lta_name,result);

 comand1 = sprintf ('mri_robust_register --mov %s --dst %s --cost ROBENT --satit --iscale --maxit 10 --lta %s --mapmov %s ', moving,fixed,lta_name,result);

system(comand1);

command2 = sprintf('ConvertImagePixelType %s %s 1', result,name2);
        system(command2);
     end
     
     
       files2 = dir(strcat(root_dir,'*.tif'));
    nFiles2=length(files2);
    fileNames2 = {files2.name};
    TF2=isstrprop(fileNames2,'digit');
    
    for i=1:nFiles2
 
     
      if mod (nFiles2,2)==0 
    I2=nFiles2/2;
else
    I2=[nFiles2-1]/2;
end
     
     
     for i=I2:-1:1
         
      idx2=find(TF2{i});
      ans2=fileNames{i}(idx2);
      file_nameb=str2num(ans2);
      file_name3=file_nameb-1;
      new_file_nameb = sprintf('%03d.tif',file_nameb);
      new_file_name3 =sprintf('%03d.tif',file_name3);
      result_name2 = sprintf('%03d.nii',file_name3);
      name3=strcat(aligned_dir,new_file_name3);
      lta_name2 = sprintf ('%03d.lta',file_name3);
      
       B=exist(new_file_name3);
       
   if B==0;
       break
   end
     
     fixed2 = strcat(aligned_dir,new_file_nameb);
  moving2=strcat(root_dir,new_file_name3);
  result2=strcat(aligned_dir,result_name2);
% comand1 = sprintf ('mri_robust_register --mov %s --dst %s --cost ROBENT --satit --iscale --lta %s --mapmov %s --transonly', moving,fixed,lta_name,result);
% comand1 = sprintf ('mri_robust_register --mov %s --dst %s --cost ROBENT --satit --iscale --lta %s --mapmov %s --affine', moving,fixed,lta_name,result);

 comand1 = sprintf ('mri_robust_register --mov %s --dst %s --cost ROBENT --satit --iscale --maxit 10 --lta %s --mapmov %s ', moving2,fixed2,lta_name2,result2);

system(comand1);

command2 = sprintf('ConvertImagePixelType %s %s 1', result2,name3);
        system(command2);
     end
     
       
       files2 = dir(strcat(root_dir,'*.lta'));
fileNames2 = {files2.name};
nFiles2=length(files2);

 for i=1:nFiles2
 name2 = strcat(root_dir,fileNames2{i});
 movefile(name2,lta_dir);
 end
 
 files3 = dir(strcat(aligned_dir,'*.nii'));
fileNames3 = {files3.name};
nFiles3=length(files3);


 for j=1:nFiles3
 name4 = strcat(aligned_dir,fileNames3{j});
 movefile(name4,nii_dir);
 end
 
end






 
