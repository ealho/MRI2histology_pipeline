% Author:Eduardo Alho
%Date:13/03/2017
%Transforms jpg images into tif (avoid lossy compression)
%root_dir is the directory where images are: example:'/Users/erichfonoff/Desktop/Eduardo_Alho/seg/'

function jpg2tif (root_dir)


files = dir(strcat(root_dir,'*.jpg'));
nFiles=length(files);

dirData = dir(fullfile (root_dir,'*.jpg'));        %# Get the selected file data
fileNames = {dirData.name} ;
num_files_to_rename = numel(fileNames);

for ii=1:num_files_to_rename
    %in my test i used cells to store my strings you may need to
    %change the bracket type for your application
  
    curr_file = fileNames{ii};

    %locates the period in the file name (assume there is only one)
    period_idx = findstr(curr_file ,'.');

    %takes everything to the left of the period (excluding the period)
    file_name = str2num(curr_file(1:period_idx-1));

    %zeropads the file name to 3 spaces using a 0
    new_file_name = sprintf('%03d.tif',file_name);
    
    A = fullfile(root_dir,curr_file);
    B = fullfile(root_dir,new_file_name);

    %you can uncomment this after you are sure it works as you planned
    movefile(A,B)
    

end