function img_dilate = remove_noise(img)

% img_dilate = imdilate(img_auto_threshold, strel('disk',5));
% imshow(img_dilate,[]);

img_dilate = imopen(img, strel('disk',5));
% subplot(1,2,1), imshow(img_open);
% subplot(1,2,2), imshow(img_auto_threshold);

% img_close = imclose(img_auto_threshold, strel('disk',5));
% subplot(1,2,1), imshow(img_close);
% subplot(1,2,2), imshow(img_auto_threshold);
