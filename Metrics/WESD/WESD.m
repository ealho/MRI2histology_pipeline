function [wd, LambdaI, LambdaJ, trErrBound] = WESD(I, J, varargin)
% WESD computes the WEighted Spectral Distance (WESD) between two
% binary volumes.
%
% wd = WESD( I, J, opt_identifier (optional), opt_value (optional) )
%   or
% [wd, LambdaI, LambdaJ] = WESD( I, J, opt_identifier (optional), opt_value (optional) )
%
% Input:
%   I: first binary volume (3D array) or image (2D array)
%   J: second binary volume (3D array) or image (2D array)
% Option Identifiers (opt_identifier): 
%   'num' : number of modes to be included in the analysis (default = 100)
%   'norm_type' : scalar value indicated the p in the p-norm
%                 (default = 2 in 2D and 5/2 in 3D)
%   'element_spacing': physical spacing between grid points in I
%                      and J (default = [1,1] in 2D and [1,1,1] in 3D)
%   'vol_flag' : volume normalization flag - 0: no volume
%                normalization, 1: volume normalization (default = 1)
%   'spec_flag' : spectra normalization flag - 1: normalize the
%                 distance, 0: do not normalize the distance (default = 0)
%   'LambdaI' : Precomputed eigenvalues for volume I (computed with
%               LapEig). If not given they will be computed. 
%   'LambdaJ' : Precomputed eigenvalues for volume J (computed with
%               LapEig). If not given they will be computed. 
%
% Output:
%   wd: WESD score (weighted p-norm)
%   LambdaI: Eigenvalues for binary volume I (computed with LapEig)
%   LambdaJ: Eigenvalues for binary volume J (computed with LapEig)
%   trErrBound: truncation error uppper bound.
%
% Default parameters:
%   given dim = length(size(I)); % dimension 2 or 3
%   num_modes: 100
%   norm_type: dim / 2 + 1
%   element_spacing: ones(1, dim);
%   vol_flag = 1; 
%   spec_flag = 0;
% CAUTION: For convergence set norm_type > dim / 2.
%
% Examples:
%   I,J are 2D binary images with isotropic element spacing of 0.5
%   wd = nWSD( I, J, 'num', 200, 'norm_type', 1.5,
%   'element_spacing', [0.5 0.5] );
%
% Uses LapEig, zeta.
%
% Ender Konukoglu & Ben Glocker, 2011
% Contact: ender.konukoglu@gmail.com
%
% Citation information:
% PMID: 23277496
% @Article{pmid23277496,
%   Author="Konukoglu, E.  and Glocker, B.  and Criminisi, A.  and Pohl, K. M. ",
%   Title="{{W}{E}{S}{D} - {W}eighted {S}pectral {D}istance for {M}easuring {S}hape {D}issimilarity}",
%   Journal="IEEE Transactions on Pattern Analysis and Machine Intelligence",
%   Year="2012",
%   Pages=" ",
%   Month="Dec"}

% parse inputs
if nargin < 2 
    help WESD;
    return;
end;
nargs = 1; 
mf = 0; ntf = 0; 
es = 0; vf = 0; 
sf = 0; lif = 0; 
ljf = 0;
while nargs + 2 < nargin
    str = varargin{nargs};
    value = varargin{nargs+1};
    nargs = nargs + 2;
    switch str
      case {'num'}
        num_modes = value;
        mf = 1;
      case {'norm_type'}
        norm_type = value;
        ntf = 1;
      case {'element_spacing'}
        element_spacing = value;
        es = 1;
      case {'vol_flag'}
        vol_flag = value;
        vf = 1;
      case {'spec_flag'}
        spec_flag = value;
        sf = 1;
      case {'LambdaI'}
        LambdaI = value;
        lif = 1;
      case {'LambdaJ'}
        LambdaJ = value;
        ljf = 1;
    end;     
end;

dim = length(size(I)); % dimension 2 or 3
% set default values if not given
if ~mf, num_modes = 100; end;
if ~ntf, norm_type = dim / 2 + 1; end;
if ~es, element_spacing = ones(1,dim); end;
if ~vf, vol_flag = 1; end;
if ~sf, spec_flag = 0; end;
if ~lif, [~, LambdaI] = LapEig( I, num_modes, element_spacing ); ...
end;
if ~ljf, [~, LambdaJ] = LapEig( J, num_modes, element_spacing ); ...
end;


% scale normalization with respect to volume
if vol_flag
    XiI = LambdaI' * sum(I(:))^(2/dim) * prod(element_spacing)^(2/dim);
    XiJ = LambdaJ' * sum(J(:))^(2/dim) * prod(element_spacing)^(2/dim);
    V = 1;
else
    XiI = LambdaI';
    XiJ = LambdaJ';
    V = max(sum(I(:))*prod(element_spacing), sum(J(:))*prod(element_spacing));    
end;


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

if spec_flag 
    wd =  sum( ( abs(XiI - XiJ) ./ XiI ./ XiJ) .^(norm_type) )^(1 / norm_type) / Z * 100;    
else
    wd = sum( ( abs(XiI - XiJ) ./ XiI ./ XiJ) .^(norm_type) )^(1 / norm_type);    
end;
% compute the upper bound truncation errors. 
list = (1 ./ (3:num_modes)) .^ (norm_type); slist = sum(list);
trErrBound = (C + K * (zeta(norm_type) - 1 - 0.5 ^ (norm_type))) ^ (1 / norm_type)...
    - (C + K * slist) ^ (1 / norm_type);

