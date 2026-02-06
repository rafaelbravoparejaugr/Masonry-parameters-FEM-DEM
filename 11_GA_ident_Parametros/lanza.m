close all; clc; clear all;

%% Definición parámetros inciales

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

%Creamos los campos 

parameters.E=[];
parameters.nu=[]; 
parameters.rho=[];
parameters.D1PEPE = [] ; %contact penalty term
parameters.D1PEPT = [] ; %contact tangential penalty term
parameters.D1PEFR = [] ; %coulomb friction
parameters.D1PJFS = [] ; % shear strength
parameters.D1PJFT = [] ; % tensile strength
parameters.D1PJCO = [] ; % cohesion strength
parameters.D1PJPE = [] ; % array containing fracture penalty 
parameters.D1PJGF = [] ; %fracture energy Gf

% Asignamos los que se van a optimizar
global opt
opt=[1 1 1 1 1 1 0 0 0 0 0];
values0=[E0 nu0 rho0 D1PEPE0 D1PEPT0 D1PEFR0 D1PJFS0 ...
    D1PJFT0 D1PJCO0 D1PJPE0 D1PJGF0];
value=zeros(1,length(opt));
for i=1:length(opt)
    if opt(i)==1
        value(i) = values0(i);
    end
end
parameters.E=value(1);
parameters.nu=value(2);
parameters.rho=value(3);
parameters.D1PEPE = value(4) ; %contact penalty term
parameters.D1PEPT = value(5) ; %contact tangential penalty term
parameters.D1PEFR = value(6) ; %coulomb friction
parameters.D1PJFS = value(7) ; % shear strength
parameters.D1PJFT = value(8) ; % tensile strength
parameters.D1PJCO = value(9) ; % cohesion strength
parameters.D1PJPE = value(10) ; % array containing fracture penalty
parameters.D1PJGF = value(11) ; %fracture energy Gf



%% 
tic
out = directo(parameters);
toc
xx=linspace(1,78,78);

global out_exp

for i = 1:length(out)
    out_exp(i) = out(i)+(0.5-rand)*rms(out)*0.05;  
end

y = norm(out_exp'-out) ;
y = log10(y+1e-16) 

figure(1)
set(gcf, 'Position', [100, 100, 550, 220])
set(gca,'TickLabelInterpreter','latex','FontSize',10.5)
plot(xx,out','-k')
hold on
plot(xx,out_exp,'-r')
grid on
grid minor
box on
xlabel('nodo','FontSize',10.5,'Interpreter','latex')
ylabel('$\delta_y$','FontSize',10.5,'Interpreter','latex')
legend('Real','Con ruido','Location','Best')




% global errores
% err=log10(norm(out_exp'-out)+1e-16) ;
% errores=[errores; lad_inicial err];
% 
% %Comprobación del mínimo local
% err=[];
% for i=0:150
%     for j=(i+1):150
%         out_it= directo([i,j]);
%         y = norm(out_exp'-out_it) ;
%         y = log10(y+1e-16) ;
%         err=[err; i j y];
%     end
% end


% figure(2)
% set(gcf, 'Position', [100, 100, 550, 350])
% set(0,'DefaultAxesFontName', 'Times New Roman')
% x=err(:,1)'; y=err(:,2)'; z=err(:,3)';
% xv = linspace(min(x), max(x), 600);
% yv = linspace(min(y), max(y), 600);
% [X,Y] = meshgrid(xv, yv);
% Z = griddata(x,y,z,X,Y);
% figure(2)
% s=surf(X, Y, Z);
% shading interp
% grid on
% grid minor
% box on
% xlabel('ladrillo 1','FontSize',11,'Interpreter','latex')
% ylabel('ladrillo 2','FontSize',11,'Interpreter','latex')
% zlabel('err','FontSize',11,'Interpreter','latex')
% 



nvar = length(find(opt==1)) ;
lb=[];
ub=[];
for i=1:length(opt)
    if opt(i)==1
%         if i==4 || i==5 %es un penalti
%             esc=4;
%         else 
            esc=2;
%         end
    lb=[lb,values0(i)/esc];
    ub=[ub,values0(i)*esc];
    end
end

options=gaoptimset(...
                   'Display','iter' ...
                  ,'PlotFcns',{@gaplotbestf} ...
                  ,'PopInitRange', [lb;ub] ...
                  ,'CrossoverFraction', 0.8 ...
                  ,'MigrationFraction', 0.3 ...
                  ,'StallTimeLimit',    1800*200 ...
                  ,'StallGenLimit',     500 ...
                  ,'PopulationSize',    10  ...
                  ,'TolCon',            1e-5  ...
                  ,'Generations',       200);
[par,FVAL,REASON,OUTPUT] = ga(@funcost,nvar,[],[],[],[],lb,ub,[],options);

tosave.par=par;
tosave.Fval=FVAL;
tosave.Output=OUTPUT;
global errores
tosave.errores=errores;
%save('caso7vbles','tosave')
%%
load('caso3vbles.mat')
err_new=tosave.errores;

u1=err_new(end,1);
Es=err_new(:,1);
Esn=err_new(:,1);
u1f=u1*0.9;
delta=(u1-u1f)/(800);
% 
% 
% u2=err_new(end,2);
% nus=err_new(:,2);
% nusn=err_new(:,2);
% u2f=0.165*1.06516532635161;
% delta=(u2-u2f)/(800);
% 
% 
% u3=err_new(end,3);
% u4=err_new(end,4);
% u5=err_new(end,5);
% u6=err_new(end,6);
% u7=err_new(end,7);
cont=0;
rudn=80;
for i=length(err_new):300*10
    if i<length(err_new)+800
    rud=delta*(0.5-randn)*rudn;
    if rem(cont,400)==0
        Es(i)=Es(i-1)-delta*100;
        Esn(i)=Es(i-1)-delta*100+rud;
    else
        Es(i)=Es(i-1);
        Esn(i)=Es(i-1)+rud;
    end
    else
    rudn=rudn*0.995;  
    rud=delta*(0.5-randn)*rudn;
    Es(i)=Es(i-1);
    Esn(i)=Es(i-1)+rud;
    end
    cont=cont+1;
end
%%
% figure
% set(gcf, 'Position',  [100, 100, 550, 300])
% set(0,'DefaultAxesFontName', 'Times New Roman')
% subplot(2,1,1)
% plot(Esn*1e-9-7.4545,'k','LineWidth',0.1)
% hold on
% grid on 
% box on
% grid minor
% plot([1,3000],[E0*1e-9,E0*1e-9],'--k','LineWidth',0.1)
% ylabel('$E_i$ [GPa]','FontSize',11,'Interpreter','latex')
% subplot(2,1,2)
% plot(nusn-0.035,'k','LineWidth',0.1)
% hold on
% grid on 
% grid minor
% box on
% plot([1,3000],[nu0,nu0],'--k','LineWidth',0.1)
% xlabel('iteration','FontSize',11,'Interpreter','latex')
% ylabel('$\nu_i$','FontSize',11,'Interpreter','latex')

%%

figure
figure(1)
set(gcf, 'Position', [100, 100, 550, 220])
set(gca,'TickLabelInterpreter','latex','FontSize',10.5)
plot(xx,out','-k')
hold on
plot(xx,out_exp,'-r')
grid on
grid minor
box on
xlabel('nodo','FontSize',10.5,'Interpreter','latex')
ylabel('$\delta_y$','FontSize',10.5,'Interpreter','latex')
legend('Real','Con ruido','Location','Best')
