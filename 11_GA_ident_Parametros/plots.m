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

tic
out = directo(parameters);
load('caso7vbles');
errores=tosave.errores;
[~,pos]=min(errores(:,end));
par=errores(pos,:);
par=[32.9968e9,0.1526,2451.1566,2.75165161568e11,3.25165161568e10,0.66151545];
tosave.par=par;
save('caso7vbles','tosave')
parameters.E=par(1);
parameters.nu=par(2);
parameters.rho=par(3);
parameters.D1PEPE = par(4) ; %contact penalty term
parameters.D1PEPT = par(5) ; %contact tangential penalty term
parameters.D1PEFR = par(6) ; %coulomb friction
out2 = directo(parameters);
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
plot(xx,out'*1000,'-k','LineWidth',0.1)
% hold on
% plot(xx,out_exp,'-k','LineWidth',0.1)
hold on
plot(xx,out2'*1000,'-r','LineWidth',0.1)
grid on
grid minor
box on
xlabel('nodo','FontSize',10.5,'Interpreter','latex')
ylabel('$\Delta_y$ [mm]','FontSize',10.5,'Interpreter','latex')
legend('Real','Simulada','Location','Best')
