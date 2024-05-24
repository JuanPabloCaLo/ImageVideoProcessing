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

%% Inicializar la transformaci�n de la primera imagen a la identidad
transformacion(iminit) = projective2d(eye(3));

%% Estimar la transfomaci�n para el resto de las im�genes
%Cada nueva imagen se calcula respecto a la anterior
for i = iminit+1:imfinal % Puesto que la imagen iminit ya la hemos procesado
    % guardar los datos de la imagen anterior.
    puntosAnterior = puntos;
    caractAnterior = caract;
    
    % Leer y preprocesar la siguiente imagen 
    I = imread(sprintf(ficheros, i));%siguientes im�genes
    imgGris = rgb2gray(I);
    
    % Detectar puntos singulares y extraer descriptores
    %%%% COMPLETAR AQUI
    puntos = detectSURFFeatures(imgGris);
    [caract, puntos] = extractFeatures(imgGris, puntos);
    %%%% HASTA AQUI

    % Emparejar la imagen actual y la anterior
    %%%% COMPLETAR AQUI
    %Unique es para que solo devuelva puntos un�vocos
    %puntos
    IndicesParejas = matchFeatures(caract, caractAnterior, 'Unique', true);
    PuntosEmparejados = puntos(IndicesParejas(:,1),:);
    PuntosEmparejadosAnterior = puntosAnterior(IndicesParejas(:,2),:);
    %%%% HASTA AQUI

    % Estimar la transformaci�n de la imagen actual a la imagen anterior
    %%%% COMPLETAR AQUI
    %Se detecta la homograf�a. M�s intentos mejor transformaci�n,  se puede
    %cambiar el n�mero de intentos para conseguir m�s confianza
    transformacion(i) = estimateGeometricTransform( PuntosEmparejados, PuntosEmparejadosAnterior , ...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    %%%% HASTA AQUI

    % Calcular la transformaci�n respecto a la primera imagen como
    % T(1) * ... * T(i-1) * T(i)
    % Esto es necesario para que todas las im�genes compartan el mismo
    % marco de referencia
    %La transformaci�n de la imagen 3 se calcula a partir de la dos pero se
    %debe colocar a partir de la imagen 1. Las transformaciones se pueden
    %aplicar en secuencia, se pueden componer. La transformaci�n de la
    %imagen 3 a la 1 es tranformacion(T2->T1)*transformaci�n(T3>T2).
    %Esta linea siguiente es lo que describe. Para una cuarta imagen ser�a
    %lo mismo.
    transformacion(i).T = transformacion(i-1).T * transformacion(i).T;
    %tranformaci�n(i).T son matrices de transformaci�n, transformaci�n(i)
    %no es una matriz. La T de teoria es la T' de matlab porque calcula
    %(x' y')=(x y)*(T').
end


%% Centrar el panorama

% No es necesario pero mejora el aspecto de la imagen de salida
%Esto se refiere a poner la imagen del medio como referencia
%Inverted form te saca la transformaci�n inversa. Para que salga bien hacer
%cosas con muy poco �ngulo y con cosas lejanas

%% Crear el panorama

% Calcular la posici�n de cada imagen en coordenadas del mundo
tamano = size(I); % Todas las im�genes son del mismo tama�o
for i = 1:numel(transformacion)           
    [xlim(i,:), ylim(i,:)] = outputLimits(transformacion(i), [1 tamano(2)], [1 tamano(1)]);    
end
%para cada transformaci�n se calculan los l�mites
% Calcular los l�mites de la imagen de salida
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
% Poner todas las im�genes en el panorama
panorama = zeros([alto ancho size(I,3)], 'like', I);

    % Leer la imagen
    I1 = imread(sprintf(ficheros, 1));
    I2 = imread(sprintf(ficheros, 2));
    I3 = imread(sprintf(ficheros, 3));
    I4 = imread(sprintf(ficheros, 4));
    
    % Posicionar la imagen en la vista del panorama (transform�ndola).
    %%%% COMPLETAR AQUI
    warpedImage1 = imwarp(I1, projective2d(eye(3)),'OutputView', VistaPanorama);
    %tama�o imagen resultante con la imagen 1 en una posici�n
    warpedImage2 = imwarp(I2, transformacion(2),'OutputView', VistaPanorama);
    warpedImage3 = imwarp(I3, transformacion(3),'OutputView', VistaPanorama);
    warpedImage4 = imwarp(I4, transformacion(4),'OutputView', VistaPanorama);
    %tama�o imagen resultante con la imagen 2 en la posici�n
    %correspondiente
    % Fundir las im�genes.
    %Mezclar im�genes
    %lo puedes hacer con el valor m�ximo, ya que el fondo es negro (0), si
    %cogieses la media saldr�a borroso.
    panorama1= max(warpedImage1, warpedImage2);
    panorama2= max(panorama1, warpedImage3);
    panorama3= max(panorama2, warpedImage4);
    %panorama actual + segunda imagen + tercera imagen + cuarta imagen etc
    %los limites var�an mucho. Proyectar sobre un cilindro podr�a ser una
    %soluci�n pero no lo hacemos. Para minimizar el problema podr�amos
    %minimizar la del centro, no la de un extremo. Quedar� como una
    %mariposa. %Imagen de referencia identidad-> Multiplicas por T-1(3) todo 
    
    %%%% HASTA AQUI


% mostrar el panorama
figure; imshow(panorama3)

%Explicaci�n uni�n 
%Imagen1 referencia, fija, queremos mover la imagen 2 transformada (tiene forma de trapecio) a la misma posici�n
%bueno es rectangular pero solo tiene datos en ese trapecio, los triangulos
%que quedan son negros. Debemos crear una nueva imagen grande con las dos
%im�genes unidas y todo negro. Outputlimits te da un tama�o de salida ylim1, xlim2 para
%un tama�o de entrada t1,t2. 
%Imagen 1 va de 1 hasta t1, t2
%Imagen 2 sin transformar 1->t1,t2
%Imagen 2 con la transformaci�n va de ylim(1), xlim(1) a ylim(2), xlim(2)
%Esquinas, el m�nimo entre la imagen 1 y la 2 transformada,
%Creas ese nuevo mundo, colocas esas imagenes en ese mundo y luego las
%proyectas sobre una imagen

%Secuencia1 1,2,3,4 secuencia2 5, 6, 7 