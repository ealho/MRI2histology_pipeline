
%Author:Eduardo Alho
%20/03/2017
%This function renames 3 digit .tif images (000.tif) into plus one number (001.tif).
%it is usefull when histology images are aligned in Amira, because it
%exports images starting from 000.tif and our images start at 001.tif

function plusone(root_dir)

files = dir(strcat(root_dir,'*.tif'));      
fileNames = {files.name};  
nFiles=length(files);

TF=isstrprop(fileNames,'digit');

 for f=1:nFiles
 idx=find(TF{f});
 ans=fileNames{f}(idx);
 file_name=str2num(ans);
 file_name2=file_name+1;
 new_file_name = sprintf('%03d.jpg',file_name);
 new_file_name2 = sprintf('%03d.jpg',file_name2);
 movefile(fileNames{f},new_file_name2);
 end
 
 
 files2 = dir(strcat(root_dir,'*.jpg'));      
fileNames2 = {files2.name};  
nFiles2=length(files2);

TF2=isstrprop(fileNames2,'digit');

 for i=1:nFiles2
 idx=find(TF2{i});
 ans2=fileNames2{i}(idx);
 file_nameb=str2num(ans2);

 new_file_nameb = sprintf('%03d.tif',file_nameb);
 
 movefile(fileNames2{i},new_file_nameb);
 end
 
 
 
 end
 