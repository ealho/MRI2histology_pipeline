% Author:Eduardo Alho
%Date:07/06/2017

I=imread('feito2.jpg');

Bw=im2bw(I);

BW2 = bwareafilt(Bw,1);
Fill=imfill(BW2,'holes');

masked = bsxfun(@times, I, cast(Fill,class(I)));
