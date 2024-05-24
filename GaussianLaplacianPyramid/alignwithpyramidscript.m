%% Borramos variables y ventana de comandos
clear all
clc

%% Lectura de la imagen
% Nombre del fichero de imagen de entrada
Imagen13 = 'images/00911u.tif';

%Leer imagen
img = imread(Imagen13);
%Cada imagen tiene los tres colores pero se encuentran a diferentes alturas
%hay que dvidir la imagen en 3 seg�n su altura para determinar que parte es
%azul, roja y verde.

%% Separaci�n de canales
altura=floor(size(img,1)/3); %numero de pixeles correspondiente a cada parte
% Canales
Blue = img(1:altura,:);
Green = img(altura+1:2*altura,:);
Red = img(2*altura+1:3*altura,:);

%% Alineaci�n im�genes
tic
rango = [2 2]; % rango de b�squeda en [y,x]
%rango = [30 30]; % rango de b�squeda en [y,x] para im�genes m�s grandes.
%Si dx/dy es menor del rango est� bien cuadrada y se puede disminuir el limite
%para que tarde menos.
% Aumentar rango = Tarda m�s tiempo pero cuadra mejor
% Disminuir rango = Tarda menos tiempo pero cuadra peor
% Aumentar el rango cuando dy/dx ya es menor que el rango no tiene
% diferencia
[aB,dyB,dxB] = alinear_multiescala(Blue,Green,rango);
%Se puede ajustar otro rango para la alineaci�n de rojo y verde y azul
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
% unir las 3 im�genes
RGB = cat(3,aR,aG,aB);

%% Mejora del contraste

%Se crea la funci�n
y(1:175) = 0:174;
y(176:200) = 255;
y(201:256) = 200:255;
%figure(1)
%subplot(1,3,2), plot(y), axis tight, axis square, title('Funci�n aumento de contraste');

%Se aplica a la imagen
%figure(1)
%RGB2 = intlut(RGB,uint8(y));
%subplot(1,3,3), imshow(RGB2), title('Imagen Ajustada');
%truesize
%% Mostrar im�genes

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

%% Guardado de im�genes

imwrite(RGB,'resultado1.tif');
%Hay que indicarle el formato, para ello se pone un formato v�lido
% terminando el fichero por .formato, por ejemplo .jpg .tiff .jpeg etc


%P1.2
%Modo auto: La camara hace todo
%Modo p: Permite algunos cambios como flash o no. Var�a apertura y
%velocidad.
%Modo a(av):Semiautomatico. Fijas velocidad y se calcula apertura. (Captura
%del movimiento).
%Modo v(tv): Semiautom�tico. Fijas apertura y se calcula velocidad 
%(Profundidad de campo).






