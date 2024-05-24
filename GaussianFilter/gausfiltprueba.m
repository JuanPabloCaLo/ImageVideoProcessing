%% Comprobación Imgaussfilt vs Miimgaussfilt2
%figure(1) y figure(2) deben ser iguales

%% Borrado de variables
clear all
clc
%% Lectura de imágenes
imagen1 = im2double(imread('MosaicoAlhambra.jpg'));
sigma=30;
%gaussfilt1
imagenfilt1 = imgaussfilt(imagen1, sigma);
%gaussfilt270
imagenfilt2 = myimgaussfilt(imagen1, sigma);

figure(1)
imshow(imagenfilt1);
figure(2)
imshow(imagenfilt2);