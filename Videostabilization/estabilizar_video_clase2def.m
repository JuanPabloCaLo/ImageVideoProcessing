%filename = 'videos/ownvid.mp4';
 filename = 'videos/carsell.mp4';

%% 1. Leer el primer fotograma

video = VideoReader(filename);
nuevo = im2double(readFrame(video));
%% Crear archivo de video para guardarlo
videoguardado= VideoWriter('stabilized2.avi');
open(videoguardado);

%% Seleccionar la region de interés (Region of interest - ROI).
%De momento no se hace
% Opcional. Aumenta la velocidad y a veces mejora la estabilización
% Hacer doble clic para aceptar la ROI. Esc o cerrar la ventana para usar
% toda la imagen.
% Si se quiere eliminar puede sustituirse por 
% ROI = [1 1 size(nuevo,2) size(nuevo,1)];
% o bien eliminar la línea y quitarlo también del detector de esquinas.
% También puede añadirse un parámetro con la ROI que nos interese, como,
% por ejemplo, ROI = getROI(nuevo, [100 100 50 50]); para añadir una ROI de
% tamaño 50x50 pixels cuya esquina superior izquierda sea (100,100)
ROI = getROI(nuevo);

%% Inicialización
% Creamos la figura vamos a mostrar los fotogramas originales y corregidos.
figura = figure; 

% Para ver la calidad de estabilización vamos a calcular la media de los
% fotogramas originales y corregidos
%medidas para medir como de bien funciona esto
mediaOriginal = nuevo;
mediaCorregida = mediaOriginal;
numFotogramas=1;

% Iniciamos la transformación a la identidad.
HAcumulada = affine2d(eye(3));

% Surf o Harris
promt="Escriba h si quiere usar Harris, se usará surf por defecto";
decision=input(promt);

%% 2. Mientras haya fotogramas
while hasFrame(video) 

    %% a. Guardar el fotograma actual (que será el viejo en esta vuelta)
    viejo = nuevo;%fotograma 
    %% b. Nuevo = leer el siguiente fotograma del video
    nuevo = im2double(readFrame(video));
    
    imgGris_nuevo = rgb2gray(nuevo); %Conversión a gris
    imgGris_viejo = rgb2gray(viejo); %Conversión a gris
    
   
    %% c. Encontrar esquinas en los dos fotogramas
    % Si se usa una ROI añadir los parámetros 'ROI', ROI al detector de
    % esquinas que se utilice. 
    
    %%%% RELLENAR AQUI
    if(decision=='h')
       puntos_nuevo = Harrispregion(imgGris_nuevo, ROI );
       puntos_viejo = Harrispregion(imgGris_viejo, ROI ); 
    else
       puntos_nuevo = detectSURFFeatures(imgGris_nuevo, 'ROI', ROI );
       puntos_viejo = detectSURFFeatures(imgGris_viejo, 'ROI', ROI );
    end
    
    
    %% d. Extraer los decriptores

    %%%% RELLENAR AQUI
    [caract_nuevo, puntos_nuevo] = extractFeatures(imgGris_nuevo, puntos_nuevo);
    [caract_viejo, puntos_viejo] = extractFeatures(imgGris_viejo, puntos_viejo);
    
    %% e. Estimar el emparejamiento de los rasgos
    
    %%%% RELLENAR AQUI
    IndicesParejas = matchFeatures(caract_nuevo, caract_viejo, 'Unique', true);
    PuntosEmparejados_nuevo = puntos_nuevo(IndicesParejas(:,1),:);
    PuntosEmparejados_viejo = puntos_viejo(IndicesParejas(:,2),:);
    
    %% f. Estimar la transformación entre los dos fotogramas
    [H,~,~,status] = estimateGeometricTransform(PuntosEmparejados_nuevo, PuntosEmparejados_viejo, 'similarity', 'MaxDistance', 0.5, 'MaxNumTrials', 5000);
    %Esto no es una homografía sino una tranformación de similaridad, esto
    %se debe a que la cámara se mueve accidentalmente, se supone que está
    %fija y se producirán rotaciones y traslaciones pequeñas.
    
    % Si no se logra estimar la transformación por falta de puntos, por
    % ejemplo, considerar que la transformación es la identidad
    if status ~= 0
        H = affine2d(eye(3));%Supones que no hay transformación para el fotograma si falla
        fprintf('No hubo puntos para procesar el fotograma %d\n', numFotogramas+1);
    end
    %Hay casos en los que puede fallar porque no haya suficientes puntos
    %distintivos en la región escogida
    
    %% g. Mover el nuevo fotograma a la posición del antiguo
    % Recordad que hay que acumular las transformaciones al igual que se
    % hacía en los panoramas.
    %Aplicas la homografía pero hay que ir acumulándola

    %%%% RELLENAR AQUI
    % transformacion(i).T = transformacion(i-1).T * transformacion(i).T;
    HAcumulada.T=H.T*HAcumulada.T;
    nuevoCorr = imwarp(nuevo, HAcumulada, 'OutputView', imref2d(size(nuevo)));
    writeVideo(videoguardado ,nuevoCorr);

    %% Mostrar la figura
    figure(figura); imshowpair(nuevo, nuevoCorr, 'montage');
    title(sprintf('Entrada %s Salida. Fotograma %d', repmat(' ',[1 40]), numFotogramas));
    drawnow();
    

    %% Actualizar la suma de los fotogramas
    mediaOriginal = mediaOriginal + nuevo; %Debe salir borrosa
    mediaCorregida = mediaCorregida + nuevoCorr; %Debe salir nítido
    numFotogramas = numFotogramas+1;
    

end

%% Calcular las medias y mostrarlas
mediaCorregida = mediaCorregida./numFotogramas;
mediaOriginal = mediaOriginal./numFotogramas;

figure; imshowpair(mediaOriginal, mediaCorregida, 'montage');
title(['Entrada' repmat(' ',[1 40]) 'Salida']);

%% Cerrar archivo de guardado
close(videoguardado);
