%%Script que crea el video a partir de la serie de imágenes
a=1;
videobj = VideoWriter('videoavatarjuampi', 'MPEG-4');
videobj.FrameRate=9;
open(videobj);
for i=1:1:20
  str=sprintf('morphingjpavatar%d.png',a);  
  stra = im2double(imread(str));
  
  a=a+1;
  
  writeVideo(videobj, stra);
end
for i=1:1:20
  a=a-1;
  
  str=sprintf('morphingjpavatar%d.png',a);  
  stra = im2double(imread(str));
  
  writeVideo(videobj, stra);
end
close(videobj);

%vidobj = VideoWriter('video_sin_comprimir', 'Uncompressed AVI');
%open(vidobj);

%for i = 1: nframesmov
 %img = frame2im(mov_neg(i));
 %writeVideo(vidobj,img);
%end
%close(vidobj);