function y = funcost(parameters_it)


global opt
global parameters
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
value=zeros(1,length(opt));
for i=1:length(opt)
    if opt(i)==1
        value(i) = parameters_it(i);
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


out_it = calculo(parameters);


global out_exp
global errores
y = norm(out_exp'-out_it) ;
y = log10(y+1e-16) ;
errores=[errores; parameters_it y];
end