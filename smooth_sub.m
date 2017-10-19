function img_sm_bgsub = smooth_sub(img_reader, radius, sigma, img)

if exist('img_reader','var')
    
    img_iplane = [];

    for k=1:img_reader.getSizeT
        img_iplane = img_reader.getIndex(img_reader.getSizeZ-1, img_reader.getSizeC-1, k-1)+1;
        img = bfGetPlane(img_reader, img_iplane);
        img_sm = imfilter(img, fspecial('gaussian',radius,sigma));
        img_bg = imopen(img_sm, strel('disk',100));
        img_sm_bgsub = imsubtract(img_sm, img_bg);
    end
else
    
    img_sm = imfilter(img, fspecial('gaussian',radius,sigma));
    img_bg = imopen(img_sm, strel('disk',100));
    img_sm_bgsub = imsubtract(img_sm, img_bg);
end
