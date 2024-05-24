function pirL = piramide_laplaciana(im, niveles)
% PIRAMIDE_LAPLACIANA Crea una pir�mide laplaciana
%   PIRL = PIRAMIDE_LAPLACIANA(IM, NIVELES) crea una pir�mide laplaciana de
%   NIVELES niveles a partir de la imagen IM. El nivel NIVELES+1 contiene
%   la imagen correspondiente de la pir�mide gaussiana y el resto de 
%   niveles la diferencia entre la expansi�n del nivel superior de la 
%   pir�mide y la imagen correspondiente de la pir�mide gaussiana.

% Creamos la piramide gaussiana
pirG = piramide_gaussiana(im, niveles);
% Creamos la estructura de la pir�mide laplaciana
pirL = cell(1,niveles+1);
% El nivel m�s alto de la pir�mide es la imagen correspondiente de la
% pir�mide gaussiana
pirL{niveles+1} = pirG{niveles+1};
% Para el resto de los niveles
for i=niveles:-1:1
    % expandimos
    aux = impyramid(pirG{i+1},'expand');
    % ajustamos el tama�o
    aux = padarray(aux, size(pirG{i})-size(aux), 'replicate', 'post');
    %al aumentar la imagen puede no tener el mismo tama�o que la original
    % restamos para obtener los detalles
    pirL{i} = pirG{i}-aux;
    %estos detalles es lo que guarda la piramide laplaciana
end

