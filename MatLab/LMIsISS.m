%  clear all
% gamma=sdpvar(1,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Lg
C  = [1 0 0; 0 1 0];
Lg=[];
p1_min  = -1;
p1_max  = 1;
p2_min  = -1;
p2_max  = 1;
p3_min  = -0.5;
p3_max  = 0.5;


A1 = [0 0 p1_min; 0 0 p2_min; 0 0 p3_min]; %min, min, min
A2 = [0 0 p1_min; 0 0 p2_max; 0 0 p3_min]; %min, max, min
A3 = [0 0 p1_min; 0 0 p2_min; 0 0 p3_max]; %min, min, max
A4 = [0 0 p1_min; 0 0 p2_max; 0 0 p3_max]; %min, max, max
A5 = [0 0 p1_max; 0 0 p2_min; 0 0 p3_min]; %max, min, min
A6 = [0 0 p1_max; 0 0 p2_max; 0 0 p3_min]; %max, max, min
A7 = [0 0 p1_max; 0 0 p2_min; 0 0 p3_max]; %max, min, max
A8 = [0 0 p1_max; 0 0 p2_max; 0 0 p3_max]; %max, max, max
% AM={A1,A2,A3,A4,A5,A6,A7,A8};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

K1 = sdpvar(3,2,'full');
K2 = sdpvar(3,2,'full');
K3 = sdpvar(3,2,'full');
K4 = sdpvar(3,2,'full');
K5 = sdpvar(3,2,'full');
K6 = sdpvar(3,2,'full');
K7 = sdpvar(3,2,'full');
K8 = sdpvar(3,2,'full');
Q = sdpvar(3,3);
P = sdpvar(3,3);
ep = sdpvar(1,1);
beta= 30;
alfa= 10;
% beta= 300;
% alfa= 180;
% beta= 200;
% alfa= 80;
%%%%%%%
A={A1, A2, A3, A4, A5, A6, A7, A8};
Kall={K1,K2,K3,K4,K5,K6,K7,K8};
constraints=[];
globalConstraints=[];
% gamma=0.0074;
chi = 10^(-1);
for i=1:8
  M1=[A{:,i}'*P+P*A{:,i}- Kall{:,i}*C-C'*Kall{:,i}'+2*alfa*P];
 %   M1=[A{:,i}'*P+P*A{:,i}- Kall{:,i}*C-C'*Kall{:,i}'+2*alfa*P];
%   M2=[-2*alfa*P+gamma*eye(3), P ; P , -eye(3)]
   M2=[  M1        P;
        P   -ep*eye(3)];
  M3=[beta*P, P*A{:,i}- Kall{:,i}*C ;  A{:,i}'*P-C'*Kall{:,i}', beta*P]
%   M4=[A{:,i}'*P+P*A{:,i}- Kall{:,i}*C-C'*Kall{:,i}'+2*alfa*P]

constraints= [constraints,  M1<= -10^(-12), M2<= -10^(-20), -M3<= -10^(-20)];%
end

globalConstraints=[constraints,  P >= eye(3)*chi, ep >= 0];  
optimize(globalConstraints,ep,sdpsettings('solver','SEDUMI')); %alfa >= 10^(-12),];%-P<0,,  Q>0  beta >= 10^(-3), alfa >= 10^(-12),
%%%%%%%%%%%%%%%%%%%%%%constraints1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
optimize(constraints,ep,sdpsettings('solver','SEDUMI'))

% for i=1:8
%     k=Kall{:,i};
%     Lg=[ Lg, inv(double(P))*double(k)];
% end
% Lg
for i=1:8
    k=Kall{:,i};
    inv(double(P))*double(k)
    Lg=[ Lg, {inv(double(P))*double(k)}];
end
Lg
 %N{1}
 ep = double(ep);
phi = sqrt(ep/(chi*2*alfa))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data = sim('simulate',6); %data = sim('simu',4)
% Time = data.simout.Data(:,1);
% data_chi = data.simout.Data(:,10);
% data_chi_lpv_est = data.simout.Data(:,13);
% data_chi_sp_est = data.simout.Data(:,16);
% % data_chi_est = data.simout.Data(:,15);
% % data_lam_est = data.simout.Data(:,13);
% % data_chi_est = data.simout.Data(:,14);
% % data_lam_est = data.simout.Data(:,12);
% % pix.time = Time;
% % pix.signals.values= data.simout.Data(:,8:9);
% line_width_r=2;
% line_width_b=1.5;
% Save=1;
% police=17;%24;
% police_axis=13;
% 
% figure;grid on;
% plot(Time,data_chi,'b','linewidth',1);
% hold on, grid on
% plot(Time,data_chi_lpv_est,'--r','linewidth',1);
% legend({'$\chi_{real}$','$\chi_{estimated}$'},'FontSize', police,'Interpreter','latex')
% xlabel('\textrm{time \,\,[s]}','FontSize', police,'Interpreter','LaTex');
% set(gca,'fontsize',police_axis)
% % create a new pair of axes inside current figure
% axes('position',[.65 .35 0.25 0.15])
% box on % put box around new pair of axes
% indexOfInterest = (Time < 6) & (Time > 3); % range of t near perturbation
% plot(Time(indexOfInterest),data_chi(indexOfInterest),'b','linewidth',1);
% %-data_chi(indexOfInterest)); % plot on new axes
% hold on
% plot(Time(indexOfInterest),data_chi_lpv_est(indexOfInterest),'--r','linewidth',1);
%  % plot on new axes
% axis tight
% grid on
% 
% 
% figure;grid on;
% plot(Time,data_chi,'b','linewidth',1);
% hold on, grid on
% plot(Time,data_chi_sp_est,'--r','linewidth',1);
% legend({'$ f_{real}$','$ f_{estimated}$'},'FontSize', police,'Interpreter','latex')
% xlabel('\textrm{time \,\,[s]}','FontSize', police,'Interpreter','LaTex');
% set(gca,'fontsize',police_axis)
% % create a new pair of axes inside current figure
% axes('position',[.65 .35 0.25 0.15])
% box on % put box around new pair of axes
% indexOfInterest = (Time < 6) & (Time > 3); % range of t near perturbation
% plot(Time(indexOfInterest),data_chi(indexOfInterest),'b','linewidth',1);
% %-data_chi(indexOfInterest)); % plot on new axes
% hold on
% plot(Time(indexOfInterest),data_chi_sp_est(indexOfInterest),'--r','linewidth',1);
%  % plot on new axes
% axis tight
% grid on
