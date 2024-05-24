nombre1 = 'juampi2';
nombre2 = 'avatar';
metodo = 'a'; % 'a' para afín, 'b' para baricentro

%% Leer las dos imágenes
imagen1 = im2double(imread(['examples/',nombre1,'.jpg']));
imagen2 = im2double(imread(['examples/',nombre2,'.png']));

% Las dos imágenes tienen que ser del mismo tamaño. Forzarlo reescalando la
% imagen 2 al tamaño de la imagen1
[H,W,C]=size(imagen1);
imagen2=imresize(imagen2,[H,W]);

%% Leer los puntos, si existen
if exist(['examples/shapes/',nombre1,'.xy'], 'file')
    puntos1 = dlmread(['examples/shapes/',nombre1,'.xy']);
    if exist(['examples/shapes/',nombre2,'.xy'], 'file')
        puntos2 = dlmread(['examples/shapes/',nombre2,'.xy']);
    else
        % Si existe puntos1 pero no puntos2, pongo puntos2 = puntos1 para
        % tener algo desde donde empezar y llamo a cpselect para moverlos y
        % los guardo
        puntos2 = puntos1;        
        [puntos1, puntos2] = cpselect(imagen1, imagen2, puntos1, puntos2, 'Wait', true);
        dlmwrite(['examples/shapes/',nombre2,'.xy'], puntos2);
    end
else
    % Seleccionar los puntos en correspondencia
    [puntos1, puntos2] = cpselect(imagen1, imagen2, 'Wait', true);
    dlmwrite(['examples/shapes/',nombre1,'.xy'], puntos1);
    dlmwrite(['examples/shapes/',nombre2,'.xy'], puntos2);
end

% Añado las esquinas de cada lado a los puntos.
% Solo por mejorar el aspecto de la iamgen resultante, que no tendrá ceros
% en los bordes de la imagen

esquinas = [1,1; W,1; 1,H; W,H]; %Las esquinas se añaden para que toda la imagen esté cubierta
puntos1 = [esquinas ; puntos1];
puntos2 = [esquinas ; puntos2];

%% Computar una triangulación de Delaunay a partir de las correspondencias en
% el punto medio

puntos_media = (puntos1 + puntos2)./2;
triangulos = delaunay(puntos_media);

%% Computar el morphing para alfa = 0.5
if strcmp(metodo,'a')
    imagen_media = affinemorphing(imagen1, puntos1, imagen2, puntos2, triangulos, 0.5);
elseif strcmp(metodo,'b')
    imagen_media = baricentricmorphing(imagen1, puntos1, imagen2, puntos2, triangulos, 0.5);
    %Esto es solo la media, luego se deben calcular 25, luego se debe
    %guardar como un video (practica 0)
else
    error('Método no conocido');
end

%% Muestra las imágenes
figure(1);
subplot(1,3,1); 
imshow(imagen1);
axis image;
title('Imagen 1')

subplot(1,3,3); 
imshow(imagen2);
axis image;
title('Imagen 2')

subplot(1,3,2);
imshow(imagen_media);
axis image;
title('Imagen media')


%% Muestra las imágenes y las triangulaciones
figure(2);
subplot(1,3,1); 
imshow(imagen1);
hold on;
triplot(triangulos, puntos1(:,1), puntos1(:,2), 'r');
axis image;
title('Imagen 1')

subplot(1,3,3); 
imshow(imagen2);
hold on;
triplot(triangulos, puntos2(:,1), puntos2(:,2), 'r');
axis image;
title('Imagen 2')

subplot(1,3,2);
imshow(imagen_media);
hold on;
triplot(triangulos, puntos_media(:,1), puntos_media(:,2), 'r');
axis image;
title('Imagen media')

