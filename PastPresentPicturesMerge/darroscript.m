%Script PFINAL Prueba Darro

%% Lectura de imágenes
img1='picturesandxy/darro2.jpg';
img2='picturesandxy/darroyo.jpg';

imagen1=im2double(imread(img1));
imagen2=im2double(imread(img2));



%% Pre Transformaciones

%Las imágenes RGB se leen como y, x, valorescolores;
imagen2=imagen2(500:3472,1:4624,1:3);%borde vertical
imagen2=imagen2(:,1300:4100,1:3);%borde horizontal
figure
imshow(imagen1);
figure
imshow(imagen2);
imagen11=imresize(imagen1, [580, 550]);
imagen22=imresize(imagen2, [580, 550]);

%% Filtrado
%sigma=3;
%imagen11=imgaussfilt(imagen11, sigma);
%imagen22=imgaussfilt(imagen22, sigma);

%% Transferencia color

%% Elección imagen para aplicar transferencia de color
elija="Que imagen marcará los resultados de transferencia de color";
%La de destino
elige=input(elija);
%elige='1';
if strcmp(elige,'uno')
    disp("opcion1")
    transferida=transferenciacolor(imagen22,imagen11);
    %1 origen 2 destino
    %Si la imagen 1 es la que marca el color será la de destino
    imagen22= transferida;
elseif strcmp(elige,'dos')
    disp("opcion2")
    transferida=transferenciacolor(imagen11,imagen22);
    imagen11=transferida;
    %1 origen 2 destino
    %Si la imagen 2 es la que marca el color será la de destino
    disp(transferida);
else
    disp("No habrá transferencia de color");
end 

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

imagen3=zeros(580, 550, 3);
Jregistered=Jregistered(1:605, 1:542,1:3); %post corte
Jregisteredsized=imresize(Jregistered,[580,550]);
%imshow(Jregisteredsized);
%Jregisteredcut=Jregistered[];
%la homografía se cambia al tamaño de nuestras imágenes

imagen3(1:290,1:275,:)=imagen22(1:290,1:275,:);
imagen3(1:290,276:550,:)=Jregisteredsized(1:290,276:550,:);
imagen3(291:580,1:275,:)=Jregisteredsized(291:580, 1:275,:);
imagen3(291:580,276:550,:)=imagen22(291:580, 276:550,:);
%Colocamos las imágenes en la imagen final

%% Post transformaciones

imagen31=imagen3(30:560,:,:);
imagen32=imagen31(:,30:550,:);

%% Mostrar imagenes
figure 
imshow(imagen11);
title('imagen11');

figure 
imshow(imagen22);
title('imagen22');

figure 
imshow(imagen32);
title('imagen32');

figure 
imshow(imagen3);
title('imagen3');

%% Guardado resultado

imwrite(imagen32, 'darroresultadotcolor2.jpg');