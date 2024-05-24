function transferida = transferenciacolor(origen,destino)
%Transferencia de color como función
%   Transfiere la codificación de color de una imagen a otra.
%% Aplicamos Reinhard

transferida = reinhard(origen, destino);
%codificación color = destino
%imagen =origen
end

