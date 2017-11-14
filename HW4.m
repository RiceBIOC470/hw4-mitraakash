%HW4
%% 
% Problem 1. 
%GB Comments:
1a 100
1b 100
1c 100
1d 25 Incorrect plot and with no explanation of the result as the question asks. The plot provided in the code produces a graph with the mean along the x-axis and and standard deviation on the y-axis. To address the question, there should have been two plots. One with mean intensity as a function of the circle size and the second with standard deviation values as a function of circle size. 
2a. 50. Output avi only displays the nuclear label. Need to turn file into a composite image to view both channels at once. 
2b. 70 Output tiffs were missing the nuclear label and the AVI output is blank. Also, the code does not make a max intensity projection in the Z direction. Currently the code is normalizing to the max for 1 plane image. 
3a. 50 In a max intensity projection you want to grab the max intensity in the xy plane across all Z sections from a single time point. It appears you are iterating the loop (k) 19 times, which is the time domain and not the Zdomain (6 ). Additionally It does not appear that you are retaining the highest intensity pixels once iterating. 
3b 100 Again, you are iterating over the time domain but I won’t take points off for it here. 
3c 100 
3d 100
3e 100 Again, you are iterating over the time domain but I won’t take points off for it here.
4a. 100 Your smooth_sub function is not being called correctly because your variables are undefined. 
4b. 100
 Overall = 83

% 1. Write a function to generate an 8-bit image of size 1024x1024 with a random value 
% of the intensity in each pixel. Call your image rand8bit.tif. 

img_rand = img_random(1024, 1024);
imshow(img_rand);

% 2. Write a function that takes an integer value as input and outputs a
% 1024x1024 binary image mask containing 20 circles of that size in random
% locations

img_bw = binarymask_circle(10);
imshow(img_bw);

% 3. Write a function that takes the image from (1) and the binary mask
% from (2) and returns a vector of mean intensities of each circle (hint: use regionprops).
%
meanIntensity = returnMeanIntensity(img_bw, img_rand);

% 4. Plot the mean and standard deviation of the values in your output
% vector as a function of circle size. Explain your results. 

mean_intensity = [];
stdev_intensity = [];
for i= 1:10:500
    img2 = binarymask_circle(i);
    mean_of_intensity = returnMeanIntensity(img2, img_rand);
    mean_intensity = [mean_intensity mean(mean_of_intensity)];
    stdev_intensity = [stdev_intensity std(mean_intensity)];
end

plot(mean_intensity, stdev_intensity, 'r.','MarkerSize', 10);
xlabel('Mean', 'FontSize', 10);
ylabel('Standard Deviation', 'FontSize', 10);


%%

%Problem 2. Here is some data showing an NFKB reporter in ovarian cancer
%cells. 
%https://www.dropbox.com/sh/2dnyzq8800npke8/AABoG3TI6v7yTcL_bOnKTzyja?dl=0
%There are two files, each of which have multiple timepoints, z
%slices and channels. One channel marks the cell nuclei and the other
%contains the reporter which moves into the nucleus when the pathway is
%active. 
%
%Part 1. Use Fiji to import both data files, take maximum intensity
%projections in the z direction, concatentate the files, display both
%channels together with appropriate look up tables, and save the result as
%a movie in .avi format. Put comments in this file explaining the commands
%you used and save your .avi file in your repository (low quality ok for
%space). 

% Image1 -> Stacks -> Z project -> Max intensity
% Image2 -> Stacks -> Z project -> Max intensity
% CombinedImage -> Image -> Look up Tables -> Greys
% CombinedImage -> Stacks -> Tools -> Concatenate -> Pick two images and Save as .avi

%Part 2. Perform the same operations as in part 1 but use MATLAB code. You don't
%need to save the result in your repository, just the code that produces
%it. 

reader1 = bfGetReader('nfkb_movie1.tif');

time = reader1.getSizeT;
chan = reader1.getSizeC;
zplane = reader1.getSizeZ;
iplane = [];
iplane2 = [];
for i=1:time
    iplane = reader1.getIndex(zplane-1, chan-1, i-1)+1;
   % for j=1:iplane
        img1 = bfGetPlane(reader1, iplane);
        chan = 2;
        iplane2 = reader1.getIndex(zplane-1, chan-1, i-1)+1;
        img2 = bfGetPlane(reader1, iplane2);
        img_temp = cat(3, imadjust(img1), imadjust(img2), zeros(size(img1)));
        
        img_temp_d = im2double(img_temp);
        img_bright = uint16((2^16-1)*(img_temp_d./max(max(img_temp_d))));
        
        imwrite(img_bright,'hw4_1_Final.tiff','WriteMode','append');
    %end
end


reader2 = bfGetReader('nfkb_movie2.tif');

time2 = reader2.getSizeT;
chan2 = reader2.getSizeC;
zplane2 = reader2.getSizeZ;
iplane3 = [];
iplane4 = [];

for i=1:time2
    iplane3 = reader2.getIndex(zplane2-1, chan2-1, i-1)+1;
 %   for j=1:iplane3
        img3 = bfGetPlane(reader2, iplane3);
        chan = 2;
        iplane4 = reader2.getIndex(zplane2-1, chan-1, i-1)+1;
        img4 = bfGetPlane(reader2, iplane4);
        img_temp2 = cat(3, imadjust(img3), imadjust(img4), zeros(size(img1)));
        
        img_temp2_d = im2double(img_temp2);
        img_bright2 = uint16((2^16-1)*(img_temp2_d./max(max(img_temp2_d))));
        
        imwrite(img_bright2,'hw4_1_Final.tiff','WriteMode','append');
  %  end
end

reader3 = bfGetReader('hw4_1_Final.tiff');
iplane5=[];
v = VideoWriter('hw4_1_Final.avi','Uncompressed AVI');
open(v);
for k=1:reader3.getSizeT
    iplane5 = reader3.getIndex(reader3.getSizeZ-1, reader3.getSizeC-1, k-1)+1;
    img5 = bfGetPlane(reader3, iplane5);
    img5 = im2double(img5);
    writeVideo(v, img5);
end
close(v);
 
 

% fname = 'nfkb_movie1.tif';
% info = bfGetReader(fname);
% nfkb1 = [];
% numberOfImages = length(info);
% for k = 1:numberOfImages
%     currentImage = imread(fname,k, 'Info', info);
%     [rows, columns, numSlices] = size(currentImage);
%     outputImage = zeros(rows, columns, class(currentImage));
%     for col = 1:columns
%         for row = 1:rows
%             thisZVector = currentImage(row, col, :);
%             maxValue = max(thisZVector);
%             outputImage(row, col) = maxValue;
%         end
%     end
%     %nfkb1(:,:,k) = outputImage;
%     imwrite(outputImage,'hw4_1.tif','WriteMode','append');
% end
% 
% 
% fname2 = 'nfkb_movie2.tif';
% info2 = imfinfo(fname2);
% nfkb2 = [];
% numberOfImages2 = length(info2);
% for k = 1:numberOfImages2
%     currentImage2 = imread(fname2,k, 'Info', info2);
%     [rows2, columns2, numSlices2] = size(currentImage2);
%     outputImage2 = zeros(rows2, columns2, class(currentImage2));
%     for col = 1:columns2
%         for row = 1:rows2
%             thisZVector2 = currentImage(row, col, :);
%             maxValue2 = max(thisZVector2);
%             outputImage2(row, col) = maxValue2;
%         end
%     end
%     %nfkb1(:,:,k) = outputImage;
%     imwrite(outputImage2,'hw4_1.tif','WriteMode','append');
% end


% [rows, columns, numSlices] = size(currentImage);
% outputImage = zeros(rows, columns, class(currentImage));
% for col = 1:columns
%     for row = 1:rows
%         thisZVector = currentImage(row, col, :);
%         maxValue = max(thisZVector);
%         outputImage(row, col) = maxValue;
%         nfkb1(:,:,k) = outputImage;
%     end
% end
% 
% 
% fname = 'nfkb_movie1.tif';
% info = imfinfo(fname);
% mImage = info(1).Width;
% nImage = info(1).Height;
% numberOfImages = length(info);
% FinalImage = zeros(nImage,mImage, numberOfImages, 'uint16');
% TifLink = Tiff(fname,'r');
% for i = 1:numberOfImages
%     TifLink.setDirectory(i);
%     FinalImage(:,:,i) = TifLink.read();
% end
% TifLink.close();




% mip = max(nfkb1, [], 3);
% 
% subplot(1,2,1), imshow(outputImage, []), title('Plane Intenisty');
% 
% subplot(1,2,2), imshow(mip, [])
% title('MIP')

% numberOfImages = size(imfinfo(fname),1)
% for i = 1:numberOfImages
%     I =imread(fname,i);
%     figure
%     imshow(I);
% end



% nfkb2 = imread('nfkb_movie2.tif');
% [rows, columns, numSlices] = size(nfkb2);
% outputImage2 = zeros(rows, columns, class(nfkb2));
% for col = 1:columns
%     for row = 1:rows
%         thisZVector = nfkb2(row, col, :);
%         maxValue = max(thisZVector);
%         outputImage2(row, col) = maxValue;
%     end
% end
% 
% mip2 = max(nfkb2, [], 3);
% 
% subplot(1,2,1), imshow(outputImage2, []), title('Plane Intenisty');
% 
% subplot(1,2,2), imshow(mip2, [])
% title('MIP')
% 
% newImg1 = cat(1,outputImage, outputImage2);
% newImg2 = cat(2, mip,mip2);
% 
% subplot(1,2,1), imshow(newImg1, []), title('Plane Intenisty');
% 
% subplot(1,2,2), imshow(newImg2, [])
% title('MIP')

%%

% Problem 3. 
% Continue with the data from part 2
% 
% 1. Use your MATLAB code from Problem 2, Part 2  to generate a maximum
% intensity projection image of the first channel of the first time point
% of movie 1. 

img_reader = bfGetReader('nfkb_movie1.tif');
img_iplane = [];

for k=1:img_reader.getSizeT
    img_iplane = img_reader.getIndex(img_reader.getSizeZ-1, img_reader.getSizeC-1, k-1)+1;
    img = bfGetPlane(img_reader, img_iplane);
    img_d = im2double(img);
    img_bright = uint16((2^16-1)*(img_d/max(max(img_d))));
end

imshow(img_bright, []), title('MIP First Channel First Time Point')


% 2. Write a function which performs smoothing and background subtraction
% on an image and apply it to the image from (1). Any necessary parameters
% (e.g. smoothing radius) should be inputs to the function. Choose them
% appropriately when calling the function.

img_reader = bfGetReader('nfkb_movie1.tif');
radius = 5;
sigma = 3;

img_sm_bgsub = smooth_sub(img_reader, radius, sigma);
imshow(img_sm_bgsub,[])


% 3. Write  a function which automatically determines a threshold  and
% thresholds an image to make a binary mask. Apply this to your output
% image from 2.

img_auto_threshold = auto_threshold(img_sm_bgsub);

figure
imshowpair(img_sm_bgsub,img_auto_threshold,'montage');

% 4. Write a function that "cleans up" this binary mask - i.e. no small
% dots, or holes in nuclei. It should line up as closely as possible with
% what you perceive to be the nuclei in your image. 

img_clean = remove_noise(img_auto_threshold);

subplot(1,2,1), imshow(img_auto_threshold, []), title('Original Image');
subplot(1,2,2), imshow(img_clean, [])
title('Morphologically improved image')

% 5. Write a function that uses your image from (2) and your mask from 
% (4) to get a. the number of cells in the image. b. the mean area of the
% cells, and c. the mean intensity of the cells in channel 1. 

[num_of_cells, mean_area, mean_intensity] = properties_of_cells(img_clean, img_sm_bgsub);


% 6. Apply your function from (2) to make a smoothed, background subtracted
% image from channel 2 that corresponds to the image we have been using
% from channel 1 (that is the max intensity projection from the same time point). Apply your
% function from 5 to get the mean intensity of the cells in this channel. 

% Get image from second channel and perform MIP

img_reader = bfGetReader('nfkb_movie1.tif');
img_iplane = [];

for k=1:img_reader.getSizeT
    img_iplane = img_reader.getIndex(img_reader.getSizeZ-1, 2-1, k-1)+1;
    new_img = bfGetPlane(img_reader, img_iplane);
    new_img_d = im2double(img);
    new_img_bright = uint16((2^16-1)*(new_img_d/max(max(new_img_d))));
end

imshow(new_img_bright, []), title('MIP Second Channel First Time Point')

% background subtraction
new_img_sm_bgsub = smooth_sub(img_reader, radius, sigma, new_img_bright);
imshow(new_img_sm_bgsub,[])

% Threshold image
new_img_auto_threshold = auto_threshold(new_img_sm_bgsub);

% Remove noise from image
new_img_clean = remove_noise(img_auto_threshold);

% Mean Intensity of cells
[num_of_cells1, mean_area1, mean_intensity1] = properties_of_cells(new_img_clean,new_img_sm_bgsub);


%%
% Problem 4. 

% 1. Write a loop that calls your functions from Problem 3 to produce binary masks
% for every time point in the two movies. Save a movie of the binary masks.
% 

reader1 = bfGetReader('nfkb_movie1.tif');

time = reader1.getSizeT;
chan = reader1.getSizeC;
zplane = reader1.getSizeZ;
iplane = [];
iplane2 = [];
for i=1:time
    iplane = reader1.getIndex(zplane-1, chan-1, i-1)+1;
   % for j=1:iplane
        img1 = bfGetPlane(reader1, iplane);
        chan = 2;
        iplane2 = reader1.getIndex(zplane-1, chan-1, i-1)+1;
        img2 = bfGetPlane(reader1, iplane2);
        img_temp = cat(3, imadjust(img1), imadjust(img2), zeros(size(img1)));
        
        img_temp_d = im2double(img_temp);
        img_bright = uint16((2^16-1)*(img_temp_d./max(max(img_temp_d))));
        img_sm_bgsub1 = smooth_sub(reader1, radius, sigma, img_bright);
        img_auto_threshold = auto_threshold(img_sm_bgsub);
        img_clean1 = remove_noise(img_auto_threshold);
        imwrite(img_clean1,'hw4_binarymask.tif','WriteMode','append');
    %end
end


reader2 = bfGetReader('nfkb_movie2.tif');

time2 = reader2.getSizeT;
chan2 = reader2.getSizeC;
zplane2 = reader2.getSizeZ;
iplane3 = [];
iplane4 = [];

for i=1:time2
    iplane3 = reader2.getIndex(zplane2-1, chan2-1, i-1)+1;
 %   for j=1:iplane3
        img3 = bfGetPlane(reader2, iplane3);
        chan = 2;
        iplane4 = reader2.getIndex(zplane2-1, chan-1, i-1)+1;
        img4 = bfGetPlane(reader2, iplane4);
        img_temp2 = cat(3, imadjust(img3), imadjust(img4), zeros(size(img1)));
        
        img_temp2_d = im2double(img_temp2);
        img_bright2 = uint16((2^16-1)*(img_temp2_d./max(max(img_temp2_d))));
        img_sm_bgsub2 = smooth_sub(reader2, radius, sigma, img_bright2);
        img_auto_threshold2 = auto_threshold(img_sm_bgsub2);
        img_clean2 = remove_noise(img_auto_threshold2);
        imwrite(img_clean2,'hw4_binarymask.tif','WriteMode','append');
  %  end
end


reader3 = bfGetReader('hw4_binarymask.tif');
iplane5=[];
v = VideoWriter('hw4_1_binarymask_Final.avi','Uncompressed AVI');
open(v);
for k=1:reader3.getSizeT
    iplane5 = reader3.getIndex(reader3.getSizeZ-1, reader3.getSizeC-1, k-1)+1;
    img5 = bfGetPlane(reader3, iplane5);
    img5 = im2double(img5);
    writeVideo(v, img5);
end
close(v);

% 2. Use a loop to call your function from problem 3, part 5 on each one of
% these masks and the corresponding images and 
% get the number of cells and the mean intensities in both
% channels as a function of time. Make plots of these with time on the
% x-axis and either number of cells or intensity on the y-axis. 

reader_bw = bfGetReader('hw4_binarymask.tif');
reader = bfGetReader('hw4_1_Final.tiff');
time_bw = reader_bw.getSizeT;
chan_bw = reader_bw.getSizeC;
zplane_bw = reader_bw.getSizeZ;
iplane_bw1 = [];
iplane_bw2 = [];
time = reader.getSizeT;
chan = reader.getSizeC;
zplane = reader.getSizeZ;
iplane1 = [];
iplane2 = [];
num_of_cells_bw = [];
mean_intensity_bw = [];

for i=1:time_bw
    iplane3 = reader_bw.getIndex(zplane_bw-1, chan_bw-1, i-1)+1;
    img6 = bfGetPlane(reader_bw, iplane_bw1);
    chan_bw = 2;
    iplane_bw2 = reader_bw.getIndex(zplane_bw-1, chan_bw-1, i-1)+1;
    img7 = bfGetPlane(reader_bw, iplane_bw2);
    img_temp_bw = cat(3, imadjust(img6), imadjust(img7), zeros(size(img6)));
    
    iplane = reader.getIndex(zplane-1, chan-1, i-1)+1;
    img8 = bfGetPlane(reader, iplane1);
    chan = 2;
    iplane2 = reader.getIndex(zplane-1, chan-1, i-1)+1;
    img9 = bfGetPlane(reader, iplane2);
    img_temp = cat(3, imadjust(img8), imadjust(img9), zeros(size(img8)));

    [num_of_cells_bw, mean_area_bw, mean_intensity_bw] = properties_of_cells(img_temp_bw,img_temp);
    num_of_cells_bw(i) = num_of_cells_bw;
    mean_intensity_bw(i) = mean_intensity_bw;
end

hold on
for i = 1:numel(num_of_cells_bw)
    plot(num_of_cells_bw(:,1),num_of_cells_bw(:,2), 'b*')
end
hold off

hold on
for i = 1:numel(mean_intensity_bw)
    plot(mean_intensity_bw(:,1),mean_intensity_bw(:,2), 'b*')
end
hold off
