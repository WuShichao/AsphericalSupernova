mtot=0.0048187313;
etot=0.0130949665;
rtot=0.5;
msun=1.989e33;
rsun=6.955e10;
m=14*msun;
e=1e51;
r=500*rsun;
kappa=0.2;
c=3e10;
rconv=r/rtot;
econv=e/etot;
mconv=m/mtot;

pconv=econv/(rconv^3);
rhoconv=mconv/(rconv^3);
vconv=sqrt(econv/mconv);

r=linspace(0,2,2048).*rconv;
theta=linspace(0,pi/2,2048);
for t=1:76
    t
    name=['pres2048_' int2str(t-1) '.csv'] ;
    pres= csvread(name).*pconv;
    name=['dens2048_' int2str(t-1) '.csv'] ;
    dens= csvread(name).*rhoconv;
    name=['velr2048_' int2str(t-1) '.csv'] ;
    velr= csvread(name).*vconv;
    name=['velth2048_' int2str(t-1) '.csv'] ;
    velt= csvread(name).*vconv;    
    d=zeros(2048,2048);
    for i=1:2048
        for j=1:2048
            if (i==1)
                pr=r(i); 
                pindex_r=i;
            else
                pr=r(i-1);
                pindex_r=i-1;
            end
            if (j==1)
                pt=theta(j);
                pindex_t=j;
            else
                pt=theta(j-1);
                pindex_t=j-1;
            end
            if (i==2048)
                nr=r(i);
                nindex_r=i;
            else
                nr=r(i+1);
                nindex_r=i+1;
            end
            if (j==2048)
                nt=theta(j);
                nindex_t=j;
            else
                nt=theta(j+1);
                nindex_t=j+1;
            end
            dr=nr-pr;
            cr=pr+ dr/2;
            dt=nt-pt;
            ct=pt+ dt/2;
            delvel= ((nr^2 * velr(nindex_r,j) - pr^2 * velr(pindex_r,j))/ (cr^2 * dr) )+ (( sin(nt)*velt(i,nindex_t) - sin(pt) * velt(i,pindex_t))/(cr * sin(ct)* dt));
            gradp2=((pres(nindex_r,j)-pres(pindex_r,j))/dr)^2+ ((pres(i,nindex_t)-pres(i,pindex_t))/(cr*dt))^2;
            d(i,j)=(3*kappa*dens(i,j)*abs(delvel)*(pres(i,j)^2))/(c*gradp2);
        end
    end
    name=[ 'dparamRSG_' int2str(t-1) '.csv'];
    csvwrite(name,d);
end