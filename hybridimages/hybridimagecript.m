%% Practica2 Procesamiento de Video Digital Autor: Juan Pablo Cano López
%Imágenes híbridas

%% Borrado de variables
clear all
clc

%% Lectura de imágenes
imagen1 = im2double(imread('images/einstein.bmp'));
imagen2 = im2double(imread('images/marilyn.bmp'));

%Pairs are cat-dog, marilyn-einstein, fish-submarine, bicycle-motorcycle
%and myhand-lion
%% Elección imagen para aplicar transferencia de color
elija="Que imagen marcará los resultados de transferencia de color";
%La de destino
elige=input(elija);
%elige='1';
if strcmp(elige,'uno')
    disp("opcion1")
    transferida=transferenciacolor(imagen2,imagen1);
    %1 origen 2 destino
    %Si la imagen 1 es la que marca el color será la de destino
    imagen2= transferida;
elseif strcmp(elige,'dos')
    disp("opcion2")
    transferida=transferenciacolor(imagen1,imagen2);
    imagen1=transferida;
    %1 origen 2 destino
    %Si la imagen 2 es la que marca el color será la de destino
    disp(transferida);
else
    disp("No habrá transferencia de color")
end 
%figure(100)
%imshow(transferida);
figure(101)
imshow(imagen1);
figure(110)
imshow(imagen2);
%% Bucle de filtros bajas frecuencias
fcorte= 0;
tamano = 0;
x=0;
fig=1;
for i=3:3:15
    prompt="Pulse tecla para siguiente";
    fcorte=i;
    tamano=(3*fcorte*2)+1;
    filtro=fspecial('gaussian',tamano, fcorte);
    
    bajas_frecuencias = imfilter(imagen1, filtro);
    figure(fig)
    subplot(1,3,1); imshow(bajas_frecuencias); title(['Imagen de bajas frecuencias ',num2str(fig),' ']);
    truesize
    
    fig=fig+1;
    x=input(prompt);
end
prompt="Elija el filtro según el número de la figura"
nfiltrob=input(prompt);
close all hidden;
fcortefb=3*nfiltrob;
tamanofb=(3*fcortefb*2)+1;
filtrofb=fspecial('gaussian',tamanofb, fcortefb);
bajas_frecuenciasfb = imfilter(imagen1, filtrofb);
figure(1)
subplot(1,3,1); imshow(bajas_frecuenciasfb); title(['Imagen de bajas frecuencias final']);
truesize

%% Bucle de filtros altas frecuencias
fcortea= 0;
tamanoa = 0;
y=0;
feg=1;
for i=3:3:15
    prompt="Pulse tecla para siguiente";
    fcortea=i;
    tamanoa=(3*fcorte*2)+1;
    filtroa=fspecial('gaussian',tamanoa, fcortea);
    
    bajas_frecuenciasalt= imfilter(imagen2, filtroa);
    altas_frecuencias = imagen2-bajas_frecuenciasalt;
    figure(feg)
    subplot(1,3,1); imshow(altas_frecuencias+0.5); title(['Imagen de altas frecuencias ',num2str(feg),' ']);
    truesize
    
    feg=feg+1;
    y=input(prompt);
end
prompt="Elija el filtro según el número de la figura"
nfiltroa=input(prompt);
close all hidden;
fcortefa=3*nfiltroa;
tamanofa=(3*fcortefa*2)+1;
filtrofa=fspecial('gaussian',tamanofa, fcortefa);
bajas_frecuenciasfa = imfilter(imagen2, filtrofa);
altas_frecuenciasfa = imagen2-bajas_frecuenciasfa;
figure(2)
subplot(1,3,1); imshow(altas_frecuenciasfa+0.5); title(['Imagen de altas frecuencias final']);
truesize

%% Imagen híbrida
imagen_hibrida = bajas_frecuenciasfb + altas_frecuenciasfa;

figure(3)
subplot(1,3,3); imshow(imagen_hibrida); title('Imagen híbrida');
truesize

vis = vis_hybrid_image(imagen_hibrida);
figure(4); imshow(vis); 
title('Imagen híbrida a diferentes escalas')

%% Guardado de imágenes
imwrite(bajas_frecuenciasfb, 'bajas_frecuencias.jpg', 'quality', 95);
imwrite(altas_frecuenciasfa + 0.5, 'altas_frecuencias.jpg', 'quality', 95);
imwrite(imagen_hibrida, 'imagen_hibrida.jpg', 'quality', 95);
imwrite(vis, 'imagen_hibrida_escalas.jpg', 'quality', 95);

%% Plot de los filtros

figure(5)
bar3(filtrofb,'b'), title('Filtro f bajas gaussiano como gráfico 3D');
figure(6)
bar3(filtrofa,'b'), title('Filtro f altas gaussiano como gráfico 3D');
disp('Ha terminado el programa, gracias por usarlo');

%% plot f baja
figure(7)
subplot(1,3,1); imshow(bajas_frecuenciasfb); title(['Imagen de bajas frecuencias final']);
truesize