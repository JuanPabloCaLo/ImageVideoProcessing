%Script PFINAL Prueba Catedral

%% Lectura de im�genes
img1='picturesandxy/catedral3.jpg';
img2='picturesandxy/catedral4.jpg';

imagen1=im2double(imread(img1));
imagen2=im2double(imread(img2));



%% Pre Transformaciones

%Las im�genes RGB se leen como y, x, valorescolores;
imagen2=imagen2(1000:3472,:,:);%borde vertical
imagen2=imagen2(:,1130:4624,:);%borde horizontal
figure
imshow(imagen1);
figure
imshow(imagen2);
imagen11=imresize(imagen1, [1216, 1968]);
imagen22=imresize(imagen2, [1216, 1968]);

%% Filtrado
sigma=3;
imagen11=imgaussfilt(imagen11, sigma);
imagen22=imgaussfilt(imagen22, sigma);

%% Transferencia color

%% Elecci�n imagen para aplicar transferencia de color
elija="Que imagen marcar� los resultados de transferencia de color";
%La de destino
elige=input(elija);
%elige='1';
if strcmp(elige,'uno')
    disp("opcion1")
    transferida=transferenciacolor(imagen22,imagen11);
    %1 origen 2 destino
    %Si la imagen 1 es la que marca el color ser� la de destino
    imagen22= transferida;
elseif strcmp(elige,'dos')
    disp("opcion2")
    transferida=transferenciacolor(imagen11,imagen22);
    imagen11=transferida;
    %1 origen 2 destino'
    %Si la imagen 2 es la que marca el color ser� la de destino
    disp(transferida);
else
    disp("No habr� transferencia de color");
end 

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
    



%% C�lculo homograf�a
transformacion=fitgeotrans(puntos1, puntos2,'similarity');

%Se aplica la homograf�a
Jregistered = imwarp(imagen11,transformacion);
%Se muestra la imagen con la homograf�a aplicada
imshow(Jregistered);

%% Inter trasnformaciones

%% Creaci�n imagen final

imagen3=zeros(1216, 1968, 3);
imagen22=imagen22(1:745, 1:1527,1:3); %post corte

Jregisteredsized=imresize(Jregistered,[1216,1968]);
imagen22=imresize(imagen22,[1216,1968]);
%la homograf�a se cambia al tama�o de nuestras im�genes

imagen3(1016:1216,1:1968,:)=imagen22(1016:1216,1:1968,:);%parte h de abajo
imagen3(1:200,1:1968,:)=imagen22(1:200,1:1968,:);%parte h de arriba
imagen3(:,1668:1968,:)=imagen22(:,1668:1968,:);%parte v derecha
imagen3(:,1:300,:)=imagen22(:,1:300,:);%parte v izquierda

imagen3(201:1015,301:1667,:)=Jregisteredsized(201:1015,301:1667,:);

%Colocamos las im�genes en la imagen final

%% Post transformaciones


%% Mostrar imagenes
figure 
imshow(imagen11);
title('imagen11');

figure 
imshow(imagen22);
title('imagen22');

figure 
imshow(imagen3);
title('imagen3');

%% Guardado resultado

%imwrite(imagen3, 'catedralresultado1.jpg');