function im = reconstruye(pirL)
% Reconstruye la imagen a partir de su pirámide laplaciana
%   IM = RECONSTRUYE(PIRL) reconstruye la imagen IM a partir de su pirámide
%   laplaciana PIRL.

niveles = size(pirL,2);
%%%% COMPLETAR ESTA PARTE
im = pirL{niveles};
for i=niveles:-1:2
 % expandimos
 aux = impyramid(im,'expand');
 % ajustamos el tamaño
 a= size(aux, 2);
 b= size(pirL{i-1}, 2);
 aux = padarray(aux, abs(size(pirL{i-1})-size(aux)), 'replicate', 'post');
 c= size(aux, 2);
 %aux = padarray(aux, size(pirL{i})-size(aux), 'replicate', 'post');
 %aux = padarray(aux, size(aux)-size(im), 'replicate', 'post');
 % sumamos
 im = aux + pirL{i-1}; %gaussiana anterior(aux) + diferencias
end
