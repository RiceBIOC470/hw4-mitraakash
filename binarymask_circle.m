function img_dil = binarymask_circle(x)

img = false([1024 1024]);
linear_indices = randperm(numel(img), 20);
img(linear_indices) = 1;
%img_er = imshow(imerode(img, strel('disk', x)));
img_dil = imdilate(img, strel('disk', x));
