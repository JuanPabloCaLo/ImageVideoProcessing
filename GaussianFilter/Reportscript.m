%% Copia codigo p3

%Ruido gausiano
original = im2double(imread('MosaicoAlhambra.jpg'));
sigma = 0.5;
ruidoGaussianoA = original + randn(size(original))*sigma;
%normal sigma cuadrado
%%

ruidoGaussiano = imnoise(original, 'gaussian', 0, sigma^2);
%imagen con ruido

%Los resultados no son exáctamente iguales
%%

densidad = 0.5;
ruidoSalPimienta = imnoise(original, 'salt & pepper', densidad);

%%

figure;
subplot(2,4,1); imshow(original); title('Original');
subplot(2,4,2); imshow(ruidoGaussiano); title(sprintf('GaussianoRand \\sigma: %.2f', sigma));
subplot(2,4,3); imshow(ruidoGaussianoA); title(sprintf('GaussianoImnoise \\sigma: %.2f', sigma));
subplot(2,4,4); imshow(ruidoSalPimienta); title(sprintf('S & Pdensidad: %.2f', densidad));
r1 = 48 ; c1 = 31; r2 = 77; c2 = 303;
subplot(2,4,1); line([c1,c2], [r1,r2],'Color','g','LineWidth',2);
subplot(2,4,5); improfile(original, [c1,c2], [r1,r2]);
ylabel('Nivel de Gris'); xlabel('Distancia en el Perfil');
subplot(2,4,6); improfile(ruidoGaussiano, [c1,c2], [r1,r2]);
ylabel('Nivel de Gris'); xlabel('Distancia en el Perfil');
subplot(2,4,7); improfile(ruidoGaussianoA, [c1,c2], [r1,r2]);
ylabel('Nivel de Gris'); xlabel('Distancia en el Perfil');
subplot(2,4,8); improfile(ruidoSalPimienta, [c1,c2], [r1,r2]);
ylabel('Nivel de Gris'); xlabel('Distancia en el Perfil');

%% Filtrado para reducción de ruido

h = ones(5,5) / 25; % equivalente a fspecial('average',5);
filtradaG = imfilter(ruidoGaussiano, h);
filtradaSP = imfilter(ruidoSalPimienta, h);
hG = fspecial('gaussian', 9, 2);
filtradaGG = imfilter(ruidoGaussiano, hG);
filtradaSPG = imfilter(ruidoSalPimienta, hG);

%%
%unsharp, suma original con sus detalles para realzarlos
I = imread('MosaicoAlhambra.jpg');
h = fspecial('unsharp')
I2 = imfilter(I, h);
figure;
subplot(1,2,1); imshow(I); title('Imagen original')
subplot(1,2,2); imshow(I2); title('Imagen filtrada')

%%
original = im2double(imread('eight.tif'));
%f=zeros(5); f(3,3)=1%datos

%h = [1,2,3; 4,5,6; 7,8,9]%filtro no simétrico
h=zeros(7); h(6,4)=1
corre=imfilter(original, h, 'corr');%correlacion
convol=imfilter(original, h, 'conv');%convolución
figure(1)
imshow(corre);title('correlada');
figure(2)
imshow(convol);title('convolucionada');

%%

%original = im2double(imread('MosaicoAlhambra.jpg'));
%h=zeros(7); h(6,4)=1

%% tamaños de imagen

f = ones(5);
h = [1,2,3; 4,5,6; 7,8,9]
imfilter(f, h, 'conv', 'same')
imfilter(f, h, 'conv', 'full')

%% uno de estos está mal

conv2(f, h, 'valid')
filter2(h, f, 'valid')

%%

imagen = im2double(imread('cameraman.tif'));
filtro = fspecial('average', 7);
filtradazero = imfilter(imagen, filtro, 'conv');
filtradasymm = imfilter(imagen, filtro, 'conv','symmetric');
filtradacirc = imfilter(imagen, filtro, 'conv','circular');
figure;
subplot(1,4,1); imshow(imagen); title('Imagen original')
subplot(1,4,2); imshow(filtradazero); title('relleno a cero')
subplot(1,4,3); imshow(filtradasymm); title('relleno simétrico')
subplot(1,4,4); imshow(filtradacirc); title('relleno circular')

%% fronteras imagen ruidosa frente a imagen sin ruido

original = im2double(imread('eight.tif'));
ruidosa = imnoise(original, 'gaussian', 0, 0.01);
sobely = fspecial('sobel')
sobelx = sobely';

%% 

fronteras = sqrt(imfilter(ruidosa, sobely, 'conv').^2 + imfilter(ruidosa, sobelx, 'conv').^2);
figure;
subplot(1,2,1); imshow(fronteras, []); title('sin filtrado')

%%

filtrada = imfilter(ruidosa, fspecial('gaussian', 5, 1));
%alternativamente se puede usar: filtrada = imgaussfilt(ruidosa, 1);
fronterasfilt = sqrt(imfilter(filtrada, sobely, 'conv').^2 + imfilter(filtrada, sobelx, 'conv').^2);
subplot(1,2,2); imshow(fronterasfilt, []); title('filtrando')
