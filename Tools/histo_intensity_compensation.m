

%Author: Eduardo Alho
%Date:24/03/2017
%Part of this file is copied and modified from the script (Maryana Alegro) intensity_compensation.m
% Date:24/03/2017
% Corrects intensity differences between pairs of slices, using the method
% in:
%
% Intensity Compensation within Series of Images. 
% Medical Image Computing and Computer-Assisted Intervention - MICCAI 2003
% Lecture Notes in Computer Science Volume 2879, 2003, pp 41-49 
% Grégoire Malandain, Eric Bardinet 
%
% IMG: Image to be corrected (must be uint8 1 to 256)
%      The image must have all background pixels set to ZERO.
% REF_IMG: Reference image (must be uint8 1 to 256)
%          The image must have all background pixels set to ZERO.





function histo_intensity_compensation(root_dir)
         
files = dir(strcat(root_dir,'*.tif'));
nFiles=length(files);       
fileNames = {files.name};
    
    
     
      if mod (nFiles,2)==0 
    I=nFiles/2;
else
    I=[nFiles-1]/2;
end
     
    
  for f=1:nFiles
     name1 = strcat(root_dir,fileNames{f});
     name2 = strcat(root_dir,fileNames{I});
      img=imread(name1);
      ref_img=imread(name2);
      
      fprintf('Optimizing %s ...\n',fileNames{f});
      
      
    if name1==name2
        continue
    end
    
    %sigma
global o;
o = 5;

new_img = zeros(size(img));

% default: 256 bins
H1 = imhist(img);
H2 = imhist(ref_img);

%removes background influence
H1(1) = 0;
H2(1) = 0;

%do optimization
%opt = optimset('Display','iter','PlotFcns',@optimplotfval);
%opt = optimset('Display','iter');
opt = optimset('Display','final');
T = fminsearch(@(x)objf(x,H1,H2),[1.0 -2.0],opt); 
%[T,Ot,nS] = powell(@(x)objf(x,H1,H2), [1.2 2.5],-1,[],[],[],[],[],300);


%map intensities
n = length(H1);
%skip fist histogram position (1) so to avoid processing background
for xi=1:n-1 % image always [0 255]
    v = F(xi,T);
    new_img(img == xi) = v;
end
new_img = round(new_img);
new_img = uint8(new_img);

% close all;
% subplot(1,3,1);
% bar(H1);
% subplot(1,3,2);
% bar(H2);
% newH = imhist(new_img);
% newH(1) = 0;
% subplot(1,3,3);
% bar(newH);

   imwrite(new_img,name1)

   % movefile(name1,)
  end
    
  end
  
  %
% Objective function
% Searchs for A and B coefs of the affine transform.
%
function f = objf(param, h1,h2)

%[A B]
% a = param(1);
% b = param(2);

n = length(h1); %both histograms must have the same no. of bins

ps_xi = zeros(1,n);
qs_yi = zeros(1,n);
qof_xi = zeros(1,n);
pof_yi = zeros(1,n);

for xx=1:n
    ps_xi(xx) = ps(xx,h1);
    qs_yi(xx) = ps(xx,h2);
    qof_xi(xx) = qofs(xx,h2,param);
    pof_yi(xx) = pofs(xx,h1,param);
end

f = ssd(ps_xi,qof_xi) + ssd(qs_yi,pof_yi);
%f = sav(ps_xi,qof_xi) + sav(qs_yi,pof_yi);
%f = ssd(ps_xi,qof_xi);

end

%
% squared sum difference of a 1D vector
%
function e = ssd(v1,v2)
    e = sum((v1-v2).^2);
end

%
% Discrete smoothed PDF p_s^~(x_i)
% H: a histogram (1D vector)
% yj: bin in histogram H
% a & b : affine transform coefs.
% 
function pp = ps(yj,H)

global o;
%O = 5.0; %sigma

nB = length(H);
n = sum(H);
xi = 1:nB;

yj_min = ((yj-1) + yj)/2;
yj_max  = (yj + (yj+1))/2;
yj_min = ones(1,nB).*yj_min; 
yj_max = ones(1,nB).*yj_max;

Ks = erf( (yj_max-xi)./(sqrt(2)*o) ) - erf( (yj_min-xi)./(sqrt(2)*o) ); 
p = H./n;

tmp = p.*Ks'; %make Ks a column vector so to multiply each element w/ each element of p

pp = sum(tmp)/2;

end

%
% Computes composite function (q o f)_s^~(xi)
%
function q = qofs(yj,H,param)

global o;
%O = 5.0; %sigma

nB = length(H);
n = sum(H);
xi = 1:nB;

yj_min = ((yj-1) + yj)/2;
yj_max  = (yj + (yj+1))/2;
yj_min = ones(1,nB).*yj_min; 
yj_max = ones(1,nB).*yj_max;

fyj_min = F(yj_min,param);
fyj_max = F(yj_max,param);

Ks = erf( (fyj_max-xi)./(sqrt(2)*o) ) - erf( (fyj_min-xi)./(sqrt(2)*o) ); 
p = H./n;

tmp = p.*Ks';

q = sum(tmp)/2;

end

%
% Computes composite function (p o f^-1)_s^~(xi)
%
function q = pofs(yj,H,param)

global o;
%O = 5.0; %sigma

nB = length(H);
n = sum(H);
xi = 1:nB;

yj_min = ((yj-1) + yj)/2;
yj_max  = (yj + (yj+1))/2;
yj_min = ones(1,nB).*yj_min; 
yj_max = ones(1,nB).*yj_max;

fyj_min = invF(yj_min,param);
fyj_max = invF(yj_max,param);

Ks = erf( (fyj_max-xi)./(sqrt(2)*o) ) - erf( (fyj_min-xi)./(sqrt(2)*o) ); 
p = H./n;

tmp = p.*Ks';

q = sum(tmp)/2;

end

%
% Affine transform f
%
function y = F(x,param)
    y = (x.*param(1)) + param(2);
    %y = x + param(1);
end

%
% Inverse affine transform f^-1
%
function y = invF(x,param)
    y = (x-param(2))./ param(1);
    %y = x - param(1);
end



     