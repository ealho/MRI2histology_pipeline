function D = dice(img1, img2)

%
% Computer DICE coeficient
%

inter = (img1 & img2);

common=sum(inter(:)); 
cm=sum(img1(:)); % the number of voxels in m
co=sum(img2(:)); % the number of voxels in o

D = (2*common)/(cm+co);