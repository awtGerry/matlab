% Median filter to remove noise in an image

% Two functions are used in this code:
% 1. Median filter
% 2. Median filter with multiplier window

% with the mask [ 0 6 3; 2 0 0; 8 4 9 ]
% and the multiplier window [ 1 3 2; 2 4 1; 1 2 1 ]

clc;
clear;
close all;

% Get image
img = imread('~/Programs/Matlab/pdi/parrot.jpg');
img = gray(img);

% define mask
mask = [ 0 6 3; 2 0 0; 8 4 9 ];
% define multiplier window
multiplier = [ 1 3 2; 2 4 1; 1 2 1 ];

imgn = imnoise(img, 'salt & pepper', 0.02);

% Apply median filter
imgmf = median_filter(imgn, mask);

% Apply median filter with multiplier window
imgmfm = median_filter_with_multiplier(imgn, mask, multiplier);

% Show images (all in one figure)
figure;
subplot(1, 3, 1);
imshow(imgn);
title('Image with Noise');
subplot(1, 3, 2);
imshow(imgmf);
title('Median Filter');
subplot(1, 3, 3);
imshow(imgmfm);
title('Median Filter with Multiplier Window');
Show images (all in one figure)


% Convert to grayscale
function img = gray(image)
    [rows, cols, channels] = size(image);
    for i = 1:rows
        for j = 1:cols
            img(i, j) = 0.299 * image(i, j, 1) + 0.587 * image(i, j, 2) + 0.114 * image(i, j, 3);
        end
    end
end

% add noise to image
function img = add_noise(image)
    [rows, cols] = size(image);
    for v=1:1000
        x = round(rand(1)*rows);
        y = round(rand(1)*cols);
        if x == 0
            x = 1;
        end
        if y == 0
            y = 1;
        end
        if x == 600
            x = 598;
        end
        if y == 800
            y = 798;
        end
        % insert
        image(x, y) = 255;
        image(x, y+1) = 255;
        image(x+1, y) = 255;
        image(x+1, y+1) = 255;
        image(x+2, y) = 255;
        image(x+2, y+1) = 255;
    end
    img = image;
end

% Median filter
function img = median_filter(image, mask)
    [rows, cols] = size(image);
    [mask_rows, mask_cols] = size(mask);
    img = image;
    for i = 1:rows-mask_rows
        for j = 1:cols-mask_cols
            % get subimage
            subimg = image(i:i+mask_rows-1, j:j+mask_cols-1);
            % apply mask
            img(i+1, j+1) = median(subimg);
        end
    end
end

% Median filter with multiplier window
function img = median_filter_with_multiplier(image, mask, multiplier)
    [rows, cols] = size(image);
    [mask_rows, mask_cols] = size(mask);
    [multiplier_rows, multiplier_cols] = size(multiplier);
    img = image;
    for i = 1:rows-mask_rows
        for j = 1:cols-mask_cols
            % get subimage
            subimg = image(i:i+mask_rows-1, j:j+mask_cols-1);
            % apply mask
            img(i+1, j+1) = median_with_multiplier(subimg, mask, multiplier);
        end
    end
end

% get median with multiplier
function m = median_with_multiplier(subimg, mask, multiplier)
    array = [];
    [rows, cols] = size(subimg);
    [mask_rows, mask_cols] = size(mask);
    [multiplier_rows, multiplier_cols] = size(multiplier);
    for i = 1:mask_rows
        for j = 1:mask_cols
            for k = 1:multiplier(i, j)
                array = [array subimg(i, j)];
            end
        end
    end
    array = sort(array);
    m = array(ceil(length(array)/2));
end

% get median
function m = median(subimg)
    array = [];
    [rows, cols] = size(subimg);
    for i = 1:rows
        for j = 1:cols
            array = [array subimg(i, j)];
        end
    end
    array = sort(array);
    m = array(ceil(length(array)/2));
end

% sort
function array = sort(array)
    for i = 1:length(array)
        for j = i+1:length(array)
            if array(i) > array(j)
                temp = array(i);
                array(i) = array(j);
                array(j) = temp;
            end
        end
    end
end
