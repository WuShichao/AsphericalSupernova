mtot=0.0048187313;
etot=0.0130949665;
rtot=0.5;
msun=1.989e33;
rsun=6.955e10;
m=15*msun;
e=1e51;
r=49*rsun;
kappa=0.2;
c=3e10;
rconv=r/rtot;
econv=e/etot;
mconv=m/mtot;

pconv=econv/rconv^3;
rhoconv=mconv/rconv^3;
vconv=sqrt(econv/mconv);

%r=linspace(0,2,2048)*rconv;
r=0.5*rconv;
theta=linspace(0,pi/2,2048);

x=r*sin(theta);
y=r*cos(theta);

radius=linspace(0,2,2048)*rconv;

%[TH,R] = meshgrid(theta,radius);
%[X,Y] = pol2cart(TH,R);

xx=zeros(2048,2048);
yy=zeros(2048,2048);
%theta=linspace(0,pi/2,2048);
for i=1:2048
    for j=1:2048
       xx(i,j)=radius(i)*sin(theta(j));
       yy(i,j)=radius(i)*cos(theta(j)); 
    end
end

for t=20:50
    radius=zeros(1,2048);
    name=['/home/nilou/Data/processeddata/BSG/dparamBSG_v2_' int2str(t) '.csv'] ;
    d= csvread(name);
    name=['/home/nilou/Data/rawdata/density/dens2048_' int2str(t) '.csv'] ;
    dens= csvread(name).*rhoconv;
%     for i=1:2048
%         radius(i)=find(abs(d(:,i)-1)==min(abs(d(:,i)-1)),1)*(2/2048)*rconv;
%     end
%     d(isnan(d)| isinf(d))=1e-3;
%     X=radius.*sin(theta);
%     Y=radius.*cos(theta);
    d=log10(d);
    %d(ii,jj)=1;
    close;
    a=get(gcf,'Position');
    x0=10;
    y0=10;
    width=550;
    height=400;
    
    myFigure = figure('PaperPositionMode','auto','Position',a,'Color','w');
    %figure;
    set(myFigure,'units','points','position',[x0,y0,width,height])
    h=surf(xx,yy, log10(dens));hold on
    grid off
    set(h,'LineStyle','none');
    colormap(flipud(gray))
    colorbar
    caxis auto
    view(2);
%    h=surf(xx,yy, d);hold on
%    set(h,'LineStyle','none');
    h1=contour(xx,yy,d,[0 0],'LineColor','b');hold on
    %colorbar
    %p2=plot(X,Y,'m','Linewidth',1), hold on,
    p3=plot(x,y,'r','Linewidth',1);
    axis equal 
    axis([0,2*rconv,0,2*rconv])
    title(['BSG Model t=' int2str(t)]);
    xlabel('cm'); 
    ylabel('cm');
    legend('Density','Diffiusion Front','Progenitor','Location','southoutside','Orientation','horizontal');
    set(gca,'LineWidth',2,'FontSize',12);
    %set(gca,'XDir','reverse')
    name=['/home/nilou/Data/plot/BSGdiff/diffBSGmapContour_v3_' int2str(t)];
    print('-dpng',name) 
    export_fig(name, '-png')
end