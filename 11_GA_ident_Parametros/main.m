function main(parameters)
%datos
global Ydat
global geometria
% geometria.h = 9; %Alto. Fig. RRR buscar
% geometria.H=10.5; %altura total
% geometria.L = 20; %Largo
% geometria.R = 3.5; %Radio del arco
% geometria.t=0.5; %Ancho del arco
% geometria.hz= 1+0.0220; %Altura de la zapata
% geometria.Harco=5;
% 
% geometria.Nz = 2; %Piedras zapata
% geometria.N =15; %Piedras totales arco *********LOS PARES NO FUNCIONAN********
% geometria.fil = 20; %hileras
% geometria.blad=20/20; %ancho ladrillo
% geometria.hlad=5/10;
% %Refinamiento arco
% geometria.elemMin=0.9;
% 
% %cálculos
% [X_a_ext,Y_a_ext]=arco2D();
% pared2D(X_a_ext,Y_a_ext)

%Generar archivo Y
%save('geometry','Ydat')
loaddata=load('geometry'); 
Ydat=loaddata.Ydat;
global SIMOPS
SIMOPS.NAME = compose("%s.y",'actual');
SIMOPS.STEPSIZE = 5E-6; %Paso temporal
SIMOPS.tSimul=0.1;
SIMOPS.NSTEP =fix(SIMOPS.tSimul/SIMOPS.STEPSIZE); %steps totales
SIMOPS.load=-10000;
SIMOPS.elimnodos=0; %1 on 0 off
printY(parameters)
%axis equal
%figure
% Y=Ydat.Ynode;
% X=Ydat.Xnode;
% elements=Ydat.elements;
% triplot(elements(:,:),X,Y,'black');
% axis equal
%  ylim([0,8.5])
%  xlim([-geometria.B/2,geometria.B/2])
% hold on
% plot(X,Y,'.r','MarkerSize',12)
% for i=1:length(X)
%  text(X(i),Y(i),num2str(i,'%d'),'fontsize',7)
% end
clc;
end 