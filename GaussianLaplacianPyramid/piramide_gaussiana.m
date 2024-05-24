function pirG = piramide_gaussiana(im, niveles)
% PIRAMIDE_GAUSIANA Crea una pirámide gaussiana
%   PIRG = PIRAMIDE_GAUSIANA(IM, NIVELES) crea una pirámide gaussiana de
%   NIVELES niveles a partir de la imagen IM. El nivel 1 contiene la imagen
%   IM, el resto de los niveles (del 2 a NIVELES+1) son versiones borrosas
%   y muestreadas de la imagen.

% Crear la estructura. Tiene NIVELES+1 celdas que son el nivel base y
% los NIVELES niveles que se solicitan.
pirG = cell(1,niveles+1);
% El nivel base (1) es la imagen original
%%%% COMPLETAR ESTO
pirG{1} = im;
%%%% HASTA AQUI

% El resto de los niveles forman la pirámide
for i=2:niveles+1
%%%% COMPLETAR ESTO
    pirG{i} = impyramid( pirG{i-1} ,'reduce');
%%%% HASTA AQUI

end


