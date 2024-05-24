%% Pir�mide Gaussiana y Laplaciana
%se repite la matriz 1 vez en la primera y segunda y en la tercera
%dimensi�n tres veces -> RGB
%con el filtrogaussiano quitas altas frecuencias asi que las pierdes
%con tama�os impares de pixeles la imagen expandida y de nuevo reducida no
%tienen el mismo tama�o
%cell arrays porque las imagenes no tienen las mismas dimensiones asi que
%no se pueden guardar n+1= nivel final +1  nivel 1 primero.
%6 niveles

%Laplaciana Nivel m�s alto piramide laplaciana = nivel m�s alto gaussiana
%diferencias entre la expansi�n del nivel anterior y  la expandida de la
%gaussiana de m�s alto nivel.

A = im2double(imread('images/orange.jpeg'));
B = im2double(imread('images/apple.jpeg'));
M = im2double(imread('images/mascara.png'));

if size(M,3)==1 % Si la m�scara no es RGB, convertir a RGB replicando
    M = repmat(M,[1,1,3]); %1 vez en cada dimensi�on y 3 veces (R G B)
end

% Unir las im�genes una junto a otra
union = A .* (1-M) + B .* M;

% Unirlas emborronando la m�scara
Mb = imfilter(M, fspecial('gaussian', 45, 11),'replicate');
unionborrosa = A .* (1-Mb) + B .* Mb;

%% Fusi�n de pir�mides laplacianas

% Calcular el n�mero de niveles
niveles = floor(log2(min(size(A(:,:,1)))));
%El logaritmo de 2 es algo es el n�mero de veces que puedes dividir por 2
%%
% Crear las pir�mides laplacianas de las im�genes y la pir�mide
% gaussiana de la m�scara

%%
%% COMPLETAR ESTA PARTE
ApirL = piramide_laplaciana(A, niveles);
BpirL = piramide_laplaciana(B, niveles);
MpirG = piramide_gaussiana(M, niveles);
figure(1)
imshow(montaje_piramide(ApirL,true))
figure(2)
imshow(montaje_piramide(BpirL,true))
figure(3)
imshow(montaje_piramide(MpirG,true))
%%%% HASTA AQUI
%%
CpirL = cell(1, numel(ApirL));
%fundir las pir�mides laplacianas
for i = 1 : length(ApirL)
    %%%% COMPLETAR ESTA PARTE
    CpirL{i} = ApirL{i} .* (1-MpirG{i}) + BpirL{i} .* MpirG{i};
    %%%% HASTA AQUI
end

% Create final blended image
fusionlaplaciana = rebuild(CpirL);


%% Mostrar las im�genes
figure(4);
subplot(2,3,1); imshow(A); title('Primera imagen');
subplot(2,3,2); imshow(B); title('Segunda imagen');
subplot(2,3,3); imshow(M); title('M�scara');
subplot(2,3,4); imshow(union); title('Uni�n simple');
subplot(2,3,5); imshow(unionborrosa); title('Uni�n borrosa');
subplot(2,3,6); imshow(fusionlaplaciana); title('Fusi�n de pir�mides laplacianas');
truesize