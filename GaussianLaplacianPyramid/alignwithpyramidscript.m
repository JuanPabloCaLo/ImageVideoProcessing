%% Borramos variables y ventana de comandos
clear all
clc

%% Lectura de la imagen
% Nombre del fichero de imagen de entrada
Imagen13 = 'images/00911u.tif';

%Leer imagen
img = imread(Imagen13);
%Cada imagen tiene los tres colores pero se encuentran a diferentes alturas
%hay que dvidir la imagen en 3 según su altura para determinar que parte es
%azul, roja y verde.

%% Separación de canales
altura=floor(size(img,1)/3); %numero de pixeles correspondiente a cada parte
% Canales
Blue = img(1:altura,:);
Green = img(altura+1:2*altura,:);
Red = img(2*altura+1:3*altura,:);

%% Alineación imágenes
tic
rango = [2 2]; % rango de búsqueda en [y,x]
%rango = [30 30]; % rango de búsqueda en [y,x] para imágenes más grandes.
%Si dx/dy es menor del rango está bien cuadrada y se puede disminuir el limite
%para que tarde menos.
% Aumentar rango = Tarda más tiempo pero cuadra mejor
% Disminuir rango = Tarda menos tiempo pero cuadra peor
% Aumentar el rango cuando dy/dx ya es menor que el rango no tiene
% diferencia
[aB,dyB,dxB] = alinear_multiescala(Blue,Green,rango);
%Se puede ajustar otro rango para la alineación de rojo y verde y azul
%verde
[aR,dyR,dxR] = alinear_multiescala(Red,Green,rango);
aG = Green;
aG(:,3768) = [];
aG(3254,:) = [];
%aG=padarray(aG, abs(size(aR)-size(Green)), 'replicate', 'post');
%aG=padarray(aG, 1, 'replicate', 'post');
%aB=padarray(aB, abs(size(aB)-size(aG)), 'replicate', 'post');
%aR=padarray(aR, abs(size(aR)-size(aG)), 'replicate', 'post');
toc % mostrar el tiempo 
% unir las 3 imágenes
RGB = cat(3,aR,aG,aB);

%% Mejora del contraste

%Se crea la función
y(1:175) = 0:174;
y(176:200) = 255;
y(201:256) = 200:255;
%figure(1)
%subplot(1,3,2), plot(y), axis tight, axis square, title('Función aumento de contraste');

%Se aplica a la imagen
%figure(1)
%RGB2 = intlut(RGB,uint8(y));
%subplot(1,3,3), imshow(RGB2), title('Imagen Ajustada');
%truesize
%% Mostrar imágenes

figure(1);
% las 3 bandas sin alinear
subplot(1,2,1);
imshow(cat(3,Red,Green,Blue));
title('Imagen sin alinear')
% las 3 bandas alineadas
subplot(1,2,2);
imshow(RGB);
title('Imagen alineada');
truesize

%% Guardado de imágenes

imwrite(RGB,'resultado1.tif');
%Hay que indicarle el formato, para ello se pone un formato válido
% terminando el fichero por .formato, por ejemplo .jpg .tiff .jpeg etc


%P1.2
%Modo auto: La camara hace todo
%Modo p: Permite algunos cambios como flash o no. Varía apertura y
%velocidad.
%Modo a(av):Semiautomatico. Fijas velocidad y se calcula apertura. (Captura
%del movimiento).
%Modo v(tv): Semiautomático. Fijas apertura y se calcula velocidad 
%(Profundidad de campo).






