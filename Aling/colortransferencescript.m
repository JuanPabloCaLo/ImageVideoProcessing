%% Borramos variables y ventana de comandos
clear all
clc
%operación nivel pixel .*, elevar al cuadrado igual

%% Lectura de la imagen
% Nombre del fichero de imagen de entrada
%Leer imagen
Imagen1 = 'images/propia2.png';
Imagen2 = 'images/propia1.png';
imgo = imread(Imagen1);
imgd = imread(Imagen2);

%% Aplicamos Reinhard

imgsalida = reinhard(imgo, imgd);

%% Visualización de imagenes
figure(1);
imshow(imgo);
figure(2);
imshow(imgd);
figure(3);
imshow(imgsalida);
%figure(3);
%imshow(imgsalida);
% Es tranferencia de color, no es cambiar el color de la imagen destino por
% el de la origen sino que se asignan los colores de la imagen destino a la
% imagen origen, de forma que la imagen origen tiene una codificación de
% color similar a la de destino.

%La imagen se convierte a reales en las lineas 28 y 40 porque si no se hace
%puede haber errores de desbordamiento o números negativos en las variables
%uint8, lo que conllevaría resultados erróneos. También surgirían problemas
%por el truncamiento de las variables uint8 en ciertas operaciones

%Casos de fallo
%Si los colores de la imagen no siguen una distribución normal entonces
%este ajuste no es válido, si cada imagen siguiera una distribución
%diferente habría que encontrar otro ajuste distinto, ya que el realizado
%no es válido
