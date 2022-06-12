    function [centerX,centerY,circleSize]  = imagePoint(img,k) % img = imagePoint(img)
    %% SENSE
    %% PROCESS
    % Object detection algorithm
    path_imageRes='/home/rayane/catkin_ws/src/bebop_pkg/bag_files/circled_Images';

    resizeScale = 0.5;
    [centerX,centerY,circleSize] = detectCircle(img,resizeScale);
    % Object tracking algorithm
    %    [v,w] = trackCircle(centerX,circleSize,size(img,2),params);
    

   img1 = insertShape(img,'Circle',[centerX centerY circleSize/2],'color','magenta','LineWidth',2);
%    
    image = insertMarker(img1,[centerX,centerY],'s','color','magenta','size',3);
    image = insertMarker(image ,[centerX,centerY],'*','color','magenta','size',2);

       filename = sprintf('%dcircled',k);
    imshow(image)
    drawnow
    pth=[path_imageRes, filename '.png'];
   imwrite( uint8(image),fullfile(path_imageRes,filename),'png');
end
