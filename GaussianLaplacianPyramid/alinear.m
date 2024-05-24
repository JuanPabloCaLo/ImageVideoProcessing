function [salida, dymin, dxmin] = alinear(imagen, referencia, rango)
minssd=inf;
borde=ceil(size(imagen)/4);

% Conversi�n a int16 para evitar problemas con los negativos en la resta
% entre im�genes que haremos despu�s
desplazada = int16(imagen);
referencia = int16(referencia);

% Para cada posici�n del �rea de b�squeda
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
        % Nos quedamos con la posici�n de m�nima diferencia
        if (ssd < minssd)
            dxmin = dx;
            dymin = dy;
            minssd = ssd;
        end
    end
end
% La imagen de salida ser� la imagen de entrada desplazada a la posici�n
% con m�nimo error.
salida = circshift(imagen, [dymin dxmin]);
end