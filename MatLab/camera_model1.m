function out = camera_model1(in)

v       = in(1:6)
s       = in(7:8);
chi     = in(9);
x       = s(1);
y       = s(2);
vx      = v(1);
vy      = v(2);
vz      = v(3);
wx      = v(4);
wy      = v(5);
wz      = v(6);

omega = [wx ; wy ;wz];

Omega = [x*vz-vx y*vz-vy];
fmp =  [x*y -(1+x^2) y; 1+y^2 -x*y -x];
Z = 1/chi;


fm =fmp*omega;
fu = vz*chi^2 + (y*wx-x*wy)*chi;

ds = fm + Omega'*chi
d_chi = fu;
out = [ds;d_chi];
