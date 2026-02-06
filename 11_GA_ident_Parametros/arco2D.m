function [X_a_ext,Y_a_ext]=arco2D()

global geometria
%Construcción zapata
X0 = 0; Z0 = 0; %origen de coordenadas
Nt=geometria.N; %numero total de piedras arco
geometria.hz1=geometria.hz/geometria.Nz; %Alto de cada piedra de la zapata

% % Las piedras del arco deben ser siempre impares.
% if rem(Nt,2) == 1 %resto
% else
%     Nt = Nt + 1;
% end


%angulos
angle = zeros(1,Nt);
for n = 1 : Nt %Mitad de las piedras
    angle(1,n) = round(pi/Nt,4);   
end

angle(1,(Nt-1)/2+1) = pi - (Nt-1)* angle(1,n);

for n = (Nt-1)/2+2 : Nt
    angle(1,n) = round(pi/Nt,4);
end

%ángulo acumulado
angles = angle;
angint=angle/2;
for n=1:length(angle)-1
    angles(n+1) = angles(n) + angle(n+1);
    angint(n+1) = angint(n) + angle(n+1);
end


%Construcción zapata
for j=1 : geometria.Nz 
    X(j+1) = X0;
    Y(j+1) = Z0 + geometria.hz1*j;
end

%arco
n = length(X);
for j= n + 1 : n + Nt
    Y(j) = Y(n) + sin(angles(j-n))*(geometria.R+geometria.t);
    X(j) = X0 + (geometria.R+geometria.t) - sqrt((geometria.R+geometria.t)^2-(Y(j) -  Y(n))^2) * sign(cos(angles(j-n)));
end

Zz=Y(j);

%zapata derecha
n = length(X);
for j=n + 1 : n + geometria.Nz
    X(j) = X(n);
    Y(j) = round(Y(j-1) - geometria.hz1,3);
end

c1 = length(X);
X_a_ext = X;
Y_a_ext = Y;
n = length(X);
z0=n;

%% Construimos el arco interior
n = length(X);
%zapata izquierda
for j = n + 1 : n + geometria.Nz+1
    X(j) = X0+geometria.t ;
    Y(j) = round(Z0 + geometria.hz1*(j-(n + 1)),3);
end


%arco
n = length(X);
for j= n + 1 : n + Nt
    Y(j) = Y(n) + sin(angles(j-n))*(geometria.R);
    X(j) = X0 + (geometria.R+geometria.t) - sqrt((geometria.R)^2-(Y(j) -  Y(n))^2) * sign(cos(angles(j-n)));
end


%zapata derecha
n = length(X);
for j=n + 1 : n + geometria.Nz
    X(j) = X(n);
    Y(j) = Y(j-1) - geometria.hz1;
end


%paso a vector columna
X = X';
Y = Y';

ladrillos=[];
for i=1:c1-1
    ladrillos=[ladrillos;i,i+1,c1+i+1,c1+i];
end

cor=abs(max(X)+min(X))/2;
X=X-cor;
X_a_ext=X_a_ext-cor;
global Ydat
Ydat.Xnode=[];
Ydat.Ynode=[];
Ydat.elements=[]; 
Ydat.EP=[];
ep=0;
corr=0;

Ydat.arcoL=length(ladrillos);

for i=1:length(ladrillos)
pgon=polyshape(X(ladrillos(i,:)),Y(ladrillos(i,:)));
plot(pgon);
hold on
model = createpde;
tr = triangulation(pgon);
tnodes = tr.Points';
telements = tr.ConnectivityList';
geometryFromMesh(model,tnodes,telements)
generateMesh(model,'GeometricOrder','linear','Hmax',geometria.elemMin)
Ydat.Xnode=[Ydat.Xnode model.Mesh.Nodes(1,:)];
Ydat.Ynode=[Ydat.Ynode model.Mesh.Nodes(2,:)];
Ydat.elements=[Ydat.elements; model.Mesh.Elements'+corr];
[~, nd]=size(model.Mesh.Elements);
Ydat.EP=[Ydat.EP ones(1,nd)*ep];

corr=length(Ydat.Xnode);
if rem(i,2)==1
ep=1;
else 
    ep=0;
end
% pdemesh(model)
hold on
end

ladrillos=[ladrillos zeros(length(ladrillos),2)];
Ydat.ladrillos=ladrillos;
for i=1:length(ladrillos)
    xs1=(X(ladrillos(i,1))+X(ladrillos(i,2))+X(ladrillos(i,3))+X(ladrillos(i,4)))/4;
    ys1=(Y(ladrillos(i,1))+Y(ladrillos(i,2))+Y(ladrillos(i,3))+Y(ladrillos(i,4)))/4;
    text(xs1,ys1,num2str(i,'%d'),'fontsize',10,...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
end

