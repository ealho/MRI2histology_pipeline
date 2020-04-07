%Author:Eduardo Alho
%Date:25/03/2017
%This function applies a  transformation matrix (or a sequence of matrices) to the histological volume in order to
%align it roughly to the MRI(this matrices can be generated using freeview (tools, transform volume, save reg). 
%The transforms will be stored as .lta files, open them in the notepad and
%copy the first matrix as M1, M2,... Mx
%save this file with the name of the case in which you are centralizing for
%future use in masks
% mask_file: file name (full path) of the 2D registered volume
% mask_file2: output name

function center_volume(mask_file,mask_file2)


%Please copy the 16 element matrix from the .lta file here, naming it as
%M1, M2, Mx

%Matrix example:

%M1 = [1 0 0 x;0 1 0 y;0 0 1 z;0 0 0 1]

%M2=[1 0 0 -477.5825;0 1 0 380.7322;0 0 1 284.5703;0 0 0 1] this matrix
%translates 100 voxels in the x (to the right), y (left) and z(superior) direction


%M=M1*M2*M3*Mx



M = M1*M2;

mgz = MRIread(mask_file);
mgz.vox2ras0 = mgz.vox2ras0*M;
MRIwrite(mgz,mask_file2);





