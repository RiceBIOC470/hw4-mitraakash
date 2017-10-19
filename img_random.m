function z = img_random(x, y)
z = [];
z = rand([x y]);
z = im2uint8(z);
imwrite(z, 'rand8bit.tif');