%Script PFINAL Prueba 1

%% Lectura de imágenes
img1='picturesandxy/bibrambla_antigua1.jpg';
img2='picturesandxy/bibrambla_nueva1.jpg';

figure
imagen1=im2double(imread(img1));
imshow(imagen1);
figure
imagen2=im2double(imread(img2));
imshow(imagen2);

%% Pre Transformaciones

%Las imágenes RGB se leen como y, x, valorescolores;
imagen2=imagen2(75:599,1:798,1:3);%borde vertical
imagen2=imagen2(:,1:760,1:3);%borde horizontal
imshow(imagen2);

%% Resize
figure
imagen11=imresize(imagen1, [400, 600]);
imshow(imagen11)
figure
imagen22=imresize(imagen2, [400, 600]);
imshow(imagen22)

%% Indicación de los puntos de correspondencia con archivos xy
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
    
%Las esquinas se añaden para que toda la imagen esté cubierta    
%esquinas = [1,1; 500,1; 1,250; 500,250]; 
%puntos1 = [esquinas ; puntos1];
%puntos2 = [esquinas ; puntos2];


%% Cálculo homografía
transformacion=fitgeotrans(puntos1, puntos2,'projective');

%Se aplica la homografía
Jregistered = imwarp(imagen11,transformacion);
%Se muestra la imagen con la homografía aplicada
Jregistered=imresize(Jregistered, [424, 630]);
figure
imshow(Jregistered);

%% Inter trasnformaciones

%% Creación imagen final

imagen3=zeros(424, 642, 3);
%Jregistered=Jregistered(213:398, 1:612,1:3);
%figure
%imshow(Jregistered)
%Jregisteredsized=imresize(Jregistered,[400,600]);
%imshow(Jregisteredsized);
%Jregisteredcut=Jregistered[];
%la homografía se cambia al tamaño de nuestras imágenes

imagen22=imresize(imagen22, [400,610]);
%Jregisteredresized=imresize(Jregistered, [424, 613]);

%%
imagen3(1:200,1:600,:)=imagen22(1:200,1:600,:);
imagen3(201:424,1:613,:)=Jregistered(201:424, 18:630,:);
figure
imshow(imagen3)
%imagen3(201:400,1:600,:)=Jregisteredsized(201:400, 1:600,:);
%Colocamos las imágenes en la imagen final

%% Post transformaciones

figure
imagen4=imagen3(:, 65:642, :);
imshow(imagen4);

%% 
figure
imagen5=imagen4(1:416,1:520,:);
imshow(imagen5)


%% Guardado resultado

imwrite(imagen5, 'resultado_bibrambla_BUENO_FINAL.jpg');