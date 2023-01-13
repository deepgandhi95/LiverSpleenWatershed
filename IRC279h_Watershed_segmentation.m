%% Testing 
clear;
close all;
clc;
%% Method 1 Spleen Mask
% Part 1
% Read the nifti files and display them 
[file, ~] = uigetfile('*.*', 'Select Nifti File','multiselect', 'on');
Liver_masked = niftiread(file);
size_masked = size(Liver_masked);
figure(1) 
montage(Liver_masked,'DisplayRange',[]);
title('Masked Liver and Spleen Images')

% Calculate the segmentation function (gradient of the image)
[Gmag,~,~] = imgradient3(Liver_masked);
figure(2)
montage(Gmag,'DisplayRange',[]);
title('Gradient Magnitude')

% Part2 Marking the foreground objects
% Opening (Just for demonstration)
se = strel3d(2); % 2 works best 
% Io = imopen(Liver_masked,se);
% figure(3)
% montage(Io,'DisplayRange',[]);
% title('Opening')

% Opening by reconstruction (Works better than opening)
Ie = imerode(Liver_masked,se);
Iobr = imreconstruct(Ie,Liver_masked);
figure(3)
montage(Iobr,'DisplayRange',[]);
title('Opening-by-Reconstruction')

% Opening-Closing (Just for demonstration)
% Ioc = imclose(Io,se);
% figure(5)
% montage(Ioc,'DisplayRange',[]);
% title('Opening-Closing')

% Opening-Closing by Reconstruction (Works better than Opening-Closing)
Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure(4)
montage(Iobrcbr,'DisplayRange',[]);
title('Opening-Closing by Reconstruction')

% Regional Maxima of Opening-Closing by Reconstruction
fgm = imregionalmax(Iobrcbr);
figure(5)
montage(fgm,'DisplayRange',[]);
title('Regional Maxima of Opening-Closing by Reconstruction')

% Superimpose Foreground marker on the original image
% I2 = imoverlay3d(fgm, Liver_masked);
% figure(7)
% montage(I2,'DisplayRange',[]);
% title('Regional Maxima Superimposed on Original Image')

% Cleaning edges of marker blobs and shrinking 
se2 = strel3d(2); % 2 works best for extracting spleen masks
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);

% Removes blobs which have fewer than certain number of pixels
fgm4 = bwareaopen(fgm3,9);
% I3 = labeloverlay(Liver_masked,fgm4);
% figure(8)
% montage(I3,'DisplayRange',[]);
% title('Modified Regional Maxima Superimposed on Original Image')

% Part3 
% Compute Background Markers (Dark pixels = Background)
bw = imbinarize(Iobrcbr);
figure(6)
montage(bw,'DisplayRange',[]);
title('Thresholded Opening-Closing by Reconstruction')

% Thin Background and compute skeleton by influence zone (SKIZ)
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
figure(7)
montage(bgm,'DisplayRange',[]);
title('Watershed Ridge Lines')

% Modify gradient magnitude so that regional minima occurs at foreground and background marker pixels.
gmag2 = imimposemin(Gmag, bgm | fgm4);

% Compute Watershed-based segmentation
L = watershed(gmag2);
figure(8)
montage(L,'DisplayRange',[]);

niftiwrite(L,'watershed.nii');