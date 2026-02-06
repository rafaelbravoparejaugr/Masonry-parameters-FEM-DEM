function printY(parameters)

global Ydat
global SIMOPS
X=Ydat.Xnode';
Y=Ydat.Ynode';
elements=Ydat.elements;
EP=Ydat.EP;

E0 = 32e9;
nu0 = 0.15;
rho0 = 2500;
mu0 = E0/(2*(1+nu0));
lambda0 = E0*nu0/((1-2*nu0).*(1+nu0));
D1PEPE0 = lambda0*50 ; %contact penalty term
D1PEPT0 = D1PEPE0/10 ; %contact tangential penalty term
D1PEFR0 = 0.7 ; %coulomb friction
D1PJFS0 = 7.8e8 ; % shear strength
D1PJFT0 = 2.1e8 ; % tensile strength
D1PJCO0 = 2e8 ; % cohesion strength
D1PJPE0 = 1.41e+13 ; % array containing fracture penalty 
D1PJGF0 = 6 ; %fracture energy Gf
if parameters.E == 0
    parameters.E=E0;
end
if parameters.nu == 0
    parameters.nu=nu0;
end
if parameters.rho == 0
    parameters.rho=rho0;
end
if parameters.D1PEPE == 0
    parameters.D1PEPE=D1PEPE0;
end
if parameters.D1PEPT == 0
    parameters.D1PEPT=D1PEPT0;
end
if parameters.D1PEFR == 0
    parameters.D1PEFR=D1PEFR0;
end
if parameters.D1PJFS == 0
    parameters.D1PJFS=D1PJFS0;
end
if parameters.D1PJFT == 0
    parameters.D1PJFT=D1PJFT0;
end
if parameters.D1PJCO == 0
    parameters.D1PJCO=D1PJCO0;
end
if parameters.D1PJPE == 0
    parameters.D1PJPE=D1PJPE0;
end
if parameters.D1PJGF == 0
    parameters.D1PJGF=D1PJGF0;
end

Epiedra=parameters.E;
nupiedra=parameters.nu;
rhopiedra=parameters.rho;
Eyoung=Epiedra*ones(1,max(EP)+1);
nu=nupiedra*ones(1,max(EP)+1);
rho=rhopiedra*ones(1,max(EP)+1);
mu=Eyoung./(2.*(1+nu));
lambda=Eyoung.*nu./((1-2.*nu).*(1+nu));



if SIMOPS.elimnodos==1
%pulido
%eliminación de nodos repetidos 
for i=length(X):-1:1
    for j=1:i
        if (abs(X(i)-X(j))<0.0001) && (abs(Y(i)-Y(j))<0.0001) && i~=j
            [fil,col]=find(i==elements);
            for k=1:length(fil)
                elements(fil(k),col(k))=j;
            end
            X(i)=12; %por poner un número significativo que sea fácil de encontrar
            Y(i)=12;
            break;
        end
    end
end

%eliminamos las X,Z que sobran
rep=find(X==12);
for i=length(rep):-1:1
    [rep_fil,rep_col]=find(elements>rep(i));
    for j=1:length(rep_fil)
        elements(rep_fil(j),rep_col(j))=elements(rep_fil(j),rep_col(j))-1;
    end
    X(rep(i))=[];
    Y(rep(i))=[];
end



[m,n]=size(elements);
ii = 1;
while ii<=m
    eend = 3;
    for jj = 1:n
        l = sqrt((X(elements(ii,jj))-X(elements(ii,eend)))^2+(Y(elements(ii,jj))-Y(elements(ii,eend)))^2);
        eend = jj;
        if l<0.1
            elements(ii,:) = [];
            EP(ii) = [];
            ii = ii -1;
            break
        end
    end
ii = ii +1;
[m,n]=size(elements);
end
end


% 
% figure
% triplot(elements(:,:),X,Y,'blue');
% axis equal
% hold on
% 
% colors=distinguishable_colors(11);
% for i=1:length(elements)
%     Xc=(X(elements(i,1))+X(elements(i,2))+X(elements(i,3)))/3;
%     Zc=(Y(elements(i,1))+Y(elements(i,2))+Y(elements(i,3)))/3;
%     hold on
%     a=EP(i);
%     plot(Xc,Zc,'.','MarkerSize',12,'color',colors(a+1,:))
% end

% hold on
% plot(X,Y,'.r','MarkerSize',12)
% for i=1:length(X)
% text(X(i),Y(i),num2str(i,'%d'),'fontsize',7)
% end

elements=elements-1;

global SIMOPS
fileID = fopen(SIMOPS.NAME,'w');
%% YDC
fprintf(fileID,'/YD/YDC/MCSTEP 	%g	/* maximum number of time steps */ \n',SIMOPS.NSTEP);
fprintf(fileID,'/YD/YDC/NCSTEP 	0	 	/* actual number of time steps */ \n');
fprintf(fileID,'/YD/YDC/DCSTEC 	%g 	/* size of time step */ \n',SIMOPS.STEPSIZE);
fprintf(fileID,'/YD/YDC/DCTIME	0.0		/* current time. i.e. time at start of this run */\n');
fprintf(fileID,'/YD/YDC/ICOUTF 	500		/* output frequency */ \n');
fprintf(fileID,'/YD/YDC/DCGRAY  -9.81		/* y gravity acceleration */		\n');
fprintf(fileID,'/YD/YDC/DCSIZC  80		/* Maximum size of coordinate in any direction */\n');
fprintf(fileID,'/YD/YDC/DCSIZF  0.5e+08		/* Maximum size of force in any direction */\n');
fprintf(fileID,'/YD/YDC/DCSIZS 	1000e+06\n');
fprintf(fileID,'/YD/YDC/DCSIZV 	20.0		/* Maximum size of velocity in any direction */\n');
fprintf(fileID,'/YD/YDC/ICOUTI 	0		/* Serial number of first output associated with this run */\n');
fprintf(fileID,'/YD/YDC/ICOUTP 	4 		/* Number of characters for each number in output file */ \n');
% fprintf(fileID,'/YD/YDC/IWFAST  1	    	/* Fast mode. off: 0, on: >0 (default: on). Say >0 will indicate that all elements will take part in the contact detection, which is not necessary in many cases. */\n');
%% YDN
fprintf(fileID,'/*  Nodes  */ \n');
fprintf(fileID,'/YD/YDN/MNODIM        2 \n/YD/YDN/NNODIM        2 /* Degrees of freedom */\n');
fprintf(fileID,'/YD/YDN/MNOPO    200000  /* Maximum number of nodes  */\n');
fprintf(fileID,'/YD/YDN/NNOPO %g /*  Actual number of nodes  */ \n',length(X));
fprintf(fileID,'/YD/YDN/D2NCC        21 2 %g\n',length(X)); %current coordinates
for t=1:length(X) %print coordinates
    coord = [X(t,1); Y(t,1)];
    fprintf(fileID,'%g %g\n',coord);
end
fprintf(fileID,'/YD/YDN/D2NCI        21 2 %g\n',length(X)); %initial coordinates
for t=1:length(X)
    coord = [X(t,1); Y(t,1)];
    fprintf(fileID,'%g %g\n',coord);
end
fprintf(fileID,'/YD/YDN/D2NVC        21 2 %g\n',length(X)); %current velocity of each node
for t=1:length(X)
    fprintf(fileID,'0 0\n');
end
fprintf(fileID,'/YD/YDN/I1NOBF  %g\n',length(X)); %Set to 1 if a node is in a boundary
for t=1:length(X)
    fprintf(fileID,'1   ');
end
fprintf(fileID,'\n/YD/YDN/I1NOPR  %g\n',length(X));
%%%%

PRN = ones(1,length(X)) * 0;
nsuelo=find(abs(Y-min(Y))<0.001)';
nsup=find(abs(Y-max(Y))<0.001); %& abs(X-max(X))>0.001 & abs(X-min(X))>0.001)';
[~,i1] = sort(X(nsup));
nsup = nsup(i1); %ordenamos por X ascendente
nsemi=[find(abs(X(nsup)-max(X))<0.001),find(abs(X(nsup)-min(X))<0.001)]; %nodos extremos, luego la carga es la mitad
nlat=[find(abs(X-max(X))<0.001);find(abs(X-min(X))<0.001)];
if SIMOPS.elimnodos==1
    loadP = SIMOPS.load; %entre uno pq en cada posición concurre 1 nodo
else
    loadP = SIMOPS.load/2; %entre dos pq en cada posición concurren 2 nodos
end
vectorLoad=loadP*ones(1,length(nsup));
if SIMOPS.elimnodos==1 
vectorLoad(nsemi)=loadP/2; %mitad de carga en los extremos
end
PRN(nsuelo)=1;
PRN(nlat)=2;
prop=3;

sets=[];

% for i=1:length(nsup)
%    PRN(nsup(i))=prop;
%    prop=prop+1;
% end
PRN(nsup)=prop;
prop=prop+1;

for t=1:length(X)
    fprintf(fileID,'%g   ',PRN(1,t));
end

fprintf(fileID,'\n/YD/YDN/D1NMCT 0\n');
%% YDPN
ts=1000;  %deltas totales
fprintf(fileID,'/* Nodal properties */\n');
fprintf(fileID,'/*  Node Properties  */ \n');
fprintf(fileID,'/* [ DEFLT ; spc ; boundary ] */ \n');
fprintf(fileID,'/YD/YDPN/MPNSET        %g /* Maximum number of Nodal Property sets */ \n', prop);
fprintf(fileID,'/YD/YDPN/NPNSET        %g /* Actual number of Nodal Property sets */\n',prop);
% fprintf(fileID,'/YD/YDPN/MPNFACT %g /* The number of points of time  */\n',ts);
% fprintf(fileID,'/YD/YDPN/NPNFACT %g/* D3PNFAC[2][MPNSET][MPNFACT]  */\n',ts);
% fprintf(fileID,'/* Array containing for each property series of MFACT times and amplitude factors. Values of D1PNAX,\n');
% fprintf(fileID,'D1PNAY, D1PNAZ, D1PNAP and D1PNAT are multiplied by amplitude factors at specified times for each property \n');
% fprintf(fileID,'*/\n');
% 
% %vector con todas las secuencias de carga
% velocity=SIMOPS.velocity/3.6;
% to=0.3;
% deltat=SIMOPS.tSimul/(ts);
% ts=ts+1;
% vec_loads=zeros(ts,prop);
% time=zeros(ts,1);
% for i=1:ts
%     time(i)=deltat*(i-1);
% end
% 
% for i=1:3
%     vec_loads(:,i)=1; 
% end
% 
% xopuente=min(X(nsup));
% xlast_node=X(nsup(1));
% perc1=0;
% perc2=0;
% global geometria
% ancho_puente=abs(min(X(nsup))-max(X(nsup)));
% for j=1:8
% for i=1:ts
%     xload=(time(i)-to)*velocity-13*(j-1);
%     if xload>=0 && xload < ancho_puente
%         xload=xload+xopuente;
%         [~,closestIndex] = min(abs(xload-X(nsup)));
%         if closestIndex==45
%             a=1; %%% revisar a partir de aquí estás en que da error cuando pones el 45t
%         end
%         if X(nsup(closestIndex))>xload
%             nodosLoad=[closestIndex,closestIndex-1];
%         else
%             nodosLoad=[closestIndex+1,closestIndex];
%         end
%         dist=abs(X(nsup(nodosLoad(1)))-X(nsup(nodosLoad(2))));
%         perc1=(dist-abs(X(nsup(nodosLoad(1)))-xload))/dist;
%         perc2=(dist-abs(X(nsup(nodosLoad(2)))-xload))/dist;
%         vec_loads(i,nodosLoad(1)+3)=perc1;
%         vec_loads(i,nodosLoad(2)+3)=perc2;
%     end
% end
% end
% 
% % tin=tsad+1;
% % for i=3:prop
% %     vec_loads(tin:tin+6,i)=[0.25,0.5,0.75,1,0.75,0.5,0.25];
% %     tin=tin+1;
% % end
% 
% fprintf(fileID,'/YD/YDPN/D3PNFAC 231       2       %g %g\n' , prop,ts);
% 
% for j=1:prop
% for t=1:ts
%     fprintf(fileID,'%g	%g\n',time(t),vec_loads(t,j));
% end
% fprintf(fileID,'\n');
% fprintf(fileID,'\n');
% end

fprintf(fileID,'/YD/YDPN/I1PNFX  %g\n', prop);
CCx=[1, 1, 3, ones(1,prop-3)];
for i=1:length(CCx)
fprintf(fileID,'%g ',CCx(i));
end
fprintf(fileID,'\n');

fprintf(fileID,'/YD/YDPN/I1PNFY  %g\n', prop);
CCy=[1, 3,ones(1,prop-2)];
for i=1:length(CCy)
fprintf(fileID,'%g ',CCy(i));
end
fprintf(fileID,'\n');

fprintf(fileID,'/YD/YDPN/D1PNAX  %g\n', prop);
CCx_val=[0*ones(1,prop)];
for i=1:length(CCx_val)
fprintf(fileID,'%g ',CCx_val(i));
end
fprintf(fileID,'\n');

fprintf(fileID,'/YD/YDPN/D1PNAY  %g\n', prop);
CCy_val=[0,0, 0, vectorLoad(1)];
for i=1:length(CCy_val)
fprintf(fileID,'%g ',CCy_val(i));
end
fprintf(fileID,'\n');

fprintf(fileID,'/YD/YDPN/D1PNAP  %g\n', prop);
x_val=[ones(1,prop)*0];
for i=1:length(x_val)
fprintf(fileID,'%g ',x_val(i));
end
fprintf(fileID,'\n');

fprintf(fileID,'/YD/YDPN/D1PNAT  %g\n', prop);
y_val=[ones(1,prop)*0];
for i=1:length(y_val)
fprintf(fileID,'%g ',y_val(i));
end
fprintf(fileID,'\n');

%% YDE
fprintf(fileID,'/* Elements */\n');
fprintf(fileID,'/YD/YDE/MELEM 100000\n');%Maximo número de elementos
fprintf(fileID,'/YD/YDE/NELEM %g\n',length(elements)); %elementos al inicio
fprintf(fileID,'/YD/YDE/MELST         2 \n'); %maximum number of state variables
fprintf(fileID,'/YD/YDE/NELST         2 \n'); %Actual """""
fprintf(fileID,'/YD/YDE/MELNO         4 \n');
fprintf(fileID,'/YD/YDE/NELNO         3 \n'); %nodes per finite element
fprintf(fileID,'/YD/YDE/I1ELBE %g\n',length(elements)); %set to 1 if an element is in the boundary
for t=1:length(elements) %Revisar
    fprintf(fileID,'%g  ',0);
end
fprintf(fileID,'\n');
fprintf(fileID,'\n');

fprintf(fileID,'/YD/YDE/I1ELPR %g\n',length(elements)); %properties associated with each element
for t=1:length(elements)
    fprintf(fileID,'%g  ',EP(1,t));
end
fprintf(fileID,'\n');
fprintf(fileID,'\n');
fprintf(fileID,'/YD/YDE/I2ELTO        21       3 %g\n',length(elements)); %nodes of each element
for t=1:length(elements)
    fprintf(fileID,'%g %g %g\n',elements(t,:));
end
fprintf(fileID,'/YD/YDE/D2ELST        21 2 0\n');

%% YDI
fprintf(fileID,'/* interaction */\n');
fprintf(fileID,'/YD/YDI/MICOUP  100000	  	/* Maximum number of contacting couples of finite elements */\n');
fprintf(fileID,'/YD/YDI/NICOUP 	0		/* Actual number of contacting couples of finite elements (always set to zero) */ \n');
fprintf(fileID,'/YD/YDI/DIEZON  0.05 		/* Size of the buffer around each finite element for contact detection purposes */\n');
fprintf(fileID,'/YD/YDI/IIECFF  -2		/* Internal variable used for contact (always set to -2) */\n');
fprintf(fileID,'/YD/YDI/DIEDI   200.0\n');
fprintf(fileID,'/YD/YDI/D1IESL  0\n/YD/YDI/I1IECN  0 \n/YD/YDI/I1IECT  0 \n/YD/YDI/MISTATE 6\n');

%% YDO

fprintf(fileID,'/* output database */ \n/YD/YDO/MOHYS 1 \n/YD/YDO/NOHYS 1\n/YD/YDO/DOHYP 0.0005\n');
fprintf(fileID,'/YD/YDO/D1OHYC 1\n1.0\n/YD/YDO/D1OHYF 1\n1.0 \n/YD/YDO/D1OHYS 1\n0\n');
fprintf(fileID,'/YD/YDO/D1OHYT 1 \n0 \n/YD/YDO/D1OHYX 1 \n0 \n/YD/YDO/D1OHYY 1 \n0 \n/YD/YDO/I1OHYT 1 \n15\n');

%% YDPE
fprintf(fileID,'/* properties - elements */\n');
Nmateriales = max(EP)+1;fprintf(fileID,'/YD/YDPE/MPROP 		%g  /* Maximum number of properties sets */ \n',Nmateriales);
fprintf(fileID,'/YD/YDPE/NPROP 		%g  /* Actual number of properties sets */\n',Nmateriales);
fprintf(fileID,'/YD/YDPE/D1PEKS   	%g\n',Nmateriales);
D1PEKS = 1200e+03;
for t=1:Nmateriales
    fprintf(fileID,'%g	',D1PEKS);
end
fprintf(fileID,'\n');
fprintf(fileID,'/* array containing Lamé elastic constant (lamda) */');
fprintf(fileID,'\n');
fprintf(fileID,'/YD/YDPE/D1PELA   	%g\n',Nmateriales);
% D1PELA = lambda1;
for t=1:Nmateriales
    fprintf(fileID,'%g	',lambda(t));
end
fprintf(fileID,'\n');
fprintf(fileID,'/* array containing Lamé elastic constant (mu) */');
fprintf(fileID,'\n');
% D1PEMU =  mu1;
fprintf(fileID,'/YD/YDPE/D1PEMU   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',mu(t));
end
fprintf(fileID,'\n');
fprintf(fileID,'/* array containing density (mu) */');
fprintf(fileID,'\n');
%D1PERO =   rho;
fprintf(fileID,'/YD/YDPE/D1PERO   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',rho(t));
end
fprintf(fileID,'\n');
fprintf(fileID,'/* array containing contact penalty term */');
fprintf(fileID,'\n');
D1PEPE =    parameters.D1PEPE ;
fprintf(fileID,'/YD/YDPE/D1PEPE   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',D1PEPE);
end
fprintf(fileID,'\n');
fprintf(fileID,'/* array containing contact tangential penalty term for contact */');
fprintf(fileID,'\n');
D1PEPT =    parameters.D1PEPT;
fprintf(fileID,'/YD/YDPE/D1PEPT   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',D1PEPT);
end
fprintf(fileID,'\n');
fprintf(fileID,'\n');
D1PSEM =     0.0; %maximum tensile stretch
fprintf(fileID,'/YD/YDPE/D1PSEM   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',D1PSEM);
end
fprintf(fileID,'\n');

fprintf(fileID,'\n');
I1PEFR =     0.0; %fracture flag (0 non fractured)
fprintf(fileID,'/YD/YDPE/I1PEFR   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',I1PEFR);
end
fprintf(fileID,'\n');
fprintf(fileID,'/* array containing fracture flag */');
fprintf(fileID,'\n');
I1PEMB =     0.0; %if >0 Boundary nodes are marked
fprintf(fileID,'/YD/YDPE/I1PEMB   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',I1PEMB);
end
fprintf(fileID,'\n');
fprintf(fileID,'/* If greater than zero boundary nodes are marked, otherwise not */');
fprintf(fileID,'\n');
I1PSDE =     0.0;
fprintf(fileID,'/YD/YDPE/I1PSDE   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',I1PSDE);
end
fprintf(fileID,'\n');
fprintf(fileID,'/* array containing ID of elastic damage state variable */');
fprintf(fileID,'\n');
I1PTYP =  1;
fprintf(fileID,'/YD/YDPE/I1PTYP   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',I1PTYP);
end
fprintf(fileID,'\n');
fprintf(fileID,'/* array containing the type of each property */');
fprintf(fileID,'\n');
D1PEFR = parameters.D1PEFR;
fprintf(fileID,'/YD/YDPE/D1PEFR   	%g\n',Nmateriales);
for t=1:Nmateriales
    fprintf(fileID,'%g	',D1PEFR);
end
fprintf(fileID,'\n');
fprintf(fileID,'/* array containing coloumb friction */ ');
fprintf(fileID,'\n');

%% YDPJ
fprintf(fileID,'/* properties - joints */\n');
fprintf(fileID,'/YD/YDPJ/MPJSET 2		/* Maximum number of Joint sets */\n');
fprintf(fileID,'/YD/YDPJ/NPJSET 2		/* Actual number of Joint sets */\n');
fprintf(fileID,'/YD/YDPJ/D1PJFS 2		\n');
fprintf(fileID,'5.95e9  %s	/* array containing shear strength */\n',parameters.D1PJFS);
fprintf(fileID,'/YD/YDPJ/D1PJFT	2\n');
fprintf(fileID,'11.5e8   %g		/* array containing tensile strength */ \n',parameters.D1PJFT);
fprintf(fileID,'/YD/YDPJ/D1PJCO	2\n'); %Cohesion strength
fprintf(fileID,'2e9	%g\n',parameters.D1PJCO);
fprintf(fileID,'/YD/YDPJ/D1PJFR	2\n'); %friction coefficient
fprintf(fileID,'0.7	%g\n',parameters.D1PEFR);
fprintf(fileID,'/YD/YDPJ/D1PJPE 2\n');
fprintf(fileID,'1.41e+13   %g	/* array containing fracture penalty term for contact */\n',parameters.D1PJPE);
fprintf(fileID,'/YD/YDPJ/D1PJGF	2\n');
fprintf(fileID,'8.5   %g		/* array containing fracture energy Gf of material */\n',parameters.D1PJGF);
fprintf(fileID,'/YD/YDPJ/I1PSDE 2\n');
fprintf(fileID,'0          0			/* array containing ID of elastic damage state variable */\n');
fprintf(fileID,'/YD/YDPJ/I1PTYP 2\n'); %Type of each property 3 for 2D problems
fprintf(fileID,'3          3\n');


%% YDPM
fprintf(fileID,'/* properties - MESHING */\n');
fprintf(fileID,'/YD/YDPM/MPMCOM %g\n',Nmateriales);
fprintf(fileID,'/YD/YDPM/MPMCOL 3\n');
fprintf(fileID,'/YD/YDPM/I2PMSET 21 3 %g\n',Nmateriales);
for i = 0:Nmateriales-1
fprintf(fileID,'1	0	%g\n',i);
end
fprintf(fileID,'/YD/YDPM/MPMROW %g\n',nchoosek(2+Nmateriales-1,2));
fprintf(fileID,'/YD/YDPM/I2PMIJ 21 3 %g\n',nchoosek(2+Nmateriales-1,2));
for i = 0:Nmateriales-1
    for j = i:Nmateriales-1
        if i == j
            conexion = 0;
        else
            conexion = 1;
        end
        fprintf(fileID,'%g	%g	%g \n',i,j,conexion);
        
    end
end

fprintf(fileID,'$YDOIT\n');
fprintf(fileID,'$YSTOP\n');
fclose(fileID);



%% Lanzar el cálculo
% !Y.exe ./bloque.y


end


