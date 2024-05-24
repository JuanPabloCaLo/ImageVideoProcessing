function imagen_media = morphing_afin(imagen1, puntos1, imagen2, puntos2, triangulos, alfa)
%Aqu� se calcula la matriz de transformaci�n y se aplica directamente a los triangulos 
% Calcular los puntos destino: Media ponderada de los puntos de entrada
% RELLENAR ESTO
puntos_media = puntos1*alfa+puntos2*(1-alfa); %Puntos medios para un alfa

imagen_media = zeros(size(imagen1)); %La imagen de salida es negra en inicio donde se van colocando los triangulos
                                     %calculados
% Encontrar la imagen media de cada tri�ngulo
for i = 1:size(triangulos,1)
    t = triangulos(i,:);
    % Seleccionar el tri�ngulo t de la imagen1, imagen2 e imagen_media
    triangulo1 = puntos1(t,:);%3 puntos del triangulo imagen 1
    triangulo2 = puntos2(t,:);%3 puntos del triangulo imagen 2
    triangulo_media = puntos_media(t,:);%3 puntos del triangulo medio
    
    % Estimar la transformaci�n af�n del tri�ngulo1 al triangulo media
    %%% RELLENAR AQUI
    %Matriz forma [x' y' 1][a b c,d e f,0 0 1,][x y 1]
    %x' y' 1 Triangulo media
    %x y 1 Triangulo imagen 1
    transf1_media = fitgeotrans(triangulo1,triangulo_media, 'affine');
    
    % Estimar la transformaci�n af�n del tri�ngulo2 al triangulo media
    %%% RELLENAR AQUI
        %Matriz forma [x' y' 1][a b c,d e f,0 0 1,][x y 1]
    %x' y' 1 Triangulo media
    %x y 1 Triangulo imagen 2
    transf2_media = fitgeotrans(triangulo2, triangulo_media, 'affine');
    
    % Deformar las im�genes para llevarlas a la posici�n de la media
    %Lo haces a lo bruto, deformas toda la imagen con esa transformaci�n,
    %te quedas con el tri�ngulo y eliminas el resto de la imagen
    %'OutputView', imref2d(size(imagen1) parte que tiene las dimensiones
    %originales, porque al deformar la imagen se aumentan o reducen las
    %dimensiones
    imagen1w = imwarp(imagen1, transf1_media, 'OutputView', imref2d(size(imagen1)));
    imagen2w = imwarp(imagen2, transf2_media, 'OutputView', imref2d(size(imagen2)));

    % Fundir las im�genes deformadas
    %Esto es la imagen fundida pero solo es v�lida para la regi�n del tri�ngulo
    fundida = alfa .* imagen1w + (1-alfa) .* imagen2w;
       
    % De toda la imagen fundida solo nos interesa el tri�ngulo
    % triangulo_media. Creamos una m�scara del tama�o de fundida con
    % ese tri�ngulo.
    mascara = roipoly(fundida, triangulo_media(:,1), triangulo_media(:,2));
    %Coges la imagen fundida, defines una regi�n de inter�s (el triangulo)
    %el trozo se multiplica por 1 y el resto por 0 as� que queda todo negro
    %salvo el tri�ngulo
    % A�adimos el tri�ngulo fundido a la imagen de salida
    imagen_media = imagen_media + mascara .* fundida;
    %se va a�adiendo tri�ngulo a tri�ngulo a la imagen
end
%Esto es muy ineficiente

