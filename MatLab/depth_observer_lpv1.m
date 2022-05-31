function out = depth_observer_lpv1(in)
global Lg

zeta_est = in(1:3);
xy        = in(4:5);
v        = in(6:8); 
omega    = in(9:11);
x_est = zeta_est(1); 
y_est = zeta_est(2); 
chi_est = zeta_est(3);
%x = y(1); 
%y = y(2); 

vx = v(1);  vy = v(2); vz = v(3); 
wx = omega(1); wy = omega(2); wz = omega(3);

C  = [1 0 0; 0 1 0];
n=3; tab=[];  tab2=[]; ; tabmin=[]; tabmax=[];
for i=0:(2^n-1)
    table(i+1,:) = dec2bin(i,n);
    tab = [tab;table(i+1,:)];
    tabBin=[];
    for j=1:n
        tabBin=[tabBin str2num(tab(i+1,j))];
    end
    tabmin=[tabmin; tabBin];
end

for i=(2^n-1):-1:0
    table(i+1,:) = dec2bin(i,n);
    tab = [tab;table(i+1,:)];
    tabBin=[];
    for j=1:n
        tabBin=[tabBin str2num(tab(i+1,j))];
    end
    tabmax=[tabmax; tabBin];
end
  

maxss = .5;
minss = -.5;
maxs = 1;
mins = -1;
max1 = maxs; 
min1 = mins; 
max2 = maxs;
min2 = mins;  
max3 = maxss;
min3 = minss;  

mm(:,1) = tabmax(:,1)*max1+tabmin(:,1)*min1;
mm(:,2) = tabmax(:,2)*max2+tabmin(:,2)*min2;
mm(:,3) = tabmax(:,3)*max3+tabmin(:,3)*min3;


p1 = -vx + x_est*vz;
p2 = -vy + y_est*vz;
p3 = vz*chi_est + y_est*wx - x_est*wy;

D1 = 2;
D2 = 2;
D3 = 1;


m12 = (max1-p1)/D1; m11 = 1 - m12;
m22 = (max2-p2)/D2; m21 = 1 - m22;
m32 = (max3-p3)/D3; m31 = 1 - m32;

m1=tabmax(:,1)*m11+tabmin(:,1)*m12;
m2=tabmax(:,2)*m21+tabmin(:,2)*m22;
m3=tabmax(:,3)*m31+tabmin(:,3)*m32;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mu = m1.*m2.*m3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m=[m1, m2, m3];
ss = sum(mu)

resultl = cellfun(@times,Lg,num2cell(mu'),'uni',false);
Ll1 = sum(cat(3,resultl{:}),3)

u = omega;

g_est = [x_est*y_est -(1+x_est^2) y_est; ...
         1+y_est^2 -x_est*y_est -x_est; ...
         0 0 0];

     Aa = [0  0  p1;
         0  0  p2;
         0  0  p3];
     

%tmp1 = (mu1*A1 + mu2*A2 + mu3*A3 + mu4*A4 + mu5*A5 + ...        mu6*A6 + mu7*A7 + mu8*A8)*zeta_est;
err  =  xy - C*zeta_est; 
 tmp1 = Aa*zeta_est;
 tmp2 = Ll1*err;
% tmp2 = (mu1*L1 + mu2*L2 + mu3*L3 + mu4*L4 + mu5*L5 + mu6*L6 + mu7*L7 + mu8*L8)*err;
    
d_zeta_est = tmp1 + tmp2 + g_est*u;

out = d_zeta_est;