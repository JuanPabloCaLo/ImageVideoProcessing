%Script PFINAL Prueba 1

%% Lectura de im�genes
img1='picturesandxy/santaana_antigua.jpg';
img2='picturesandxy/santaana_nueva.jpg';

figure
imagen1=im2double(imread(img1));
imshow(imagen1);
figure
imagen2=im2double(imread(img2));
imshow(imagen2);

%% Pre Transformaciones

%Las im�genes RGB se leen como y, x, valorescolores;
imagen2=imagen2(400:3850,1:6000,1:3);%borde vertical
imagen2=imagen2(:,500:6000,1:3);%borde horizontal
imshow(imagen2);

%% Resize
figure
imagen11=imresize(imagen1, [600, 900]);
imshow(imagen11)
figure
imagen22=imresize(imagen2, [600, 900]);
imshow(imagen22)

%% Indicaci�n de los puntos de correspondencia con archivos xy
%Puntos de correspondencia

if exist([img1,'.xy'], 'file')
    puntos1 = dlmread([img1,'.xy']);
    puntos2 = dlmread([img2,'.xy']);
    %Suponemos que existen los dos si existe uno de ellos
else                
[puntos1, puntos2] = cpselect(imagen11, imagen22, 'Wait', true);
    dlmwrite([img1,'.xy'], puntos1);
    dlmwrite([img2,'.xy'], puntos2);
end    
    
%Las esquinas se a�aden para que toda la imagen est� cubierta    
%esquinas = [1,1; 500,1; 1,250; 500,250]; 
%puntos1 = [esquinas ; puntos1];
%puntos2 = [esquinas ; puntos2];


%% C�lculo homograf�a
transformacion=fitgeotrans(puntos1, puntos2,'projective');

%Se aplica la homograf�a
Jregistered = imwarp(imagen11,transformacion);
%Se muestra la imagen con la homograf�a aplicada
imshow(Jregistered);

%% Creaci�n imagen final

imagen3=zeros(627, 915, 3);
Jregistered=Jregistered(300:641, 10:944,1:3);
figure
imshow(Jregistered)

%%
%Jregisteredsized=imresize(Jregistered,[600,900]);
%imshow(Jregisteredsized);
%Jregisteredcut=Jregistered[];
%la homograf�a se cambia al tama�o de nuestras im�genes

imagen3(1:285,1:900,:)=imagen22(1:285,1:900,:);
imagen3(286:627,1:915,:)=Jregistered(1:342, 1:915,:);
figure
imshow(imagen3)
%imagen3(201:400,1:600,:)=Jregisteredsized(201:400, 1:600,:);
%Colocamos las im�genes en la imagen final

%% Post transformaciones

imagen31=imagen3(1:627,150:915,:);
figure
imshow(imagen31)
%imagen32=imagen31(:,250:560,:);
%imagen32=imresize(imagen32,[600, 600]);

%%
figure
imagen4=imagen31(1:612,1:752,:);
imshow(imagen4)

%% Guardado resultado

imwrite(imagen4, 'resultado_santaana_BUENO_FINAL.jpg');
