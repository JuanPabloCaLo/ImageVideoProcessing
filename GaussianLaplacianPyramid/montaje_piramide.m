function salida = montaje_piramide(pir, escalar)
% Crea una imagen que representa la pirámide de imágenes
%   SALIDA = MONTAJE_PIRAMIDE(PIR, ESCALAR) crea una única imagen con las
%   imágenes de la pirámide PIR de forma que sea cómodo verla. Por defecto
%   se conserva el rango de las imágenes pero para facilitar la
%   visualización de pirámides laplacianas se pude poner el parámetro
%   ESCALAR a TRUE indicando que se escale el rango de cada escala al rango
%   [0,1]. Si no se proporciona valor para el parámetro ESCALAR se usará
%   FALSE y no se escalarán los rangos de las imágenes.

if nargin ~=2
    escalar = false;
end

% Tamaño de la imagen original
[filas,cols,bandas] = size(pir{1});

% el ancho de la salida es el ancho de las dos primeras escalas
salida = ones(filas, cols + size(pir{2},2), bandas);

im_actual = pir{1};
if escalar % ajustar rangos
    minimo = min(im_actual(:));
    maximo = max(im_actual(:));
    im_actual = (im_actual - minimo)./ (maximo - minimo);
end

salida(:,1:cols,:) = im_actual; %Imagen original a la izquierda

% El resto de las escalas las colocamos a la derecha amontonadas
fila_inicial = 1;
for i=2:numel(pir)
    im_actual = pir{i};
    if escalar % ajustar rangos
        minimo = min(im_actual(:));
        maximo = max(im_actual(:));
        im_actual = (im_actual - minimo)./ (maximo - minimo);
    end
    
    [filas_actual, cols_actual, ~] = size(im_actual);
    salida(fila_inicial:fila_inicial+filas_actual-1, ...
        cols+1:cols+cols_actual,:) = im_actual;
    
    % Aquí empezaremos a poner la siguiente imagen
    fila_inicial = fila_inicial + filas_actual; 
end
