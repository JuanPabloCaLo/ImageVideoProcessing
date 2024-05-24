%Script PFINAL Prueba 1

%% Lectura de imágenes
img1='picturesandxy/isabelcatolica1.jpg';
img2='picturesandxy/isabelcatolica2.jpg';

imagen1=im2double(imread(img1));
imagen2=im2double(imread(img2));


%% Pre Transformaciones

%Las imágenes RGB se leen como y, x, valorescolores;
imagen1=imagen1(500:3472,1:4624,1:3);%borde vertical
imagen1=imagen1(:,500:4124,1:3);%borde horizontal
imshow(imagen1);
imagen11=imresize(imagen1, [403, 560]);
imagen22=imresize(imagen2, [403, 560]);

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
imshow(Jregistered);

%% Inter trasnformaciones

%% Creación imagen final

imagen3=zeros(403, 560, 3);
Jregistered=Jregistered(1:412, 1:542,1:3);
Jregisteredsized=imresize(Jregistered,[403,560]);
imshow(Jregisteredsized);
%Jregisteredcut=Jregistered[];
%la homografía se cambia al tamaño de nuestras imágenes

imagen3(1:201,1:560,:)=imagen22(1:201,1:560,:);
imagen3(202:403,1:560,:)=Jregisteredsized(202:403, 1:560,:);
%Colocamos las imágenes en la imagen final

%% Post transformaciones

imagen31=imagen3(1:350,:,:);
imagen32=imagen31(:,250:560,:);
imagen32=imresize(imagen32,[600, 600]);


%% Mostrar imagenes
figure 
imshow(imagen11);
title('imagen11');

figure 
imshow(imagen22);
title('imagen22');

figure 
imshow(imagen31);
title('imagen31');

figure 
imshow(imagen32);
title('imagen32');

%% Guardado resultado

imwrite(imagen31, 'resultadocatolica1.jpg');
imwrite(imagen32, 'resultadocatolica2.jpg');