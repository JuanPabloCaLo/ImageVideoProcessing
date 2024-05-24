function esquinas = Harris(I, region)
% HARRIS Computa las esquinas de Harris
%
%   ESQUINAS = HARRIS(I) devuelve un objeto cornerPoints, ESQUINAS,
%   conteniendo información sobre los puntos característicos detectados en
%   una imagen de grises 2-D, I, usando el algoritmo de Harris-Stephens.

%region(1) x region(2) y, region(3) ancho, region(4) alto
%El 4 no es el ultimo pixel es el ancho
%El 3 no es el ultimo pixel es el alto
Inueva=I(region(2):(region(2)+region(4)-1),region(1):(region(1)+region(3)-1));
I2 = im2single(Inueva); % Por compatibilidad con algoritmo de Matlab.

% Computar los gradientes horizontales y verticales de la imagen
%convolucionar con un filtro de gradientes
%[-1 0 1]
% COMPLETAR AQUI
Fghorizontal=[-1 0 1];
Fgvertical=[-1 0 1]';
Ix = imfilter(I2,Fghorizontal); %gradientes horizontales
Iy = imfilter(I2,Fgvertical);%gradientes verticales
%gradientes horizontales, fronteras verticales
%gradientes verticales, fronteras horizontales
% HASTA AQUI

%figure; 
%subplot(1,2,1); imshow(Ix,[]); colorbar; title('gradientes horizontales');
%subplot(1,2,2); imshow(Iy,[]); colorbar; title('gradientes verticales');
%truesize
%Hasta aquí está bien porque estas figuras son correctas


%Matriz de los momentos de segundo orden
%Sumatoria de gradientes en IX^2, Sumatoria IxIY, Sumatoria de gradientes
%IxIy, Sumatoria IY^2
%Primero calculas IX^2 IXIY e IY^2 para cada uno de los pixeles y ahora
%multiplicas por una gaussiana.
%A[i,j] es Sumatoria de Ix^2,
%B[i,j] es Sumatoria de IxIy
%C[i,j] es Sumatoria de Iy^2
% Calcular A, B, C (H = [ A C; C B]);
% COMPLETAR AQUI
%A = sum(Ix^2); Así da error así que no puede ser
%B = sum(Iy^2);
%C = sum(Ix*Iy);

%A = sum(Ix.^2,'all'); %Con esto ahora si son numeros pero me sale una imagen 
%B = sum(Iy.^2,'all'); %completamente verde
%C = sum(Ix.*Iy,'all');

%A = sum(Ix.^2); %Con esto la imagen solo tiene una fila
%B = sum(Iy.^2); 
%C = sum(Ix.*Iy);

A =(Ix.^2); %Esto parece ser lo correcto
B =(Iy.^2); 
C =(Ix.*Iy);

% HASTA AQUI

% Crear un filtro gausiano 5x5 con desv. 5/3.
filtroGausiano = fspecial('gaussian', 5, 5/3);

% Filtrar A, B, C con dicho filtro
A = imfilter(A, filtroGausiano, 'replicate');
B = imfilter(B, filtroGausiano, 'replicate');
C = imfilter(C, filtroGausiano, 'replicate');

% Calcular la métrica de Harris
% COMPLETAR AQUI
%Traza (A+C) suma diagonal principal
%determinante producto diagonal * antidiagonal
%Se puede calcular para todos los píxeles a la vez
%R para todos los píxeles

detH = (A.*B)-(C.*C);  % determinante de H
trH = A+C; % traza de H
k = 0.04; % k
R = detH-(k.*trH.^2); % determinante de H - k * cuadrado de la traza de H;

%Así no es porque hay cuentas que
%no se pueden hacer y no tiene sentido tampoco: 
%detH = (A*B)-(C*C);  % determinante de H 
%trH = A+C; % traza de H
%k = 0.04; % k
%R = detH-(k*trH^2) % determinante de H - k * cuadrado de la traza de H;
% HASTA AQUI

%figure; subplot(1,2,1); imagesc(R); axis image; colormap(jet); colorbar; title('Métrica de Harris');

% Umbralización. Ponemos a 0 los pixels menores que un umbral (1% del
% máximo valor de la métrica)
%El resultado es un mapa de intensidades
%todo lo que esté por debajo de un 1% del máximo no es una esquina
umbral = 0.01 * max(R(:));
% COMPLETAR AQUI
R(R < umbral) = 0;
%Lo debemos poner a 0
% HASTA AQUI

%subplot(1,2,2); imagesc(R);  axis image; colormap(jet); colorbar;  title('Métrica de Harris umbralizada');
%truesize;
%Esta figura sale mal así que algo es incorrecto
%La esquina estará donde tenga la máxima respuesta en el entorno local
% Supresión de no máximos en regiones con radio 1 (región 3x3)
% Devuelve la lista de posiciones de puntos que son máximos locales
pos = SuprimirNoMaximos(R, 1);%el 1 es el radio

% Seleccionar los valores de la métrica en las posiciones de pos
posMetrica = R(sub2ind(size(I),pos(:,1), pos(:,2)));

%Devolver las esquinas, objeto vector de puntos con la posición del punto y la
%respuesta para este punto.
%posMetrica es R de esos puntos máximos
% Poner la salida como un objeto cornerPoints.
esquinas = cornerPoints([pos(:,2), pos(:,1)], 'Metric', posMetrica);
%todas posiciones x, todas posiciones y y su valor

%figure; subplot(1,2,1); imagesc(posMetrica); axis image; colormap(jet); colorbar; title('Métrica de Harris 2');
%esto es una linea así que no se comprobar cuando estoy eliminando bien los
%no máximos
end


function resultado = maximoLocal(R, y, x, radio)
% MAXIMOLOCAL comprueba si un punto es máximo local
%
%   RESULTADO = MAXIMOLOCAL(METRICA, Y, X, RADIO) devuelve si el punto 
%   (Y,X), en la matriz METRICA es un máximo local en un entorno cuadrado
%   de lado 2*RADIO+1 alrededor del punto (Y,X).

entorno = R(y-radio:y+radio,x-radio:x+radio);
%trozo de r centrado en ese punto
[~,p] = max(entorno(:));
%máximo devuelve el máximo y la posición pero si lo aplicas a una matriz da
%el máximo por cada columna y tu no quieres eso, si lo aplicas otra vez
%puedes saber cual es el máximo pero tu lo que quieres es la posición así
%que hay que hacer un proceso largo.
% será máximo local si la posición del máximo del entorno coincide con la posición del punto central

%en lugar de eso coges la matriz como si fuera un vector y calculas el
%máximo y la posición
%El máximo está en el centro si la posición p es =5
resultado = p == sub2ind([2*radio+1,2*radio+1],radio+1,radio+1);
%esto lo que comprueba es que el máximo esté en el centro
%5 es para matrices 3*3 (radio del entorno 1, pero en general es (x=r+1,y=r+1)
%sub2ind calcula el índice como si fuese un vector a partir del tamaño de
%la matriz (2r+1) y la posición (r+1,r+1).

%Devuelve true si es un máximo local y false si no
end

%Se recorre toda la imagen y suponemos un entorno de +-1
%Creas una imagen nueva con lo que puede ser máximos, la vas recorriendo y
%de entre los candidatos a máximos miras si es un máximo local. Si es un
%máximo local conservas ese pixel pero además tienes que eliminar los no
%máximos locales (a 1 pixel de distancia).
function posiciones = SuprimirNoMaximos(R, radio)
% SUPRIMIRNOMAXIMOS suprime los no máximos
%
% POSICIONES = SUPRIMIRNOMAXIMOS(R, RADIO) devuelve la lista de 
% posiciones (Y,X) de los píxeles de la matriz R que son máximos 
% en un entorno cuadrado de lado 2*RADIO+1

% Inicialmente los candidatos son los que tienen un valor de métrica
% distinto de cero.
maximos = (R ~= 0);

% Si miras alrededor de los bordes de la imagen resultará en error así que
% consideras que ahí no hay esquinas
% No consideraremos los puntos en los bordes de la imagen por lo que los pondremos a false.
%No se encoge la imagen, se suprimen los valores (0=false).
maximos(1:radio,:) = false;
maximos(end-radio+1:end,:) = false;
maximos(:,1:radio) = false;
maximos(:,end-radio+1:end) = false;


for y=1:size(R,1)
    for x=1:size(R,2)
        if maximos(y,x) % == true % Considerar sólo los píxeles candidatos
            if maximoLocal(R, y, x, radio)%dice si un determinado punto es máximo o no
                % Poner a false el entorno (menos el pixel considerado, el centro) 
                % COMPLETAR AQUI
                %Pones a 0 todo e cuadrito primero y el punto central a 1
                %después
                %R(y,x)=1;%Si lo dejo con solo esto así parece salir bien pero no estoy eliminando los 
                         %no máximos locales
                
                %R(y,x)=true; %esto también parece funcionar
                %R(2,2)=1; % x tiene tamaño 48 e y 88 así que pues no
                          % tiene sentido
                          %tampoco entiendo esos valores porque según yo
                          %entiendo size si R tiene tamaño 500 x 400
                          %y debería ser 500 y x 400 pero no es lo que dice
                          %matlab al lanzar el debug
                          
                %R(y+1,x+1)=0; %tambien parece funcionar esto pero carece de sentido
                %R(y+1,x)=0;
                %R(y,x+1)=0;
                %R(y-1,x-1)=0; %tambien parece funcionar esto pero carece de sentido
                %R(y-1,x)=0;
                %R(y,x-1)=0;
                %R(y-1,x+1)=0; %tambien parece funcionar esto pero carece de sentido
                %R(y-1,x+1)=0;
                %R(y+1,x-1)=0;
                %R(y,x)=1;
                
                %Parece que ponga lo que ponga aquí no me está afectando al
                %resultado final...
                
                maximos(y+1:y+radio,x+1:x+radio)=0; 
                maximos(y-1:y-radio,x-1:x-radio)=0;
                maximos(y,x)=true; %Esto es correcto pero debo poner a 0 el entorno
                

            else
                % El pixel no es un máximo local
                maximos(y,x) = false;
            end
        end
    end
end

% Encontrar y devolver las posiciones a true
%devuelves el vector de puntos que has encontrado
[posicionesy, posicionesx] = find(maximos);
posiciones = [posicionesy, posicionesx] ;

end

%Comparar la utilización de esta función con detect Harris features en el
%script de los panoramas
%Voluntario, alinear las imágenes rusas con la técnica de homografía de panoramas


