function [Salida, dy, dx] = alinear_multiescala(imagen, referencia, rango)

% Calcular el número de niveles de la pirámide para que como máximo
% tengamos 64 píxeles de tamaño
niveles = floor(log2(min(ceil(size(imagen)/64))));

% Calcular las pirámides gaussianas de la imagen y la referencia
%%%% COMPLETAR ESTO
imgpirG =piramide_gaussiana(imagen, niveles); ;
refpirG = piramide_gaussiana(referencia, niveles);;
%%%% HASTA AQUI

% Calcular la alineación en el nivel más alto con el rango inicial
[Salida, dy, dx] = alinear(imgpirG{niveles+1}, refpirG{niveles+1}, rango);

% para cada nivel adicional refinar la alineación
rango = [1 1];
for nivel = niveles:-1:2
    % Al subir de nivel, el desplazamiento calculado se duplica
%%%% COMPLETAR ESTO
    dy = dy*2;
    dx = dx*2;
    % seleccionamos las imágenes a alinear
    %refescalada = impyramid( refpirG{nivel+1} ,'expand');
    %imgescalada = impyramid( imgpirG{nivel+1} ,'expand');
    refescalada = impyramid( refpirG{nivel} ,'expand');
    imgescalada = impyramid( imgpirG{nivel} ,'expand');
    
%%%% HASTA AQUI
    % colocamos la imagen en la posición ya calculada
    imgescalada = circshift(imgescalada, [dy dx]);
    % refinamos el desplazamiento
    [Salida, dyn, dxn] = alinear(imgescalada, refescalada, rango);
    %Salida = padarray(Salida, abs(size(Salida)-size(referencia)), 'replicate', 'post');
    % Calculamos el nuevo desplazamiento
%%%% COMPLETAR ESTO
    dy =dy+dyn;
    dx =dx+dxn;
%%%% HASTA AQUI
    fprintf('nivel=%d, dy=%d, dx=%d\n', nivel, dy, dx);
end
end