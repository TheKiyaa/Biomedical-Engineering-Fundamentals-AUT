%% Project 3 - Brain MRI Processing
clc;
clear;
close all;

%% B) Load NIfTI file
gunzip('Brain_T2.nii.gz');
volume = niftiread('Brain_T2.nii');
disp('Volume Size:')
disp(size(volume))

%% C) Select Slice
LAST_DIGIT = 2;      % <-- رقم آخر شماره دانشجویی
sliceNum = 100 + LAST_DIGIT;
brainSlice = volume(:,:,sliceNum);
figure;
imshow(brainSlice,[]);
title(['Original Slice ',num2str(sliceNum)])

%% D) Min-Max Normalization
brainSlice = double(brainSlice);
minVal = min(brainSlice(:));
maxVal = max(brainSlice(:));
normImg = (brainSlice - minVal) ./ (maxVal - minVal);
fprintf('Minimum = %f\n',minVal);
fprintf('Maximum = %f\n',maxVal);
img8 = uint8(normImg*255);
figure;
imshow(img8);
title('Normalized Image')

%% E) Rotate
rotImg = imrotate(img8,90);
figure;
imshow(rotImg);
title('Rotated Image')

%% Crop Brain Region
% با ابزار موس ناحیه مغز را انتخاب کن و دبل کلیک کن
croppedImg = imcrop(rotImg);
disp('Crop Size:')
disp(size(croppedImg))
figure;
imshow(croppedImg);
title('Cropped Brain')

%% Resize to 120x120
IMG = imresize(croppedImg,[120 120]);
figure;
imshow(IMG);
title('IMG (120x120)')

%% -------------------------
%% Bilateral Filter
%% -------------------------
DoS1 = 20;
Sigma1 = 1;
DoS2 = 80;
Sigma2 = 2;
DoS3 = 200;
Sigma3 = 5;

F1 = imbilatfilt(IMG,DoS1,Sigma1);
F2 = imbilatfilt(IMG,DoS2,Sigma2);
F3 = imbilatfilt(IMG,DoS3,Sigma3);

figure;
subplot(2,2,1)
imshow(IMG)
title('Original')
subplot(2,2,2)
imshow(F1)
title('DoS=20 Sigma=1')
subplot(2,2,3)
imshow(F2)
title('DoS=80 Sigma=2')
subplot(2,2,4)
imshow(F3)
title('DoS=200 Sigma=5')

%% Histogram
figure;
imhist(F2);
title('Histogram')

%% Thresholding & Color Mapping (تصحیح باگ اصلی)
I = F2;
T1 = 40;
T2 = 90;
T3 = 150;

% ایجاد ماسک‌های منطقی
mask1 = I < T1;
mask2 = I >= T1 & I < T2;
mask3 = I >= T2 & I < T3;
mask4 = I >= T3;

% تعریف ماتریس سه بعدی خالی با ابعاد تصویر ورودی
result = zeros(size(I,1), size(I,2), 3, 'uint8');

% اعمال رنگ‌ها با تبدیل کل عبارت به uint8 جهت جلوگیری از خطای دیتاتایپ
result(:,:,1) = uint8(mask1 * 80  + mask2 * 160 + mask3 * 173 + mask4 * 21);
result(:,:,2) = uint8(mask1 * 48  + mask2 * 150 + mask3 * 227 + mask4 * 20);
result(:,:,3) = uint8(mask1 * 0   + mask2 * 112 + mask3 * 250 + mask4 * 218);

figure;
imshow(result);
title('Tumor Segmentation')