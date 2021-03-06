mtot=0.0048187313;
etot=0.0130949665;
rtot=0.5;
msun=1.989e33;
rsun=6.955e10;
m=14*msun;
e=1e51;
r=400*rsun;
c=3e10;
h=6.62e-27;
k_B=1.38e-16;
sigma=5.6e-5;

rconv=r/rtot;
econv=e/etot;
mconv=m/mtot;
v=sqrt(e/m);
rho=m/(r^3);
Z=0.005;
a=7.566e-15;
X=0.7;
kappa_T=0.2*(1+X);

pconv=econv/rconv^3;
rhoconv=mconv/rconv^3;
vconv=sqrt(econv/mconv);
tconv_rsg=rconv/vconv;

all=[0 inf];
X=[4.83e16 4.83e19 ];
FUV=c./([1806 1340]*10^-8);
NUV=c./([3007 1693]*10^-8);
U=c./([4028 3048]*10^-8);
G=c./([5549 3783]*10^-8);
R= c./([6989 5415]*10^-8);
I= c./([8389 6689]*10^-8);
Z= c./([10833 7960]*10^-8);

bands=[Z; I ; R; G; U; NUV; FUV ; all];



lum=load('/home/nilou/Data/processeddata/RSG/luminosity_smoothed55_Phi0.mat','luminosity');
luminosity_phi0=lum.luminosity(23:50);
lum=load('/home/nilou/Data/processeddata/RSG/luminosity_smoothed55_temp.mat','luminosity');
luminosity_tot=lum.luminosity(23:50);
lum=load('/home/nilou/Data/processeddata/RSG/luminosity_smoothed55_Phi90.mat','luminosity');
luminosity_phi90=lum.luminosity(23:50);
t_color=load('/home/nilou/Data/processeddata/RSG/colortemp_tot_v3.mat','t_color_bsg');
t_color_rsg=t_color.t_color_bsg(23:50);


time=load('/home/nilou/Data/timesteps.mat');
time_rsg=(time.time1*tconv_rsg);

t_sph=time_rsg(23:50)-time_rsg(23)+927.3;
t_s=14*3600* (m/(15*msun))^0.43*(r/(500*rsun))^1.26*(e/1e51)^-0.56;
t_c=927.3;
L_s=zeros(length(time_rsg(23:50)),1);
%L_s(t_sph<t_c)=2e44*(m/(15*msun))^-0.37*(r/(500*rsun))^2.46*(e/1e51)^0.3*(t_c./3600).^(-4/3);
L_s(t_sph<t_s)=2e44*(m/(15*msun))^-0.37*(r/(500*rsun))^2.46*(e/1e51)^0.3*(t_sph(t_sph<t_s)./3600).^(-4/3);
L_s(t_sph>t_s)=6*10^42*(m/(15*msun))^-0.87*(r/(500*rsun))*(e/1e51)^0.96.*(t_sph(t_sph>t_s)./(24*3600)).^-0.17;

T_c=zeros(50-23+1,1);
t_s=14*3600* (m/(15*msun))^0.43*(r/(500*rsun))^1.26*(e/1e51)^-0.56;
T_c(t_sph<t_s)=10*(m/(15*msun))^-0.22*(r/(500*rsun))^0.12 *(e/1e51)^0.23* (t_sph(t_sph<t_s)/3600).^-0.36;
T_c(t_sph>t_s )=3*(m/(15*msun))^-0.13*(r/(500*rsun))^0.38 *(e/1e51)^0.11* (t_sph(t_sph>t_s)/(24*3600)).^-0.56;

T_c=T_c*11604.52;
bandL=zeros(length(bands),28,4);
factor=zeros(1,28);
factor1=zeros(1,28);


for i=1:length(bands)
    if (i==length(bands))
        bandL(i,:,1)=luminosity_tot;
        bandL(i,:,2)=luminosity_phi0;
        bandL(i,:,3)=luminosity_phi90;
        bandL(i,:,4)=L_s;
    else 
        for j=1:28
            T=t_color_rsg(j);
            fun = @(x) (2*h*x.^3/ c^2) .* 1./(exp(h*x/(k_B*T))-1);
            factor(j)= integral(fun,bands(i,1),bands(i,2));
            Tp=T_c(j);
            fun = @(x) (2*h*x.^3/ c^2) .* 1./(exp(h*x/(k_B*Tp))-1);
            factor1(j)= integral(fun,bands(i,1),bands(i,2));
        end
        bandL(i,:,1)=((pi*luminosity_tot)./(sigma*t_color_rsg.^4)).*factor;
        bandL(i,:,2)=((pi*luminosity_phi0)./(sigma*t_color_rsg.^4)).*factor;
        bandL(i,:,3)=((pi*luminosity_phi90)./(sigma*t_color_rsg.^4)).*factor;
        bandL(i,:,4)=((pi*L_s')./(sigma*T_c'.^4)).*factor1;
    end

end

bandM=71.197425-2.5*log10(bandL*1e-7);

set(0,'DefaultAxesColorOrder',distinguishable_colors(20));

close all
a=get(gcf,'Position');
x0=15;
y0=15;
width=350;
height=970;
myFigure = figure('PaperPositionMode','auto','Color','w');
set(myFigure,'units','points','position',[x0,y0,width,height])

subplot(4,1,1)
plot(log10(time_rsg(23:50)'),bandM(:,:,1),'LineWidth',1.5)
%axis([4e4 12e4 36 46])
str={'z^\prime', 'i^\prime','r^\prime', 'g^\prime', 'u^\prime', ...
   'NUV', 'FUV' , 'Bol'};

text(4.8,-5,'Total Luminosity','HorizontalAlignment','left','FontSize',12);
h1=columnlegend(3,str,'location', 'best','FontSize',1);
legend('boxoff')
set(h1,'FontSize',1);
set(gca,'Ydir','reverse')
set(gca,'LineWidth',1.5,'FontSize',12);
subplot(4,1,2)
plot(log10(time_rsg(23:50)'),bandM(:,:,2),'LineWidth',1.5)
set(gca,'LineWidth',1.5,'FontSize',12);
ylabel('Absolute Magnitude [mag]');
text(4.8, -23,'Luminosity \Phi=0','HorizontalAlignment','left','FontSize',12);
set(gca,'Ydir','reverse')
subplot(4,1,3)
plot(log10(time_rsg(23:50)'),bandM(:,:,3),'LineWidth',1.5)
text(4.8, -21,'Luminosity \Phi=\pi/2','HorizontalAlignment','left','FontSize',12);
set(gca,'Ydir','reverse')
subplot(4,1,4)
plot(log10(time_rsg(23:50)'),bandM(:,:,4),'LineWidth',1.5)
text(4.8, -21,'Spherical Luminosity','HorizontalAlignment','left','FontSize',12);
set(gca,'Ydir','reverse')

samexaxis('abc','xmt','on','ytac','join','yld',1)
xlabel('Log(t [sec])'); 
set(gca,'LineWidth',1.5,'FontSize',11);
name=['/home/nilou/Data/plot/BandM_RSG.pdf'];    
print('-dpdf',name) 
export_fig(name, '-pdf')
