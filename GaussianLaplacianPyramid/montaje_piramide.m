function salida = montaje_piramide(pir, escalar)
% Crea una imagen que representa la pir�mide de im�genes
%   SALIDA = MONTAJE_PIRAMIDE(PIR, ESCALAR) crea una �nica imagen con las
%   im�genes de la pir�mide PIR de forma que sea c�modo verla. Por defecto
%   se conserva el rango de las im�genes pero para facilitar la
%   visualizaci�n de pir�mides laplacianas se pude poner el par�metro
%   ESCALAR a TRUE indicando que se escale el rango de cada escala al rango
%   [0,1]. Si no se proporciona valor para el par�metro ESCALAR se usar�
%   FALSE y no se escalar�n los rangos de las im�genes.

if nargin ~=2
    escalar = false;
end

% Tama�o de la imagen original
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
    
    % Aqu� empezaremos a poner la siguiente imagen
    fila_inicial = fila_inicial + filas_actual; 
end
