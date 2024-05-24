%Hace dos convoluciones conun filtro 1D (ganamos 1 D)

%Se genera un filtro gaussiano general
%se convoluciona cada una de las bandas
%rellenas con replicaci�n como hagan falta para hacer la convoluci�n
%horizontales
%se coloca la imagen como un vector horizontal
%se hace la convoluci�n 1D
%se vuelve al orden original
%se quita el borde vertical
%ahora se repite de manera vertical

%el resultado es 1 banda de la imagen completa
%se hace con las tres bandas

function f = miimgaussfilt270(im,sigma)
    %Gaussiana filtro separable
    %2 filtrados 1 d
    % generar filtro gaussiano horizontal
    h = filtrogaussiano(sigma);
    % La salida tiene el mismo tama�o que la entrada
    f = zeros(size(im));
    %para cada banda de la imagen (por si es una imagen en color)
    %se convoluciona cada una de las bandas
    for b=1:size(im,3)
        % relleno horizontal
        tamanorelleno = floor(size(h,2)/2);%redondeo
        rellena = padarray(im(:,:,b), [0 tamanorelleno],'replicate','both');
        %solo relleno en x
        % convertir a unidimensional por filas
        %se convierte en un vector fila para hacerlo 1d
        aux = reshape(rellena', [1,numel(rellena)]);
        % convolucionar en horizontal (devuelve el mismo tama�o)
        bandaf = micorr(aux,h);
        %correlaci�n y convoluci�n es igual porque el filtro es sim�trico
        % reconvertir a bidimiensional
        bandaf = reshape(bandaf,size(rellena'))';
        % eliminar el relleno
        bandaf = bandaf(:, tamanorelleno+1:end-tamanorelleno);
        %end es el ultimo pixel, size de banda f,2 (segunda dimensi�n)
        
        % relleno vertical
        rellena = padarray(bandaf, [tamanorelleno 0],'replicate','both');
        % convertir a unidimensional por columnas
        aux = reshape(rellena, [numel(rellena),1]);
        % convolucionar en vertical (devuelve el mismo tama�o)
        bandaf = micorr(aux,h');
        % reconvertir a bidimiensional
        bandaf = reshape(bandaf,size(rellena));
        % eliminar el relleno
        bandaf = bandaf(tamanorelleno+1:end-tamanorelleno,:);
        % Ponemos la banda filtrada en la imagen de salida
        f(:,:,b) = bandaf;
    end
end


function h = filtrogaussiano(sigma)
    % el radio 2*sigma contiene el 95,45% de la masa de la gaussiana
    radio = ceil(2*sigma);%redondeo
    % kernel gaussiano 1-D para filtrado separable
    X = (-radio:radio); % puntos en que se muestrea
    
    
    %%%% MODIFICAR AQUI %%%%
    % calcular los valores del filtro gaussiano. Recuerda que
    % h(i) = exp(-1/2 (x(i)^2)/(sigma^2)); % valor del filtro
    for(i=1:1:2*radio+1)%El filtro se supone impar as� que el tama�o del filtro es
                        %el valor del radio +1
    %h(i) = exp(-1/2 (X(i)^2)/(sigma^2));
    h(i) = exp(-1/2 *(X(i)^2)/(sigma^2));
    end
    %%%% HASTA AQUI %%%%
    
    % Eliminar los valores demasiado peque�os
    h(h<eps*max(h(:))) = 0;
    %eps es 1 por 10 elevado a -6
    % Normalizar para que sume 1
    sumH = sum(h(:));
    if sumH ~=0 % comprobaci�n de seguridad.
        h = h./sumH;
    end
end


%%%% Correlaci�n 1D. Solo calcula la zona v�lida aunque el tama�o de la 
%%%% se�al de salida es el mismo que el de la se�al de entrada
%Imagen rellenada unidimensional, filtro con tama�o 3 valores
%colocar filtro sobre la se�al en cada uno de los puntos
%hay que quedarse con la parte v�lida,comienzo mitad del filtro -1, justo
%en el borde.
%se mueve hasta la ultima v�lida =end -mf, xize(f,1)
%ese calculo se calcula con fy
%se coge un cacho de la imagen y se multiplica por el filtro y sumando el resultado
%de la multiplicaci�n pixel a pixel por el filtro
function f = micorr(x,h)   
    % tama�o del relleno: mitad del tama�o del filtro
    mf = floor(numel(h)/2);
    % La salida tiene el mismo tama�o que la entrada
    f = zeros(size(x));
    % Para la zona de la se�al v�lida
    for i = mf+1:numel(x)-mf % Esto recorre desde K/2+1 a el tama�o de la imagen - K/2
    %que son las posiciones donde el filtrado tiene valores de inter�s
        
        %%%% MODIFICAR AQUI %%%%
        % calcular el valor de la correlaci�n en la posici�n i de x
        %x es un vector fila
        
        %K/2 es mf, k es el indice de la sumatoria
        
        %Sin embargo esta k, �ndice de la sumatoria no aparece, se ha hecho
        %una transformaci�n. Respecto a la f�rmula vista en clase que va de
        %k=-k a k=+k se le suma k+1 a todo para que la sumatoria recorra
        %desde 1 hasta 2k+1. Una vez hecho esto uno debe ver que los
        %valores de i(pixeles) para la imagen de los que hay que realizar
        %la sumatoria multiplicada por el filtro son los que est�n en el 
        %rango de i=i-la mitad del tama�o del filtro (mf) a i=i+ la mitad
        %del tama�o del filtro(mf), por ello la sumatoria que representa
        %el valor de la correlaci�n est� descrita por la f�rmula siguiente
        f(i)=sum(h.*x(i-mf:i+mf));
        %%%% HASTA AQUI %%%%
                
    end
end


