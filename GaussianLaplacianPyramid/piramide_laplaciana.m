function pirL = piramide_laplaciana(im, niveles)
% PIRAMIDE_LAPLACIANA Crea una pirámide laplaciana
%   PIRL = PIRAMIDE_LAPLACIANA(IM, NIVELES) crea una pirámide laplaciana de
%   NIVELES niveles a partir de la imagen IM. El nivel NIVELES+1 contiene
%   la imagen correspondiente de la pirámide gaussiana y el resto de 
%   niveles la diferencia entre la expansión del nivel superior de la 
%   pirámide y la imagen correspondiente de la pirámide gaussiana.

% Creamos la piramide gaussiana
pirG = piramide_gaussiana(im, niveles);
% Creamos la estructura de la pirámide laplaciana
pirL = cell(1,niveles+1);
% El nivel más alto de la pirámide es la imagen correspondiente de la
% pirámide gaussiana
pirL{niveles+1} = pirG{niveles+1};
% Para el resto de los niveles
for i=niveles:-1:1
    % expandimos
    aux = impyramid(pirG{i+1},'expand');
    % ajustamos el tamaño
    aux = padarray(aux, size(pirG{i})-size(aux), 'replicate', 'post');
    %al aumentar la imagen puede no tener el mismo tamaño que la original
    % restamos para obtener los detalles
    pirL{i} = pirG{i}-aux;
    %estos detalles es lo que guarda la piramide laplaciana
end

