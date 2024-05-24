function imagen_media = morphing_baricentro(imagen1, puntos1, imagen2, puntos2, triangulos, alfa)

% Calcular los puntos destino: Media ponderada de los puntos de entrada
% RELLENAR ESTO
puntos_media = puntos1*alfa+puntos2*(1-alfa); %esto es una linea y alfa interviene

H = size(imagen1, 1);
W = size(imagen1, 2);

% Alojar memoria para las coordenadas de imagen1 e imagen2 como vectores de
% coordenadas x,y
coord1 = zeros(H*W, 2);
coord2 = zeros(H*W, 2);

% Crear el grid de los puntos de la imagen 
[X, Y] = meshgrid(1:W, 1:H);
grid = [X(:), Y(:)];

% Deformar este grid al grid de la imagen 1 y de la imagen 2. Esto lo
% hacemos triángulo a triángulo.
for i = 1:size(triangulos, 1)
    t = triangulos(i,:);%Posición de puntos media del triangulo a deformar
    w = pesos_baricentro(grid, puntos_media(t,:));%Calculas los pesos del grid para puntos que definen un triangulo
                                                  %Multiplicas por w y dan las cordenadas nuevas
    coord1 = coord1 + w * puntos1(t,:);%Coordenadas transformadas triangulo imagen 1          
    coord2 = coord2 + w * puntos2(t,:);%Coordenadas transformadas triangulo imagen 2
    %pesos baricéntricos: Punto P escrito por 3 pesos proporcionales a las
    %areas de los triangulos. Punto=Awa+Bwb+Cwc wa+wb+wc=1
    %puntos fuera del triangulo w=0 para que no se tengan en cuenta
end

% Convertir los vectores de coordenadas en una matriz de coordenadas x,y
% del tamaño de las imágenes, que será el grid de cada imagen
coord1 = reshape(coord1, H, W, 2);
X1 = coord1(:,:,1);
Y1 = coord1(:,:,2);
coord2 = reshape(coord2, H, W, 2);
X2 = coord2(:,:,1);
Y2 = coord2(:,:,2);

% Interpolar cada imagen en su grid correspondiente
%Necesitas interpolar los valores a un grid cuadrado, la imagen final
%Imaginamos la imagen como algo contínuo muestreado en distintos puntos
%conoces los valores de la imagen en los puntos del grid
%quiero muestrear la imagen en otras posiciones y tener esa nueva imagen
%como resultado.
%Creas nueva imagen con lo que valga en esos puntos en el grid original
%parametros, grid original, valores X1 Y1, nuevo grid. Xmedia Ymedia
%parametros, grid original, valores X2 Y2, nuevo grid. Xmedia Ymedia
%v es la imagen original
for c=1:size(imagen1,3)
    % RELLENAR ESTO
    imagen1(:,:,c) = interp2(X, Y, c, X1, Y1);
    imagen2(:,:,c) = interp2(X, Y, c, X2, Y2);
end

% fundido
imagen_media = alfa .* imagen1 + (1-alfa) .* imagen2;
end


function pesos = pesos_baricentro(puntos, triangulo)

% Crear el sistema de ecuaciones
B = [puntos'; ones(1,size(puntos,1))]; %esto está dado la vuelta frente a la teoria
A = [triangulo'; ones(1, size(triangulo,1))];%esto está dado la vuelta frente a la teoría

% Resolver sistema
pesos = transpose(A \ B);

% Eliminar los pesos de los píxeles que están fuera del triángulo 
out = any(pesos < 0, 2);
pesos(out,:)=0;
%Si uno de los pesos es negativo-> está fuera del triangulo-> todos los
%pesos a 0
end

%Puede no funcionar bien porque ciertos puntos pertenezcan a varios
%triangulos y se sumen erróneamente y que alguno esté en ninguno por
%aproximaciones y quede fuera del grid al eliminar pesos negativos
