function z = random_image(x, y)
z = [];
z = rand([x y]);
z = im2int8(z);
imshow(z);
imwrite(z, 'rand8bit.tif');