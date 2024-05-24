function salida = reinhard(origen, destino)
% REINHARD transfiere color a una imagen usando el método de Reinhard
%   SALIDA = REINHARD(ORIGEN, DESTINO) transfiere el color de la imagen
%   DESTINO a la imagen ORIGEN usando el método de Reinhard [1].
%
%   Entradas:
%   ---------
%     ORIGEN imagen RGB a la que se transfiere el color
%     DESTINO imagen RGB de referencia de la que se obtiene el color
%
%   Salida:
%   -------
%     SALIDA imagen RGB ORIGEN con los colores de DESTINO
%
%   Referencia:
%   -----------
%   [1] E Reinhard, M Adhikhmin, B Gooch, P Shirley. "Color transfer between 
%       images". IEEE Computer Graphics and Applications, vol.21 no.5, pp.
%       34-41, 2001.
%
%   (c) Javier Mateos
%   Departamento de Ciencias de la Computación e I.A.
%   Universidad de Granada (España)
%


% Convertir de RGB a L*a*b* la imagen origen
olab = applycform(im2double(origen), makecform('srgb2lab'));
% En versiones >= R2014b se puede usar 
% olab = rgb2lab(im2double(origen));

% Media de cada canal L*a*b* de la imagen origen
omedia = mean(reshape(olab, [], 3));

% Desviación típica de cada canal L*a*b* de la imagen origen
odesv = std(reshape(olab, [], 3));


% Convertir de RGB a L*a*b* la imagen destino
dlab = applycform(im2double(destino), makecform('srgb2lab'));
% En versiones >= R2014b se puede usar 
% dlab = rgb2lab(im2double(destino));

% Media de cada canal L*a*b* de la imagen destino
dmedia = mean(reshape(dlab, [], 3));

% Desviación típica de cada canal L*a*b* de la imagen destino
ddesv = std(reshape(dlab, [], 3));

%% Normalización
% Normalizar cada canal basado en las estadísticas de origen y destino
% RELLENAR AQUI

%% Banda asterisco

%bandaLasterisco= banda l origen - media banda l origen
Lasterisco= olab(:,:,1)-omedia(1);

%Aasterisco= banda a origen  - media banda a origen
Aasterisco=olab(:,:,2)-omedia(2);

%Basterisco= banda b origen - media banda b origen
Basterisco=olab(:,:,3)-omedia(3);

%% Bandas primas
%banda L prima = (desviación destino/ desviación origen).*bandaLasterisco
Lprima = (ddesv(1)./odesv(1)).*Lasterisco;

%banda A prima = (desviación destino/ desviación origen).*Aasterisco
Aprima =(ddesv(2)./odesv(2)).*Aasterisco;

%banda B prima = (desviación destino/ desviación origen).*Basterisco
Bprima = (ddesv(3)./odesv(3)).*Basterisco;

%% Banda final
%bandaLfinal = banda L prima + media banda L destino
Lfinal= Lprima + dmedia(1);

%bandaAfinal = banda A prima + media banda a destino
Afinal = Aprima + dmedia(2);

%bandaBfinal = banda B prima + media banda B destino
Bfinal = Bprima + dmedia(3);

%% Unión bandas

slab=cat(3,Lfinal,Afinal,Bfinal);

%% Conversión RGB

%salida = applycform(slab, makecform('lab2srgb'));
% En versiones >= R2014b se puede usar
salida = lab2rgb(slab);
%salida = 1;

end

        

    


