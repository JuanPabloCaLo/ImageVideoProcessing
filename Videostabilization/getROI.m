function posicion = getROI(img, roi)
%Saca el primer fotograma y te permite seleccionar una zona para mantener
%estable
% GETROI selecciona una región de interés (ROI) rectangular de una imagen
%
% POSICION = GETROI(IMG) muestra la imagen IMG en una figura y permite
% seleccionar una región rectangular. Devuelve en POSICION la región en
% formato [x y ancho alto]. Inicialmente la ROI será un rectángulo de
% tamaño la mitad de la imagen centrado en ésta.
%
% POSICION = GETROI(IMG,ROI) colola la ROI inicial en las posiciones
% especificadas en ROI. ROI es un vector con 4 componentes correspondientes
% a [xini yini ancho alto].
% 
% Para seleccionar una región hacer doble clic dentro de la ROI.
% Para anular la selección pulsar Esc o cerrar la ventana. En este caso la
% ROI será toda la imagen.

% Crear la figura y mostrar la imagen
f = figure; 
imshow(img);

% Obtener los límites de la imagen actual (posiciones de la imagen en los
% ejes de la figura)
X = get(gca,'XLim');
Y = get(gca,'YLim');

limites = round([X(1), Y(1), X(2)-X(1), Y(2)-Y(1)]);
% Si no se especifica una ROI, la ROI inicial es un rectángulo del tamaño
% de la mitad de la imagen centrado en ésta.
if nargin < 2
    roi = [limites(1)+limites(3)/4 limites(2)+limites(4)/4 limites(3)/2 limites(4)/2];
end
% mostrar las coordenadas actuales
title(mat2str(roi,3))

% seleccionar el rectángulo sin permitir que se salga de la imagen
h = imrect(gca, roi);
addNewPositionCallback(h,@(p) title(mat2str(p,3)));
fcn = makeConstrainToRectFcn('imrect',X,Y);
setPositionConstraintFcn(h,fcn); 

% esperar a que se haga la selección
posicion = wait(h);

% si está vacía (se cerró la ventana o se pulsó escape)
if isempty(posicion) 
    % seleccionar toda la imagen
    posicion = limites;
end

% cerrar la figura, si no se cerró aun.
if isvalid(f)
    close(f);
end

% devolver siempre posiciones enteras
posicion = round(posicion); 

end