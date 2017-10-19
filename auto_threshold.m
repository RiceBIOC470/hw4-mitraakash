function img_bw = auto_threshold(img)

img_d = im2double(img);
img_bright = uint16((2^16-1)*(img_d/max(max(img_d))));
level = graythresh(img_bright);
img_bw = imbinarize(img_bright,level);
img_bw2 = imbinarize(img_bright,'adaptive');

% figure
% imshowpair(img_bright,img_bw2,'montage');
% figure
% imshowpair(img_bw,img_bw2,'montage');