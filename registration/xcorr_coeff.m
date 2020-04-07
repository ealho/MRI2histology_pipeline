function xcorr_score = xcorr_coeff(image1,image2)
%XCORR_COEFF  Image cross-correlation coefficient 
%  XCORR_SCORE = XCORR_COEFF(IMAGE1,IMAGE2) calculates the cross-correlation
%  coefficient between the input images IMAGE1 and IMAGE2. IMAGE1 and IMAGE2 are
%  matrices. The output XCORR_SCORE defines the proportion of variance in common
%  between the two images. (It provides a least squares fitting approximation.)

% Documentation updated: 4/19/06 12:05pm, Eric Weiss

xcorr_score = corr2(image1, image2);
