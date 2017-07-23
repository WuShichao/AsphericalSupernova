load('luminosityCode.mat', 'luminosity')

mtot=0.0048187313;
etot=0.0130949665;
rtot=0.5;
msun=1.989e33;
rsun=6.955e10;
m=5*msun;
e=1e51;
r=0.2*rsun;
%kappa=0.2;
%kappa=0.2;
c=3e10;
rconv=r/rtot;
econv=e/etot;
mconv=m/mtot;
v=sqrt(e/m);
rho=m/(r^3);
Z=0.005;
a=7.566e-15;
X=0;
kappa_T=0.2*(1+X);

pconv=econv/rconv^3;
rhoconv=mconv/rconv^3;
vconv=sqrt(econv/mconv);
mean(luminosity)
luminosity=luminosity*pconv*rconv/(kappa*rhoconv);

save('luminosityIc.mat', 'luminosity')

(pconv*rconv)/(kappa*rhoconv*c);
