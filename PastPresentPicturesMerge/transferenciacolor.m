function transferida = transferenciacolor(origen,destino)
%Transferencia de color como funci�n
%   Transfiere la codificaci�n de color de una imagen a otra.
%% Aplicamos Reinhard

transferida = reinhard(origen, destino);
%codificaci�n color = destino
%imagen =origen
end

