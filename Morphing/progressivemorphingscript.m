nombre1 = 'juampi2';
nombre2 = 'avatar';
metodo = 'a'; % 'a' para af�n, 'b' para baricentro

%% Leer las dos im�genes
imagen1 = im2double(imread(['examples/',nombre1,'.jpg']));
imagen2 = im2double(imread(['examples/',nombre2,'.png']));

% Las dos im�genes tienen que ser del mismo tama�o. Forzarlo reescalando la
% imagen 2 al tama�o de la imagen1
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

% A�ado las esquinas de cada lado a los puntos.
% Solo por mejorar el aspecto de la iamgen resultante, que no tendr� ceros
% en los bordes de la imagen

esquinas = [1,1; W,1; 1,H; W,H]; %Las esquinas se a�aden para que toda la imagen est� cubierta
puntos1 = [esquinas ; puntos1];
puntos2 = [esquinas ; puntos2];

%% Computar una triangulaci�n de Delaunay a partir de las correspondencias en
% el punto medio

puntos_media = (puntos1 + puntos2)./2;
triangulos = delaunay(puntos_media);
a=1;
%% Computar el morphing para alfa = 0.5
if strcmp(metodo,'a')
    for i=0.05:0.05:1
    imagen_media = affinemorphing(imagen1, puntos1, imagen2, puntos2, triangulos, i);
    
    figure(a);
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
    
    
    %str='morphing'+a+'.png';
    str=sprintf('morphingjpavatar%d.png',a);
    %newstrr=strrep(str,'-', a);
    %imwrite(imagen_media, newstrr+".png");
    imwrite(imagen_media, str);
    a=a+1;
    end
elseif strcmp(metodo,'b')
    imagen_media = baricentricmorphing(imagen1, puntos1, imagen2, puntos2, triangulos, 0.65);
    %Esto es solo la media, luego se deben calcular 25, luego se debe
    %guardar como un video (practica 0)
else
    error('M�todo no conocido');
end