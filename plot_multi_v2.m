mtot=4.82611e-3*2;
etot=1.3402e-2*2;
rtot=0.5;

ptot=etot/rtot^3;
rhotot=mtot/rtot^3;
vtot=sqrt(etot/mtot);
ttot=rtot/vtot;

cell=2048;
theta=linspace(0,pi/2,cell);
radius=linspace(0,2,cell);

xx=zeros(cell,cell);
yy=zeros(cell,cell);

for i=1:cell
    for j=1:cell
       xx(i,j)=radius(i)*sin(theta(j));
       yy(i,j)=radius(i)*cos(theta(j)); 
    end
end

% theta=linspace(0,pi/2,256);
% radius=linspace(0,2,256);
% 
% xx_l=zeros(256,256);
% yy_l=zeros(256,256);
% 
% for i=1:256
%     for j=1:256
%        xx_l(i,j)=radius(i)*sin(theta(j));
%        yy_l(i,j)=radius(i)*cos(theta(j)); 
%     end
% end
close all

time=load('/home/nilou/Data/processeddata/timesteps_1024.mat');

    x0=0;
    y0=0;
    width=650;
    height=550;
    myFigure = figure ;    
    set(myFigure,'units','points','position',[299.2500   66.0000  609.7500  519.0000],'Color','w') 

for t=[0]
%     name=['/home/nilou/Data/rawdata/pres1024_' int2str(t) '.csv'] ;
%     pres= csvread(name)/ptot;
%     name=['/home/nilou/Data/rawdata/dens1024_' int2str(t) '.csv'] ;
%     dens= csvread(name)/rhotot;
     if (t<=200 && t~=176)
        name=['/home/nilou/Data/rawdata/pressure/pres1024_' int2str(t) '.csv'] ;
       pres= csvread(name)/ptot;
        name=['/home/nilou/Data/rawdata/density/dens1024_' int2str(t) '.csv'] ;
        dens=csvread(name)/rhotot;      
    else
        name=['/home/nilou/Data/rawdata/pressure/pres1024_' int2str(t) '.mat'] ;
        load(name,'pres_data');
        pres=pres_data/ptot;
        name=['/home/nilou/Data/rawdata/density/dens1024_' int2str(t) '.mat'] ;
        load(name,'dens_data');
        dens=dens_data/rhotot;
    end

   
    a=get(gcf,'Position');
    close all

     myFigure = figure ;    
     set(myFigure,'units','points','position',a,'Color','white')  
    
    %**********
    

    
%     s(4)=subplot(2,2,3);
%     h(4)=surf(-xx/rtot,-yy/rtot, (vel));
%     axis equal
%     grid off
%     set(h(4),'LineStyle','none');
    %colormap jet
%     c4=colorbar('Location','westoutside'); 
%     str = 'v/v_*';
%     ylabel(c4,str,'FontSize',12) 
%     view(2);
%     set(gca,'LineWidth',2,'FontSize',12);
%     s(4).XAxis.TickValues=[-4 -3 -2 -1 0];
%     s(4).YAxis.TickValues=[-4 -3 -2 -1 0];
%     
    s(3)=subplot(1,2,1);
    h(3)=surf(-xx/rtot,yy/rtot, log10(pres));
    grid off
    set(h(3),'LineStyle','none');
    axis equal
    %colormap jet
    c3=colorbar('Location','westoutside'); 
    str = 'Log P/P_*';
    ylabel(c3,str,'FontSize',12) 
    view(2);
    set(gca,'LineWidth',2,'FontSize',12);
    %s(3).XAxis.Color='none';
    s(3).YAxis.TickValues=[0 1 2 3 4];
    s(3).XAxis.TickValues=[-4 -3 -2 -1 0];
%     s(1)=subplot(1,2,1);
%     %pos=s(1).Position;
%     h(1)=surf(xx/rtot,-yy/rtot, log10(pres));hold on
%     grid off
%     set(h(1),'LineStyle','none');
%     axis equal
%     c1=colorbar('Location','eastoutside');
%     str = 'Log P/P*';
%     ylabel(c1,str,'FontSize',12) 
%     colormap jet
%     view(2);
%     set(gca,'LineWidth',2,'FontSize',12);
%     s(1).YAxis.Color='none';
%     s(1).XAxis.TickValues=[0 1 2 3 4];
    s(2)=subplot(1,2,2);
    h(2)=surf(xx/rtot,yy/rtot, log10(dens));
    grid off
    set(h(2),'LineStyle','none');
    axis equal
    colormap jet
    c2=colorbar('Location','eastoutside'); 
    str = 'Log \rho/ \rho_*';
    ylabel(c2,str,'FontSize',12) 
    view(2);
    set(gca,'LineWidth',2,'FontSize',12);
    s(2).YAxis.Color='none';
    %s(2).XAxis.Color='none';
    s(2).XAxis.TickValues=[0 1 2 3 4];
    %s(3).YAxis.TickValues=[0 1 2 3 4];
 %   s(1).Position=[0.15+0.322 0.1 0.38 0.38];
    s(2).Position=[0.15+0.322 0.1+0.38 0.38 0.38];
%    s(4).Position=[0.15 0.1 0.38 0.38];
     s(3).Position=[0.15 0.1+0.38 0.38 0.38];
    
    
%    c3.Position=[c4.Position(1)   c4.Position(2)+s(4).Position(3) c4.Position(3) c4.Position(4)];
%    c2.Position=[c1.Position(1)   c1.Position(2)+s(4).Position(3) c1.Position(3) c1.Position(4)];
    set(gcf,'NextPlot','add');
    axes;
    %h = title(['t/t_*=' num2str(time.time1(t+1)/ttot,3)]);
    num2str(time.time1(t+1)/ttot,3)
    set(gca,'Visible','off');
%    set(h,'Visible','on'); 
%    set(h,'FontSize',10);


    %xlabel('R/R_*')
    
%     set(gca,'LineWidth',2,'FontSize',12);
     (time.time1(t+1)/ttot)
     set(gcf, 'Color', 'w');
     name=['/home/nilou/Data/plot/allquantity/2048_' num2str(t,'%02d') '.png']
     export_fig(name,'-m2.5')
     % set(gcf, 'PaperPosition', [0 0 6.5 5.5]); %Position plot at left hand corner with width 5 and height 5.
     % set(gcf, 'PaperSize', [6.5 5.5]); %Set the paper to have width 5 and height 5.
     %print(gcf, '-dpng', '-r1100', name)
     %print(gcf, '-dpdf','-r100',name) 
     %export_fig(name, '-pdf','-r100')
     

%    name=['/home/nilou/Data/plot/allquantity/pdf/all_v4_' num2str(t,'%02d') '.pdf'];

     
end

