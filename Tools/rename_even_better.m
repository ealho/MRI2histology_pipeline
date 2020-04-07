

function rename_even_better(root_dir)



mask_dir=root_dir;

dirData = dir(fullfile (mask_dir,'*.jpg')) ; 
%dirData = dir(fullfile (mask_dir,'*.tif')) ;     %# Get the selected file data
fileNames = {dirData.name} ;
num_files_to_rename = numel(fileNames);
TF=isstrprop(fileNames,'digit');




for ii=1:num_files_to_rename
    %in my test i used cells to store my strings you may need to
    %change the bracket type for your application
    curr_file = fileNames{ii};

    %locates the period in the file name (assume there is only one)
    period_idx = findstr(curr_file ,'.');

    %takes everything to the left of the period (excluding the period)
    idx=find(TF{ii});
     ans=fileNames{ii}(idx);
   file_name=str2num(ans);

    %zeropads the file name to 3 spaces using a 0
    new_file_name = sprintf('%03d.tif',file_name);
    
   name = strcat(root_dir,new_file_name);
   
   
    A = fullfile(mask_dir,curr_file);


    %you can uncomment this after you are sure it works as you planned
    movefile (A,name);
    

end