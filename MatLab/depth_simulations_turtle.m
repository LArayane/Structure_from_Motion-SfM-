% LMIs2
LMIsISS
%%
path_imageRes='/home/rayane/catkin_ws/src/bebop_pkg/bag_files/circled_Images';
dpt1 = []; dpt2 = [];
pixels = [];
tTime = [];
pix = [];
a = dir('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/rgb_Images/*.png');
n = numel(a);
 
Pf = '/home/rayane/catkin_ws/src/bebop_pkg/bag_files/rgb_Images';
S  = dir(fullfile(Pf,'*.png'));
Nn = {S.name};
Nf  = natsortfiles({S.name});
delete('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/rgb_Images/*.ini')

Pd = '/home/rayane/catkin_ws/src/bebop_pkg/bag_files/depth_Images';
Sd  = dir(fullfile(Pd,'*.png'));
Nnd = {Sd.name};
Nd  = natsortfiles({Sd.name});
delete('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/depth_Images/*.ini')

ad = dir('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/depth_Images/*.png');
nd = numel(ad);

P_rgb = '/home/rayane/catkin_ws/src/bebop_pkg/bag_files/rgb_Images/';
P_depth = '/home/rayane/catkin_ws/src/bebop_pkg/bag_files/depth_Images/';
deb = 70;
 for k= deb:n
      image_rgb  =  strcat(P_rgb,Nf{k});
     
      %image_depth  =  strcat(P_depth,Nd{1});
      image_rgb = imread(image_rgb);
           
      
 [centerX centerY circleSize] = imagePoint(image_rgb,k);

 pix = [pix; [centerX , centerY]];
%  pixels = [pixels; [centerX-321 , centerY-241]];
%  pixels = [pixels; [centerX- 320.6512 , centerY-240.0127]];

% image = insertShape(image_rgb,'Circle',[centerX centerY circleSize/2],'LineWidth',2);
 % imshow(image);
  
   if(nd>k)
      image_depth  =  strcat(P_depth,Nd{k});
      image_depth = imread(image_depth);
       
 if(centerX ~= 0 )
 chi = image_depth(round(centerY,0),round(centerX,0));
% chi2 = image_depth2(round(centerY,0),round(centerX,0));
 end
  if(centerX == 0 )
 chi = 0;
% chi2 = image_depth2(round(centerY,0),round(centerX,0));
 end
 dpt1 = [dpt1 chi];
  end
 %dpt2 = [dpt2 chi];
%  filename = sprintf('%dcircled',k);
%  pth=[path_imageRes, filename '.png'];
%  imwrite( uint8(image),fullfile(path_imageRes,filename),'png');
tTime = [tTime (str2double(Nn{k}(1:19))-str2double(Nn{deb}(1:19)))/10^9];
 k=k+1;
 end


 K =[  547.8518     0     320.6512;
       0     548.4034  240.0127;
        0         0     1.0000];    
% K=[547.967429 0.000000 381.263065
% 0.000000 538.792387 183.054628
% 0.000000 0.000000 1.000000];

% K = [534.974966, 0.000000, 428.803657;0.000000, 523.727954, 240.299824; 0.000000, 0.000000, 1.000000];
Pixels.time = tTime;%(deb:end);%-tTime(deb);%tTime;%(1:end-2,:);;
XYvalues = inv(K)*[pix,ones(length(pix),1)]';;% inv(K)*[pix(deb:end,:),ones(length(pix(deb:end,:)),1)]';
XYvalues=XYvalues(1:2,:);
Pixels.signals.values = XYvalues';

%  Pixels.signals.values(:,1) = smoothdata(Pixels.signals.values (deb:end,1),'rloess',30);
% Pixels.signals.values(:,2) = smoothdata(Pixels.signals.values (deb:end,2),'rloess',30);
%%
pick = input('Enter a number: 1 for vicon and 2 for bebop');

switch pick
    case 1
        disp('vicon')
    otherwise
        disp('turtle')
end
%%
if (pick == 1)
%LMIs_
V = [];
Om = [];
VELO = [];
imagePoints = [];
pixelPoints = [];
tTime = [];
Angles = [];
angDiff = [];
VV  = [];
III = [];


Pf  = '/home/rayane/catkin_ws/src/bebop_pkg/bag_files/rgb_Images';
S  = dir(fullfile(Pf,'*.png'));
Nn = {S.name};
Nf  = natsortfiles({S.name});

bagdataorientationcamera =  importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_orientation_camera_vicon.txt');
bagdatatranslationcamera =  importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_translation_camera_vicon.txt');
bagdatacmdvelcameralinear =   importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_cmd_vel_camera_linear.txt');
bagdatacmdvelcameraangular =  importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_cmd_vel_camera_angular.txt');

for i=2:5
bagdataorientationcamera.data(:,i) =  smoothdata(bagdataorientationcamera.data(:,i),'rloess',30);
end
for i=2:4
bagdatatranslationcamera.data(:,i) =  smoothdata(bagdatatranslationcamera.data(:,i),'rloess',30);
bagdatacmdvelcameralinear.data(:,i) =  smoothdata(bagdatacmdvelcameralinear.data(:,i),'rloess',30);
bagdatacmdvelcameraangular.data(:,i) =  smoothdata(bagdatacmdvelcameraangular.data(:,i),'rloess',30);
end
n = dir('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/rgb_Images/*.png');
a = numel(n);
% cameraInfo = importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/rgb_camera_info.txt');
simTime=(str2double(Nn{end}(1:19))-str2double(Nn{deb}(1:19)))/10^9;

%step:70%
b = 1;

for k = deb:length(Nn)-1
    getIn = 0 ;
    for lp = b:length(bagdatacmdvelcameralinear.data)
        angT = bagdatacmdvelcameralinear.data(lp,1);
        Tm = str2double(Nn{k}(1:19));
        if (Tm-angT < 0 && getIn==0)
            getIn = 1;
            if lp==1
                i=1;
            else
            i = lp-1;
            end
            b = lp;
            q1 = bagdataorientationcamera.data(i,2);
            q2 = bagdataorientationcamera.data(i,3);
            q3 = bagdataorientationcamera.data(i,4);
            q4 = bagdataorientationcamera.data(i,5);
            
            trans = bagdatatranslationcamera.data(i,2:4);
            quat = [q4 q1 q2 q3];
            eulZYX = quat2eul(quat);
            ang = radtodeg(eulZYX);
            Angles = [Angles ; ang];
            rotm = eul2rotm(eulZYX);
            vlin = bagdatacmdvelcameralinear.data(i,2:4);
            omega = bagdatacmdvelcameraangular.data(i,2:4)*(180/pi);% % %
            VV  = [VV; bagdatatranslationcamera.data(i,2:4)];
            v_cam = [inv(rotm)*vlin'];
            om_cam = [inv(rotm)*omega'];
            III = [III i];
            V = [V ; v_cam'];
            Om = [Om ; om_cam'];
            VELO = [VELO ; [v_cam' om_cam']];
            tTime = [tTime ; [(str2double(Nn{1+k}(1:19))-str2double(Nn{deb}(1:19)))/10^9]];
        end
       end
  % k
end
%VELO(:,5)=VELO(:,5)*2;
figure
subplot(2,3,1)
plot(VELO(1:end,1))
grid on
subplot(2,3,2)
plot(VELO(1:end,2))
grid on
subplot(2,3,3)
plot(VELO(1:end,3))
grid on
subplot(2,3,4)
plot(VELO(1:end,4))
grid on
subplot(2,3,5)
plot(VELO(1:end,5))
grid on
subplot(2,3,6)
plot(VELO(1:end,6))
grid on
sgtitle('Vicon measurements all velocities')

dep=1;
VEL.time = tTime(deb:end)-tTime(deb);
VEL.signals.values =  VELO(deb:end,:);


else
%%

V = [];
Om = [];
VELO = [];
imagePoints = [];
pixelPoints = [];
tTime = [];
Angles = [];
angDiff = [];
VV  = [];

turtlelinear =   importdata('/media/rayane/USB DISK/bag_data_cmd_vel_turtle_linear.txt');
turtleangular =  importdata('/media/rayane/USB DISK/bag_data_cmd_vel_turtle_angular.txt');
bagdataorientationodom= importdata('/media/rayane/USB DISK/bag_data_orientation_odom_angular.txt');
bagdatatranslationodom= importdata('/media/rayane/USB DISK/bag_data_position_odom_angular.txt');
bagdatacmdvelodomlinear= importdata('/media/rayane/USB DISK/bag_data_cmd_vel_odom_linear.txt');
bagdatacmdvelodomangular= importdata('/media/rayane/USB DISK/bag_data_cmd_vel_odom_angular.txt');

for i=2:4
turtlelinear.data(:,i) =  smoothdata(turtlelinear.data(:,i),'rloess',30);
turtleangular.data(:,i) =  smoothdata(turtleangular.data(:,i),'rloess',30);
bagdatatranslationodom.data(:,i)= smoothdata(bagdatatranslationodom.data(:,i),'rloess',30);
bagdatacmdvelodomlinear.data(:,i)= smoothdata(bagdatacmdvelodomlinear.data(:,i),'rloess',30);
bagdatacmdvelodomangular.data(:,i)= smoothdata(bagdatacmdvelodomangular.data(:,i),'rloess',30);
end 
for i=2:5
bagdataorientationodom.data(:,i)= smoothdata(bagdataorientationodom.data(:,i),'rloess',30);
end
b = 1;
% deb = 1;%1300;
for k = deb:length(Nn)-1
    getIn = 0 ;
    for lp = b:length(turtlelinear.data)
        angT = turtlelinear.data(lp,1);
        Tm = str2double(Nn{k}(1:19));
        if (Tm-angT < 0 && getIn==0)
            getIn = 1;
            if lp==1
                i=1;
            else
            i = lp-1;
            end
            b = lp;
            %%%RPY

            v_cam = [turtlelinear.data(i,2:4)'];
            om_cam = [turtleangular.data(i,2:4)'];

            V = [V ; v_cam'];
            Om = [Om ; om_cam'];
            VELO = [VELO ; [v_cam' om_cam']];
            tTime = [tTime ; [(str2double(Nn{k}(1:19))-str2double(Nn{deb}(1:19)))/10^9]];
          end
        
    end
    
end
%     
figure
subplot(2,3,1)
plot(VELO(:,1))
grid on
subplot(2,3,2)
plot(VELO(:,2))
grid on
subplot(2,3,3)
plot(VELO(:,3))
grid on
subplot(2,3,4)
plot(VELO(:,4))
grid on
subplot(2,3,5)
plot(VELO(:,5))
grid on
subplot(2,3,6)
plot(VELO(:,6))
grid on
sgtitle('turtle measurements ros computation')
% deb = 1;
VEL.time = tTime;%(deb:end);%-tTime(deb);      
VEL.signals.values =  VELO;%(deb:end,:);

end
%%

%LMIs_
V = [];
Om = [];
VELO = [];
imagePoints = [];
pixelPoints = [];
tTime = [];
Angles = [];
angDiff = [];
VV  = [];
III = [];

bagdataorientationcamera =  importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_orientation_camera_vicon.txt');
bagdatatranslationcamera =  importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_translation_camera_vicon.txt');
bagdatacmdvelcameralinear =   importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_cmd_vel_camera_linear.txt');
bagdatacmdvelcameraangular =  importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_cmd_vel_camera_angular.txt');


bagdataorientationpoint =  importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_orientation_point_vicon.txt');
bagdatatranslationpoint =  importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_translation_point_vicon.txt');
bagdatacmdvelpointlinear =   importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_cmd_vel_point_linear.txt');
bagdatacmdvelpointangular =  importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/bag_data_cmd_vel_point_angular.txt');

bagdataorientationcamera.data(:,2:5) =  smoothdata(bagdataorientationcamera.data(:,2:5),'rloess',30);
bagdatatranslationcamera.data(:,2:4) =  smoothdata(bagdatatranslationcamera.data(:,2:4),'rloess',30);
bagdatacmdvelcameralinear.data(:,2:4) =  smoothdata(bagdatacmdvelcameralinear.data(:,2:4),'rloess',30);
bagdatacmdvelcameraangular.data(:,2:4) =  smoothdata(bagdatacmdvelcameraangular.data(:,2:4),'rloess',30);


bagdataorientationpoint.data(:,2:5) =  smoothdata(bagdataorientationpoint.data(:,2:5),'rloess',30);
bagdatatranslationpoint.data(:,2:4) =  smoothdata(bagdatatranslationpoint.data(:,2:4),'rloess',30);
bagdatacmdvelpointlinear.data(:,2:4) =  smoothdata(bagdatacmdvelpointlinear.data(:,2:4),'rloess',30);
bagdatacmdvelpointangular.data(:,2:4) =  smoothdata(bagdatacmdvelpointangular.data(:,2:4),'rloess',30);

n = dir('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/rgb_Images/*.png');
a = numel(n);
% cameraInfo = importdata('/home/rayane/catkin_ws/src/bebop_pkg/bag_files/rgb_camera_info.txt');
% simTime=(str2double(Nn{end}(1:19))-str2double(Nn{1}(1:19)))/10^9;

%step:70%
b = 1;
depo = []; 
Angles = []; 
for k = deb:length(Nn)-1
    getIn = 0 ;
    for lp = b:length(bagdatatranslationpoint.data)
        angT = bagdatacmdvelcameralinear.data(lp,1);
        Tm = str2double(Nn{k}(1:19));
        if (Tm-angT < 0 && getIn==0)
            getIn = 1;
            if lp==1
                i=1;
            else
            i = lp-1;
            end
            b = lp;
            q1 = bagdataorientationcamera.data(i,2);
            q2 = bagdataorientationcamera.data(i,3);
            q3 = bagdataorientationcamera.data(i,4);
            q4 = bagdataorientationcamera.data(i,5);
            
            trans = bagdatatranslationcamera.data(i,2:4);
            quat = [q4 q1 q2 q3];
            eulZYX = quat2eul(quat);
            ang = radtodeg(eulZYX);
            Angles = [Angles ; ang];
            rotm = eul2rotm(eulZYX)
        %    tTime = [tTime ; [(str2double(Nn{1+k}(1:19))-str2double(Nn{1}(1:19)))/10^9]];
            
            posKinect = bagdatatranslationcamera.data(i,2:4)
            posPoint = bagdatatranslationpoint.data(i,2:4);
            posPointKinect = inv(rotm)*posPoint'-inv(rotm)*posKinect';            
            depo = [depo posPointKinect(3)];   
            tTime = [tTime ; [(str2double(Nn{1+k}(1:19))-str2double(Nn{deb}(1:19)))/10^9]];
            
        end
        
       end
  
end
Depth.time = tTime;
Depth.signals.values = 1./depo';
Depth.signals.values= Depth.signals.values(1:length(Depth.time),1);
Depth.signals.values = smoothdata(Depth.signals.values,'rloess',30);
conIN = [Pixels.signals.values(1,:)'; 1./depo(1)'];
simTime = Pixels.time(end);
%%
data = sim('simu_depth', 20)

Time = data.simout.Data(:,1);
data_chi_est = data.simout.Data(:,13);
data_chi =  data.simout.Data(:,14);
data_velo =  data.simout.Data(:,2:7);
% data_chi_est = smoothdata(data_chi_est,'rloess',(30));
line_width_r=2;
line_width_b=1.5;
Save=1;
police=17;%24;
police_axis=13;

figure;grid on;
plot(Time,data_chi,'b','linewidth',1);
hold on, grid on
plot(Time,data_chi_est,'--r','linewidth',1.5);
legend({'$\chi_{real}$','$\chi_{estimated}$'},'FontSize', police,'Interpreter','latex')
xlabel('\textrm{time \,\,[s]}','FontSize', police,'Interpreter','LaTex');
% axes('Position',[.4 .3 .3 .3])
% box on
% indexesInRange = find(Time>= 7 & Time < Time(end));
% subdata_chi_est = data_chi_est(indexesInRange);
% subdata_chi = data_chi(indexesInRange);
% plot(Time(indexesInRange),subdata_chi, 'b');
% hold on
% plot(Time(indexesInRange),subdata_chi_est, '--r');
% grid on
set(gca,'fontsize',police_axis)

figure;grid on;
plot(Time,1./data_chi,'b','linewidth',1);
hold on, grid on
plot(Time,1./data_chi_est,'--r','linewidth',1.5);
legend({'$Z_{real}$','$Z_{estimated}$'},'FontSize', police,'Interpreter','latex')
xlabel('\textrm{time \,\,[s]}','FontSize', police,'Interpreter','LaTex');
set(gca,'fontsize',police_axis)

figure;grid on;
plot(Time,data_chi-data_chi_est,'b','linewidth',1);
 grid on
legend({'$error$'},'FontSize', police,'Interpreter','latex')
set(gca,'fontsize',police_axis)
