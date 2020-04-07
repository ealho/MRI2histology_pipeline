function [L, Lambda] = LapEig( B, num_modes, element_spacing )
% LapEig  computes the Dirichlet type laplacian spectra for the binary volume B.
%
% [L, Lambda] = LapEig( B, num_modes )
%   or
% [L, Lambda] = LapEig( B, num_modes, element_spacing )
%
% Input:
%   B: binary volume (3D array) or image (2D array)
%   num_modes: number of modes to be computed
%   element_spacing: physical spacing between grid points in B
%
% Output:
%   L: Resulting eigenfunctions - cell array
%   Lambda: Resulting eigenvalues corresponding to the functions
%
% Default parameters:
%   given dim = length(size(B)); % dimension 2 or 3
%   element_spacing: ones(1, dim);
%
% CAUTION: The speed of computation depends on the number of elements in B
% and number of modes. For very large objects the computation times might
% be slow due to limitations of computing eigenvalues of large sparse matrices.
%
% Examples:
%   B is a 2D binary image with isotropic element spacing of 0.5
%   [L, Lambda] = LapEig( B, 200, [0.5 0.5] );
%
% Uses delsq2D, delsq3D.
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
dim = length(size(B)); % dimension 2 or 3

% set default parameters
if nargin < 3
    element_spacing = ones(1, dim);
end

% finding the nonzero elements in the binary mask. 
indice1 = find( B );

% creating the sparse matrix for approximating the Laplacian with Dirichlet
% boundary conditions..
[~,indice1_] = sort(indice1,'ascend');
D = zeros( size(B) );
D(indice1(indice1_)) = 1:length(indice1);
if ( dim == 3 )
    Lop = delsq3D(D, element_spacing);
else
    Lop = delsq2D(D, element_spacing);
end;

% computing the eigenvalues of the discrete Laplacian
[V1,E1] = eigs(Lop, num_modes, 'SM');

% sorting according to magnitude
[E1,ind] = sort(diag(E1),'ascend');
V1 = V1(:,ind);
Lambda = E1;
L = cell(1,num_modes);
for j=1:num_modes
    Dv1 = zeros(size(D));
    Dv1(indice1(indice1_)) = V1(:,j);
    L{j} = Dv1;
end;
