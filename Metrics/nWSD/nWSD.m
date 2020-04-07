function [wd, LambdaI, LambdaJ] = nWSD(I, J, num_modes, norm_type, element_spacing, LambdaI, LambdaJ)
% nWSD  computes the normalized weighted spectral distance (nWSD) between two segmentations.
%
% wd = nWSD( I, J )
%   or
% [wd, LambdaI, LambdaJ] = nWSD( I, J, num_modes, norm_type, element_spacing )
%   or
% wd = nWSD( I, J, num_modes, norm_type, element_spacing, LambdaI, LambdaJ )
%
% Input:
%   I: first binary volume (3D array) or image (2D array)
%   J: second binary volume (3D array) or image (2D array)
%   num_modes: number of modes to be included in the analysis
%   norm_type: scalar value indicating the p in the p-norm. 
%   element_spacing: physical spacing between grid points in I and J
%   LambdaI: Precomputed eigenvalues for volume I (computed with LapEig)
%   LambdaJ: Precomputed eigenvalues for volume J (computed with LapEig)
%
% Output:
%   wd: nWSD score (weighted p-norm)
%   LambdaI: Eigenvalues for binary volume I (computed with LapEig)
%   LambdaJ: Eigenvalues for binary volume J (computed with LapEig)
%
% Default parameters:
%   given dim = length(size(I)); % dimension 2 or 3
%   num_modes: 100
%   norm_type: dim / 2 + 1
%   element_spacing: ones(1, dim);
%
% CAUTION: For convergence set norm_type > dim / 2.
%
% Examples:
%   I,J are 2D binary images with isotropic element spacing of 0.5
%   wd = nWSD( I, J, 200, 1.5, [0.5 0.5] );
%
% Uses LapEig, zeta.
%
% Ender Konukoglu & Ben Glocker, 2011
% Contact: ender.konukoglu@gmail.com
%
% Citation information:
% "Discriminative Segmentation-based Evaluation through Shape
% Dissimilarity", E. Konukoglu, B. Glocker, D. Ye, A. Criminisi and K.
% Pohl, IEEE Transactions on Medical Imaging, 31(12): 2278-89, 2012.
% doi: 10.1109/TMI.2012.2216281
%

% get image dimensionality
dim = length(size(I)); % dimension 2 or 3

% set default parameters
if nargin < 3
    num_modes = 100;
end
if nargin < 4
    norm_type = dim / 2 + 1;
end
if nargin < 5
    element_spacing = ones(1, dim);
end

% computing the modes
if nargin < 6
    [~, LambdaI] = LapEig( I, num_modes, element_spacing );
end
if nargin < 7
    [~, LambdaJ] = LapEig( J, num_modes, element_spacing );
end;

XiI = LambdaI';
XiJ = LambdaJ';
V = max(sum(I(:))*prod(element_spacing), sum(J(:))*prod(element_spacing));

% computing the lower bound for the weighted
if dim == 2
    Bd = pi;
else % dim == 3
    Bd = 4 / 3 * pi;
end;

mu = max(XiI(1),XiJ(1));
C = (1 / (dim / (dim+2) * 4 * pi^2 / (Bd * V)^(2/dim)) - 1 / mu)^(norm_type);
C = C + (1 / (dim / (dim+2) * 4 * pi^2 * 2^(2/dim) / (Bd * V)^(2/dim)) - 1 / (mu * (1 + 4/dim)))^(norm_type);
K = (1 / (dim / (dim+2) * 4 * pi^2 / (Bd * V)^(2/dim)) - 1 / ((1 + 2.64/dim) * mu))^norm_type;
Z = (C + K * (zeta(norm_type) - 1 - 0.5^(norm_type)) )^ (1/norm_type);
wd =  sum( ( abs(XiI - XiJ) ./ XiI ./ XiJ) .^(norm_type) )^(1 / norm_type) / Z * 100;

