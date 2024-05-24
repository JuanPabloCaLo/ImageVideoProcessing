function imagen_media = morphing_afin(imagen1, puntos1, imagen2, puntos2, triangulos, alfa)
%Aquí se calcula la matriz de transformación y se aplica directamente a los triangulos 
% Calcular los puntos destino: Media ponderada de los puntos de entrada
% RELLENAR ESTO
puntos_media = puntos1*alfa+puntos2*(1-alfa); %Puntos medios para un alfa

imagen_media = zeros(size(imagen1)); %La imagen de salida es negra en inicio donde se van colocando los triangulos
                                     %calculados
% Encontrar la imagen media de cada triángulo
for i = 1:size(triangulos,1)
    t = triangulos(i,:);
    % Seleccionar el triángulo t de la imagen1, imagen2 e imagen_media
    triangulo1 = puntos1(t,:);%3 puntos del triangulo imagen 1
    triangulo2 = puntos2(t,:);%3 puntos del triangulo imagen 2
    triangulo_media = puntos_media(t,:);%3 puntos del triangulo medio
    
    % Estimar la transformación afín del triángulo1 al triangulo media
    %%% RELLENAR AQUI
    %Matriz forma [x' y' 1][a b c,d e f,0 0 1,][x y 1]
    %x' y' 1 Triangulo media
    %x y 1 Triangulo imagen 1
    transf1_media = fitgeotrans(triangulo1,triangulo_media, 'affine');
    
    % Estimar la transformación afín del triángulo2 al triangulo media
    %%% RELLENAR AQUI
        %Matriz forma [x' y' 1][a b c,d e f,0 0 1,][x y 1]
    %x' y' 1 Triangulo media
    %x y 1 Triangulo imagen 2
    transf2_media = fitgeotrans(triangulo2, triangulo_media, 'affine');
    
    % Deformar las imágenes para llevarlas a la posición de la media
    %Lo haces a lo bruto, deformas toda la imagen con esa transformación,
    %te quedas con el triángulo y eliminas el resto de la imagen
    %'OutputView', imref2d(size(imagen1) parte que tiene las dimensiones
    %originales, porque al deformar la imagen se aumentan o reducen las
    %dimensiones
    imagen1w = imwarp(imagen1, transf1_media, 'OutputView', imref2d(size(imagen1)));
    imagen2w = imwarp(imagen2, transf2_media, 'OutputView', imref2d(size(imagen2)));

    % Fundir las imágenes deformadas
    %Esto es la imagen fundida pero solo es válida para la región del triángulo
    fundida = alfa .* imagen1w + (1-alfa) .* imagen2w;
       
    % De toda la imagen fundida solo nos interesa el triángulo
    % triangulo_media. Creamos una máscara del tamaño de fundida con
    % ese triángulo.
    mascara = roipoly(fundida, triangulo_media(:,1), triangulo_media(:,2));
    %Coges la imagen fundida, defines una región de interés (el triangulo)
    %el trozo se multiplica por 1 y el resto por 0 así que queda todo negro
    %salvo el triángulo
    % Añadimos el triángulo fundido a la imagen de salida
    imagen_media = imagen_media + mascara .* fundida;
    %se va añadiendo triángulo a triángulo a la imagen
end
%Esto es muy ineficiente

