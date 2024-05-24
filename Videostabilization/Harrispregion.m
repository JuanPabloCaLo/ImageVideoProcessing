function esquinas = Harris(I, region)
% HARRIS Computa las esquinas de Harris
%
%   ESQUINAS = HARRIS(I) devuelve un objeto cornerPoints, ESQUINAS,
%   conteniendo informaci�n sobre los puntos caracter�sticos detectados en
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
%Hasta aqu� est� bien porque estas figuras son correctas


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
%A = sum(Ix^2); As� da error as� que no puede ser
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

% Calcular la m�trica de Harris
% COMPLETAR AQUI
%Traza (A+C) suma diagonal principal
%determinante producto diagonal * antidiagonal
%Se puede calcular para todos los p�xeles a la vez
%R para todos los p�xeles

detH = (A.*B)-(C.*C);  % determinante de H
trH = A+C; % traza de H
k = 0.04; % k
R = detH-(k.*trH.^2); % determinante de H - k * cuadrado de la traza de H;

%As� no es porque hay cuentas que
%no se pueden hacer y no tiene sentido tampoco: 
%detH = (A*B)-(C*C);  % determinante de H 
%trH = A+C; % traza de H
%k = 0.04; % k
%R = detH-(k*trH^2) % determinante de H - k * cuadrado de la traza de H;
% HASTA AQUI

%figure; subplot(1,2,1); imagesc(R); axis image; colormap(jet); colorbar; title('M�trica de Harris');

% Umbralizaci�n. Ponemos a 0 los pixels menores que un umbral (1% del
% m�ximo valor de la m�trica)
%El resultado es un mapa de intensidades
%todo lo que est� por debajo de un 1% del m�ximo no es una esquina
umbral = 0.01 * max(R(:));
% COMPLETAR AQUI
R(R < umbral) = 0;
%Lo debemos poner a 0
% HASTA AQUI

%subplot(1,2,2); imagesc(R);  axis image; colormap(jet); colorbar;  title('M�trica de Harris umbralizada');
%truesize;
%Esta figura sale mal as� que algo es incorrecto
%La esquina estar� donde tenga la m�xima respuesta en el entorno local
% Supresi�n de no m�ximos en regiones con radio 1 (regi�n 3x3)
% Devuelve la lista de posiciones de puntos que son m�ximos locales
pos = SuprimirNoMaximos(R, 1);%el 1 es el radio

% Seleccionar los valores de la m�trica en las posiciones de pos
posMetrica = R(sub2ind(size(I),pos(:,1), pos(:,2)));

%Devolver las esquinas, objeto vector de puntos con la posici�n del punto y la
%respuesta para este punto.
%posMetrica es R de esos puntos m�ximos
% Poner la salida como un objeto cornerPoints.
esquinas = cornerPoints([pos(:,2), pos(:,1)], 'Metric', posMetrica);
%todas posiciones x, todas posiciones y y su valor

%figure; subplot(1,2,1); imagesc(posMetrica); axis image; colormap(jet); colorbar; title('M�trica de Harris 2');
%esto es una linea as� que no se comprobar cuando estoy eliminando bien los
%no m�ximos
end


function resultado = maximoLocal(R, y, x, radio)
% MAXIMOLOCAL comprueba si un punto es m�ximo local
%
%   RESULTADO = MAXIMOLOCAL(METRICA, Y, X, RADIO) devuelve si el punto 
%   (Y,X), en la matriz METRICA es un m�ximo local en un entorno cuadrado
%   de lado 2*RADIO+1 alrededor del punto (Y,X).

entorno = R(y-radio:y+radio,x-radio:x+radio);
%trozo de r centrado en ese punto
[~,p] = max(entorno(:));
%m�ximo devuelve el m�ximo y la posici�n pero si lo aplicas a una matriz da
%el m�ximo por cada columna y tu no quieres eso, si lo aplicas otra vez
%puedes saber cual es el m�ximo pero tu lo que quieres es la posici�n as�
%que hay que hacer un proceso largo.
% ser� m�ximo local si la posici�n del m�ximo del entorno coincide con la posici�n del punto central

%en lugar de eso coges la matriz como si fuera un vector y calculas el
%m�ximo y la posici�n
%El m�ximo est� en el centro si la posici�n p es =5
resultado = p == sub2ind([2*radio+1,2*radio+1],radio+1,radio+1);
%esto lo que comprueba es que el m�ximo est� en el centro
%5 es para matrices 3*3 (radio del entorno 1, pero en general es (x=r+1,y=r+1)
%sub2ind calcula el �ndice como si fuese un vector a partir del tama�o de
%la matriz (2r+1) y la posici�n (r+1,r+1).

%Devuelve true si es un m�ximo local y false si no
end

%Se recorre toda la imagen y suponemos un entorno de +-1
%Creas una imagen nueva con lo que puede ser m�ximos, la vas recorriendo y
%de entre los candidatos a m�ximos miras si es un m�ximo local. Si es un
%m�ximo local conservas ese pixel pero adem�s tienes que eliminar los no
%m�ximos locales (a 1 pixel de distancia).
function posiciones = SuprimirNoMaximos(R, radio)
% SUPRIMIRNOMAXIMOS suprime los no m�ximos
%
% POSICIONES = SUPRIMIRNOMAXIMOS(R, RADIO) devuelve la lista de 
% posiciones (Y,X) de los p�xeles de la matriz R que son m�ximos 
% en un entorno cuadrado de lado 2*RADIO+1

% Inicialmente los candidatos son los que tienen un valor de m�trica
% distinto de cero.
maximos = (R ~= 0);

% Si miras alrededor de los bordes de la imagen resultar� en error as� que
% consideras que ah� no hay esquinas
% No consideraremos los puntos en los bordes de la imagen por lo que los pondremos a false.
%No se encoge la imagen, se suprimen los valores (0=false).
maximos(1:radio,:) = false;
maximos(end-radio+1:end,:) = false;
maximos(:,1:radio) = false;
maximos(:,end-radio+1:end) = false;


for y=1:size(R,1)
    for x=1:size(R,2)
        if maximos(y,x) % == true % Considerar s�lo los p�xeles candidatos
            if maximoLocal(R, y, x, radio)%dice si un determinado punto es m�ximo o no
                % Poner a false el entorno (menos el pixel considerado, el centro) 
                % COMPLETAR AQUI
                %Pones a 0 todo e cuadrito primero y el punto central a 1
                %despu�s
                %R(y,x)=1;%Si lo dejo con solo esto as� parece salir bien pero no estoy eliminando los 
                         %no m�ximos locales
                
                %R(y,x)=true; %esto tambi�n parece funcionar
                %R(2,2)=1; % x tiene tama�o 48 e y 88 as� que pues no
                          % tiene sentido
                          %tampoco entiendo esos valores porque seg�n yo
                          %entiendo size si R tiene tama�o 500 x 400
                          %y deber�a ser 500 y x 400 pero no es lo que dice
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
                
                %Parece que ponga lo que ponga aqu� no me est� afectando al
                %resultado final...
                
                maximos(y+1:y+radio,x+1:x+radio)=0; 
                maximos(y-1:y-radio,x-1:x-radio)=0;
                maximos(y,x)=true; %Esto es correcto pero debo poner a 0 el entorno
                

            else
                % El pixel no es un m�ximo local
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

%Comparar la utilizaci�n de esta funci�n con detect Harris features en el
%script de los panoramas
%Voluntario, alinear las im�genes rusas con la t�cnica de homograf�a de panoramas


