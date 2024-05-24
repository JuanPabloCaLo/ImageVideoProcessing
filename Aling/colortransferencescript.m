%% Borramos variables y ventana de comandos
clear all
clc
%operaci�n nivel pixel .*, elevar al cuadrado igual

%% Lectura de la imagen
% Nombre del fichero de imagen de entrada
%Leer imagen
Imagen1 = 'images/propia2.png';
Imagen2 = 'images/propia1.png';
imgo = imread(Imagen1);
imgd = imread(Imagen2);

%% Aplicamos Reinhard

imgsalida = reinhard(imgo, imgd);

%% Visualizaci�n de imagenes
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
% imagen origen, de forma que la imagen origen tiene una codificaci�n de
% color similar a la de destino.

%La imagen se convierte a reales en las lineas 28 y 40 porque si no se hace
%puede haber errores de desbordamiento o n�meros negativos en las variables
%uint8, lo que conllevar�a resultados err�neos. Tambi�n surgir�an problemas
%por el truncamiento de las variables uint8 en ciertas operaciones

%Casos de fallo
%Si los colores de la imagen no siguen una distribuci�n normal entonces
%este ajuste no es v�lido, si cada imagen siguiera una distribuci�n
%diferente habr�a que encontrar otro ajuste distinto, ya que el realizado
%no es v�lido
