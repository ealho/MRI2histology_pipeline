
%Author:Eduardo Alho
%function renames files to 03 digit respecting the file order
%root_dir: directory where original folders with masks are
%eg: '/Users/erichfonoff/Desktop/Eduardo_Alho/Teste_masks/orig_masks/'
%name:name of the mask to be prepared
%eg: 'lapm'


function rename_better(root_dir,name)

if root_dir(end) ~= '/'
    root_dir = [root_dir '/'];
end
mask_dir= strcat(root_dir,name)
preprocess_dir = fullfile(mask_dir,strcat('/preprocessed_masks_',name))

mkdir(preprocess_dir)


dirData = dir(fullfile (mask_dir,'*.tiff'))       %# Get the selected file data
fileNames = {dirData.name} ;
num_files_to_rename = numel(fileNames);





for ii=1:num_files_to_rename
    %in my test i used cells to store my strings you may need to
    %change the bracket type for your application
    curr_file = fileNames{ii};

    %locates the period in the file name (assume there is only one)
    period_idx = findstr(curr_file ,'.')

    %takes everything to the left of the period (excluding the period)
    file_name = str2num(curr_file(1:period_idx-1))

    %zeropads the file name to 3 spaces using a 0
    new_file_name = sprintf('%03d.tif',file_name)
    
    A = fullfile(mask_dir,curr_file);
    B = fullfile(preprocess_dir,new_file_name);

    %you can uncomment this after you are sure it works as you planned
    movefile(A,B)
    

end