clear ; close all;

%% Configuracion

ficheros = 'yosemite/yosemite/yosemite%d.jpg';
iminit = 1;
imfinal = 4;
numImagenes = imfinal-iminit+1;

%% Leer la primera imagen
I = imread(sprintf(ficheros, iminit));

% Preprocesamiento: convertir a escala de grises
imgGris = rgb2gray(I); %Primera imagen

%% Detectar puntos singulares y extraer descriptores
%%%% COMPLETAR AQUI
puntos = detectSURFFeatures(imgGris);
[caract, puntos] = extractFeatures(imgGris, puntos); %Todo esto es de la primera
% imagen
%%%% HASTA AQUI

%% Inicializar la transformación de la primera imagen a la identidad
transformacion(iminit) = projective2d(eye(3));

%% Estimar la transfomación para el resto de las imágenes
%Cada nueva imagen se calcula respecto a la anterior
for i = iminit+1:imfinal % Puesto que la imagen iminit ya la hemos procesado
    % guardar los datos de la imagen anterior.
    puntosAnterior = puntos;
    caractAnterior = caract;
    
    % Leer y preprocesar la siguiente imagen 
    I = imread(sprintf(ficheros, i));%siguientes imágenes
    imgGris = rgb2gray(I);
    
    % Detectar puntos singulares y extraer descriptores
    %%%% COMPLETAR AQUI
    puntos = detectSURFFeatures(imgGris);
    [caract, puntos] = extractFeatures(imgGris, puntos);
    %%%% HASTA AQUI

    % Emparejar la imagen actual y la anterior
    %%%% COMPLETAR AQUI
    %Unique es para que solo devuelva puntos unívocos
    %puntos
    IndicesParejas = matchFeatures(caract, caractAnterior, 'Unique', true);
    PuntosEmparejados = puntos(IndicesParejas(:,1),:);
    PuntosEmparejadosAnterior = puntosAnterior(IndicesParejas(:,2),:);
    %%%% HASTA AQUI

    % Estimar la transformación de la imagen actual a la imagen anterior
    %%%% COMPLETAR AQUI
    %Se detecta la homografía. Más intentos mejor transformación,  se puede
    %cambiar el número de intentos para conseguir más confianza
    transformacion(i) = estimateGeometricTransform( PuntosEmparejados, PuntosEmparejadosAnterior , ...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    %%%% HASTA AQUI

    % Calcular la transformación respecto a la primera imagen como
    % T(1) * ... * T(i-1) * T(i)
    % Esto es necesario para que todas las imágenes compartan el mismo
    % marco de referencia
    %La transformación de la imagen 3 se calcula a partir de la dos pero se
    %debe colocar a partir de la imagen 1. Las transformaciones se pueden
    %aplicar en secuencia, se pueden componer. La transformación de la
    %imagen 3 a la 1 es tranformacion(T2->T1)*transformación(T3>T2).
    %Esta linea siguiente es lo que describe. Para una cuarta imagen sería
    %lo mismo.
    transformacion(i).T = transformacion(i-1).T * transformacion(i).T;
    %tranformación(i).T son matrices de transformación, transformación(i)
    %no es una matriz. La T de teoria es la T' de matlab porque calcula
    %(x' y')=(x y)*(T').
end


%% Centrar el panorama

% No es necesario pero mejora el aspecto de la imagen de salida
%Esto se refiere a poner la imagen del medio como referencia
%Inverted form te saca la transformación inversa. Para que salga bien hacer
%cosas con muy poco ángulo y con cosas lejanas

%% Crear el panorama

% Calcular la posición de cada imagen en coordenadas del mundo
tamano = size(I); % Todas las imágenes son del mismo tamaño
for i = 1:numel(transformacion)           
    [xlim(i,:), ylim(i,:)] = outputLimits(transformacion(i), [1 tamano(2)], [1 tamano(1)]);    
end
%para cada transformación se calculan los límites
% Calcular los límites de la imagen de salida
xMin = min(xlim(:));
xMax = max(xlim(:));
yMin = min(ylim(:));
yMax = max(ylim(:));
xLimites = [xMin xMax];
yLimites = [yMin yMax];
% Calcular las dimensiones de la imagen de salida
ancho  = round(xMax - xMin + 1);
alto = round(yMax - yMin + 1);
% Crear una vista o referencia entre las coordenadas del mundo (que pueden 
% ser negativas) y la imagen (que va de 1 a ancho y de 1 a alto)

VistaPanorama = imref2d([alto ancho], xLimites, yLimites);
% Poner todas las imágenes en el panorama
panorama = zeros([alto ancho size(I,3)], 'like', I);

    % Leer la imagen
    I1 = imread(sprintf(ficheros, 1));
    I2 = imread(sprintf(ficheros, 2));
    I3 = imread(sprintf(ficheros, 3));
    I4 = imread(sprintf(ficheros, 4));
    
    % Posicionar la imagen en la vista del panorama (transformándola).
    %%%% COMPLETAR AQUI
    warpedImage1 = imwarp(I1, projective2d(eye(3)),'OutputView', VistaPanorama);
    %tamaño imagen resultante con la imagen 1 en una posición
    warpedImage2 = imwarp(I2, transformacion(2),'OutputView', VistaPanorama);
    warpedImage3 = imwarp(I3, transformacion(3),'OutputView', VistaPanorama);
    warpedImage4 = imwarp(I4, transformacion(4),'OutputView', VistaPanorama);
    %tamaño imagen resultante con la imagen 2 en la posición
    %correspondiente
    % Fundir las imágenes.
    %Mezclar imágenes
    %lo puedes hacer con el valor máximo, ya que el fondo es negro (0), si
    %cogieses la media saldría borroso.
    panorama1= max(warpedImage1, warpedImage2);
    panorama2= max(panorama1, warpedImage3);
    panorama3= max(panorama2, warpedImage4);
    %panorama actual + segunda imagen + tercera imagen + cuarta imagen etc
    %los limites varían mucho. Proyectar sobre un cilindro podría ser una
    %solución pero no lo hacemos. Para minimizar el problema podríamos
    %minimizar la del centro, no la de un extremo. Quedará como una
    %mariposa. %Imagen de referencia identidad-> Multiplicas por T-1(3) todo 
    
    %%%% HASTA AQUI


% mostrar el panorama
figure; imshow(panorama3)

%Explicación unión 
%Imagen1 referencia, fija, queremos mover la imagen 2 transformada (tiene forma de trapecio) a la misma posición
%bueno es rectangular pero solo tiene datos en ese trapecio, los triangulos
%que quedan son negros. Debemos crear una nueva imagen grande con las dos
%imágenes unidas y todo negro. Outputlimits te da un tamaño de salida ylim1, xlim2 para
%un tamaño de entrada t1,t2. 
%Imagen 1 va de 1 hasta t1, t2
%Imagen 2 sin transformar 1->t1,t2
%Imagen 2 con la transformación va de ylim(1), xlim(1) a ylim(2), xlim(2)
%Esquinas, el mínimo entre la imagen 1 y la 2 transformada,
%Creas ese nuevo mundo, colocas esas imagenes en ese mundo y luego las
%proyectas sobre una imagen

%Secuencia1 1,2,3,4 secuencia2 5, 6, 7 