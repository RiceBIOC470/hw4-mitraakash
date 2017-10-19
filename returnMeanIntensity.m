function x = returnMeanIntensity(img1,img2)
cell_props = regionprops(img1, img2, 'MeanIntensity');
x = [cell_props.MeanIntensity];