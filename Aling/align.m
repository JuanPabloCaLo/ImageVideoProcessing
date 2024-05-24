function [salida, dymin, dxmin] = alinear(imagen, referencia, rango)
minssd=inf;
borde=ceil(size(imagen)/4);

% Conversión a int16 para evitar problemas con los negativos en la resta
% entre imágenes que haremos después
desplazada = int16(imagen);
referencia = int16(referencia);

% Para cada posición del área de búsqueda
for dx=-rango(2):rango(2)
    for dy=-rango(1):rango(1)
        % calculamos la diferencia entre la imagen de referencia y la
        % imagen actual desplazada en [dy,dx]. 
        dif = circshift(desplazada, [dy dx]) - referencia;
        % Consideramos solo la parte central de la imagen para evitar
        % problemas con los bordes (quitamos 1/4 de imagen por cada lado).
        ssd = dif(borde(1):3*borde(1), borde(2):3*borde(2)).^2; 
        % Calculamos la suma de los cuadrados de las diferencias
        ssd=sum(ssd(:)); 
        % Nos quedamos con la posición de mínima diferencia
        if (ssd < minssd)
            dxmin = dx;
            dymin = dy;
            minssd = ssd;
        end
    end
end
% La imagen de salida será la imagen de entrada desplazada a la posición
% con mínimo error.
salida = circshift(imagen, [dymin dxmin]);
end