
%Author:Eduardo Alho
%Date:15/03/2017
%
%root_dir: directory where images are
%for example:
% ('/Users/erichfonoff/Desktop/Eduardo_Alho/seg/')



function jpg2tif2(root_dir)


files = dir(strcat(root_dir,'*.tif'));      
fileNames = {files.name}  ;
nFiles=length(files);

TF=isstrprop(fileNames,'digit');

 for f=1:nFiles
 idx=find(TF{f});
 ans=fileNames{f}(idx);
 file_name=str2num(ans);
 new_file_name = sprintf('%03d.png',file_name);
 movefile(fileNames{f},new_file_name);
 end
end
 
 
 
 

 