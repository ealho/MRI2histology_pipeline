function checker = makechecker(img1,img2)

[r1, c1, N1] = size(img1);
[r2, c2, N2] = size(img2);

if r1 ~= r2 || c1 ~= c2 || N1 ~= N2 
    error('Different image dimensions.');
end

ntiles = 2;

sblock = (r1/ntiles)/2;

cmask = checkerboard(sblock,ntiles,ntiles);
cmask = (cmask > 0.5);

checker = img1;
checker(cmask == 1) = img2(cmask == 1);







