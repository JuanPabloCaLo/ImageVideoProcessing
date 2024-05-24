%% Borramos variables y ventana de comandos
clear all
clc
%% Leemos la imagen
I=imread('coins.png');
RGB=imread('peppers.png');
[X,map]=imread('trees.tif');
%% Guardado en memoria
%Señal digitalizada 
%Tamaño números 2^número de bits

%Audio standard comercial: 16 bits enteros con signo 32768--32768
%44100m/s mono 1x44100
%stereo (2 canales) 44100x2 
%20 audio profesional.
%1s de audio 44100x1

%Imágenes
%Muestra similar a pixel, pixel, nivel de grises color etc.
%Matriz de pixeles
%246x300 uint8
%Muestra = pixel. Imagen matrix FxC cada elemento = 1 pixel. Diferente
%nivel de grises: 256 niveles (8 bits).
%Imagen color, 1 pixel 3 valores RGB. FxC x 3 ARRAY
%Imagen estrictamente en blanco y negro FxC uint8 (256 negro 0 blanco)
%Imagen gift: color indexado (existen un conjunto de colores predefinidos
%en una paleta uint8 (0-31(hasta 256) paleta) 32 valores tabla rgb 
%definidos en la tabla
%Impresora no funciona en RGB (cian magenta y amarillo) 
%Televisión Luminosidad(Y)(0-255) (escala de grises) +
%CBCR(color)(diferencias respecto al rojo verde y azul verde)(-128,128)
%Todas las imagenes se transforman a números reales porque sino operar con
%ellas produce errores por las propiedades del tipo de dato int8, dado
%im2double(0-1)

%video 25 fotogramas(imágenes x segundo) otra dimensión más 
%(número de fotogramas)* estructura anterior
%Matlab-> cada fotograma (mapa de color) + estructura movie con datos 
%fotograma. Mov1, Mov2 fotogramas. 

%% Guardado en disco
%Audio-> wav(sin comprimir)44100 x 2 x 16 1s 1,411 Kbps,
%mp3(compresión con pérdidas(sin distorsión) 128-192 Kbps,
%oac 96-128 Kbps pero perceptualmente mejor que mp3
%3gp(similar a oac)

%Imagen->
%bmp-> Equivalente al wav, sin compresión
%jpg-> Equivalente al mp3
%jp2-> Avance de jpg que no usa tf coseno discreto sino otra, wavelength
%png-> (portable network ) Algoritmo de compresión que utiliza zip 
%tiff-> Guarda metadatos a parte de la imagen en si (captación de imagen)
%puede guardar incluso varias imágenes 
%gift -> Compresión sin pérdidas para menos de 256 colores, eficiente lzw
% estaba patentado el formato de compresión pero se liberó
%cr2 crw-> camara
%nek-> camara
%orf-> camara
%cbng-> camara

%Video->
%No son formatos de video, son contenedores de video, dentro de cada
%uno el audio y el video tiene diferentes formatos
%mp4
%avi
%mkv
%mov -> Admite casi todo

%% Visualización datos fichero
info=imfinfo('coins.png');
info2=imfinfo('peppers.png');
info3=imfinfo('trees.tif');
%% Conversión de imágenes
X_rgb=ind2rgb(X,map); %Convierte de imagen con color indexado a RGB)
%No se puede utilizar imfinfo porque está guardada en memoria y no
%con un formato de guardado en disco.
%Tiene las mismas dimensiones que una imagen rgb normal

X_gray=ind2gray(X,map); %Convierte imagen de color indexado a escala de
%colores

%Comprobamos(aunque con ver que son int8 es suficiente) que el minimo es
%0 y el máximo si llega 255
maximogray=max(X_gray(:));
minimogray=min(X_gray(:));
%Si no se usa : aparece un vector con el numero de columnas y el máximo
%valor tomado en escala de grises por los pixeles de esa columna (en
%algunos casos no llega a 256)

%Conversión de los datos de  X_gray a double en lugar de uint8
X_gray_dbl=im2double(X_gray); 
% el rango es el mismo pero ahora cada número es double en lugar de uint8
%los valores comprenden el rango de 0 a 1

%Conversion de datos RGB a escala de grises (al revés no se puede
%lógicamente)
imgRGB_grises=rgb2gray(RGB);

%% Visualización de imágenes
figure(1);
imshow(I), impixelinfo %Imagen monedas escala de grises
figure(2);
imshow(X,map), impixelinfo %Imagen tif arboles

%% Visualización del video
%traffic.avi
file_name = 'xylophone.mpg';
readerobj = VideoReader(file_name);
get(readerobj);
numFrames=get(readerobj,'NumberOfframes');
numFrames=readerobj.NumberOfframes;
vidFrames = read(readerobj);
vidFramesshort=read(readerobj, [3 10]);
figure(3);
imshow(vidFramesshort(:,:,:,1));
montage(vidFramesshort)
