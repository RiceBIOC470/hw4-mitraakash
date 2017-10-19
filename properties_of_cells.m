function [num_of_cells, mean_area, mean_intensity] = properties_of_cells(img1, img2)

%a
cell_props = regionprops(img1, img2, 'Area','Centroid','Image','PixelIdxList','MeanIntensity','MaxIntensity','PixelValues');
num_of_cells = length(cell_props);
disp(['Number of cells in image: ' int2str(num_of_cells)]);

%b
total_area = 0;
for i=1:numel(cell_props)
    total_area=total_area + cell_props(i).Area;
end
mean_area = total_area/length(cell_props);
disp(['Mean area of cells:' int2str(mean_area)]);

%c
new_img1 = img1(:,:,1);
new_img2 = img2(:,:,1);

cell_props2 = regionprops(new_img1,new_img2, 'MeanIntensity');
total_intensity = 0;
for i=1:numel(cell_props2)
    total_intensity=total_intensity + cell_props2(i).MeanIntensity;
end
mean_intensity = total_intensity/length(cell_props2);
disp(['Mean intensity of cells: ' int2str(mean_intensity)]);
