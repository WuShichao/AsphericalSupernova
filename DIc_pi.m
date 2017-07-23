mtot=0.0048187313;
etot=0.0130949665;
rtot=0.5;
msun=1.989e33;
rsun=6.955e10;
m=5*msun;
e=1e51;
r=0.2*rsun;
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

D1=122;
delta=7.2;

data=load('/home/nilou/Data/lphi_data.mat');
data=data.cursor_info;
dat=zeros(89,3);
for i=1:length(data)
    dat(i,:)=data(i).Position;
end
[~,I]=sort(dat(:,3));
dat=dat(I,:);
phi=atan(dat(:,1)./dat(:,2));

load vphi.mat vphi
load lphi.mat lphi
rhophi=csvread('rhophi.csv');

rhophi=10.^rhophi;

d=vphi.*rhophi'.*lphi';
D= (D1/((pi)^delta)*kappa_T*rho*r*v/c)*d;

close all
figure
a=get(gcf,'Position');
x0=15;
y0=15;
width=350;
height=300;
myFigure = figure('PaperPositionMode','auto','Position',a,'Color','w');
set(myFigure,'units','points','position',[x0,y0,width,height])
plot(phi,log10(D),'r','Linewidth',1),hold on,
D=log10(D);
save DIc_pi.mat D
xlabel('\phi (rad)'); 
ylabel('log (D_{Ic}) for \alpha_f=\pi');
%title('Time of Maximum Compression Rate');
%legend('v_\phi','fitted','Location','northeast');
set(gca,'LineWidth',1.5,'FontSize',10);
name=['/home/nilou/Data/DIc_pi'];
print('-dpdf',name) 
export_fig(name, '-pdf')