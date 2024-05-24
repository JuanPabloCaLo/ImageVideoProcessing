%% Borramos variables y ventana de comandos
clear all
clc

%% Lectura de la imagen
% Nombre del fichero de imagen de entrada
Imagen1 = 'images/01657u.jpg';
Imagen2 = 'images/01861a.jpg';
Imagen3 = 'images/00149v.jpg';
Imagen4 = 'images/31421v.jpg';
Imagen5 = 'images/00154v.jpg';
Imagen6 = 'images/00458u.tif'; 

%Leer imagen
img = imread(Imagen4);
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
rango = [20 20]; % rango de búsqueda en [y,x]
%rango = [30 30]; % rango de búsqueda en [y,x] para imágenes más grandes.
%Si dx/dy es menor del rango está bien cuadrada y se puede disminuir el limite
%para que tarde menos.
% Aumentar rango = Tarda más tiempo pero cuadra mejor
% Disminuir rango = Tarda menos tiempo pero cuadra peor
% Aumentar el rango cuando dy/dx ya es menor que el rango no tiene
% diferencia
[aB,dyB,dxB] = align(Blue,Green,rango);
%Se mueve hasta encontrar donde cuadra mejor (menor error cuadrático)
%rango =intervalo de desplazo en píxeles
%dyB, dXB Desplazamiento. Si dyB o dxB >= máximo del rango-> rango corto
%Se puede ajustar otro rango para la alineación de rojo y verde y azul
%verde
[aR,dyR,dxR] = align(Red,Green,rango);
%dyB, dXB Desplazamiento. Si dyB o dxB >= máximo del rango-> rango corto
%En y puede haber más desplazamiento que en x
aG = Green;%referencia
toc % mostrar el tiempo 
% unir las 3 imágenes
RGB = cat(3,aR,aG,aB);%Imagen alineada % El 3 es la dimensión
%rango grande -> más lento, 15/15 es 15*15, bajar un poco el rango implica
%un cambio significativo

%% Mejoras, contraste

%Se crea la función

%Esta ilumina la imagen mucho
%y(1:175) = 100:274;
%y(176:200) = 275:299;
%y(201:256) = 300:355;

%Esta oscurece la imagen mucho
%y(1:175) = -200:-26;
%y(176:200) = -24:0;
%y(201:256) = 1:56;

%Esta ilumina la imagen un poco

%y(1:175) = 20:250;
%y(176:200) = 250:256;
%y(201:256) = 256:256;

%y=linspace(0,200, 256);% Baja el contraste, cuanta más pendiente, más contraste
y=linspace(0,300, 256);% Aumenta el contraste, cuanta más pendiente, más contraste
figure(1)
subplot(1,3,2), plot(y), axis([0 400 0 400]), title('Función cambio de contraste');

%Se aplica a la imagen
figure(2)
RGB2 = intlut(RGB,uint8(y));
subplot(1,3,3), imshow(RGB2), title('Imagen Ajustada');
truesize

%% Mejora bordes 
RGB3=RGB2(20:310,20:370, 1:3); %Cortando por lo sano
figure(3)
imshow(RGB3), title('Imagen sin borde');
%Para hacerlo bien tendré que detectar el borde viendo que una componente
%R G B es cercana a 0 en ese punto 
%% Mostrar imágenes

figure(4);
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

imwrite(RGB,'resultado1.jpg');
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






