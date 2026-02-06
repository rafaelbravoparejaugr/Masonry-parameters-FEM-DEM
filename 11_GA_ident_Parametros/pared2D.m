function [ladrillos]=pared2D(X_a_ext,Y_a_ext,lad_arco)
global geometria
global Ydat

orX=[0,geometria.blad*1.5,geometria.blad*2,geometria.blad*2.5,geometria.blad*3,...
    geometria.blad*3.5,geometria.blad*3,geometria.blad*3.5,geometria.blad*4,...
    geometria.blad*3.5,geometria.blad*7,geometria.blad*7.5,geometria.blad*8,...
    geometria.blad*8.5,geometria.blad*8,geometria.blad*8.5,geometria.blad*8,...
    geometria.blad*8.5,geometria.blad*8,geometria.blad*8.5,geometria.blad*8,...
    geometria.blad*8.5,geometria.blad*8,geometria.blad*8.5];
nlat=geometria.L/geometria.blad/2;
nfil=geometria.Harco/geometria.hlad;
contL=1;
X=[];
Y=[];
y0=geometria.Harco;
pos=1;
problematic=[];

ep=2;
ini=0;
for j=1:nfil
    origenX=orX(j);
    for i=1:nlat
        if origenX+(i)*geometria.blad>geometria.L/2 && rem(j,2)==1
            break;
        end
        if origenX+(i)*geometria.blad>geometria.L/2 && rem(j,2)==0
            X=[X,origenX+(i-1)*geometria.blad,geometria.L/2,geometria.L/2,...
                origenX+(i-1)*geometria.blad];
            Y=[Y,y0-geometria.hlad*(j-1),y0-geometria.hlad*(j-1),...
                y0-geometria.hlad*(j),y0-geometria.hlad*(j)];
            ladrillos(pos,:)=[contL, contL+1, contL+2, contL+3, 0,0];
            pos=pos+1;
            contL=contL+4;
            break;
        else
            X=[X,origenX+(i-1)*geometria.blad,origenX+(i)*geometria.blad,...
                origenX+(i)*geometria.blad,origenX+(i-1)*geometria.blad];
            Y=[Y,y0-geometria.hlad*(j-1),y0-geometria.hlad*(j-1),...
                y0-geometria.hlad*(j),y0-geometria.hlad*(j)];
            ladrillos(pos,:)=[contL, contL+1, contL+2, contL+3, 0, 0]; 
            pos=pos+1;
            contL=contL+4;
        end
        if i<4 && j==1
            switch i
                case 1
                    a=(Y_a_ext(11)-Y_a_ext(12))/(X_a_ext(11)-X_a_ext(12));
                    b=Y_a_ext(12)-a*X_a_ext(12);
                    X(end-3)=X_a_ext(11);
                    Y(end-1)=a*X(end-1)+b;
                    X(end)=[];Y(end)=[];
                    contL=contL-4;
                    ladrillos(end,:)=[contL, contL+1, contL+2, 0, 0,0];
                    contL=contL+3;
                case 2
                    Y(end)=a*X(end)+b;
                    X=[X,X_a_ext(12)];
                    Y=[Y,Y_a_ext(12)];
                    a=(Y_a_ext(13)-Y_a_ext(12))/(X_a_ext(13)-X_a_ext(12));
                    b=Y_a_ext(12)-a*X_a_ext(12);
                    X(end-2)=(Y(end-2)-b)/a;
                    X(end-3)=X(end-2);
                    contL=contL-4;
                    ladrillos(end,:)=[contL, contL+1, contL+2,contL+4,contL+3,0];
                    contL=contL+5;
                    [p,~]=size(ladrillos);
                    problematic=[problematic, p];
                case 3 
                    X(end)=(Y(end)-b)/a;
                    X(end-3)=X(end);
            end
        end
        if i<3 && j==2
            switch i
                case 1
                    a=(Y_a_ext(13)-Y_a_ext(14))/(X_a_ext(13)-X_a_ext(14));
                    b=Y_a_ext(14)-a*X_a_ext(14);
                    X(end-3)=(Y(end-3)-b)/a;
                    Y(end-1)=a*X(end-1)+b;
                    X(end)=[];Y(end)=[];
                    contL=contL-4;
                    ladrillos(end,:)=[contL, contL+1, contL+2, 0, 0, 0];
                    contL=contL+3;
                case 2
                    X(end)=(Y(end)-b)/a;
                    X=[X,X(end-3)];
                    Y=[Y,a*X(end-4)+b];
                    contL=contL-4;
                    ladrillos(end,:)=[contL, contL+1, contL+2,contL+3,contL+4,0];
                    contL=contL+5;
            end
        end
        if i<3 && j==3
            switch i
                case 1
                    a=(Y_a_ext(15)-Y_a_ext(14))/(X_a_ext(15)-X_a_ext(14));
                    b=Y_a_ext(14)-a*X_a_ext(14);
                    X(end-3)=(Y(end-3)-b)/a;
                    Y(end-1)=a*X(end-1)+b;
                    X(end)=[];Y(end)=[];
                    contL=contL-4;
                    ladrillos(end,:)=[contL, contL+1, contL+2, 0, 0, 0];
                    contL=contL+3;
                case 2
                    X(end)=(Y(end)-b)/a;
                    X=[X,X(end-3)];
                    Y=[Y,a*X(end-4)+b];
                    contL=contL-4;
                    ladrillos(end,:)=[contL, contL+1, contL+2,contL+3,contL+4,0];
                    contL=contL+5;
            end
        end
        
        if i<3 && j==4
            switch i
                case 1
                    X(end-3)=(Y(end-3)-b)/a;
                    a=(Y_a_ext(15)-Y_a_ext(16))/(X_a_ext(15)-X_a_ext(16));
                    b=Y_a_ext(16)-a*X_a_ext(16);
                    X(end-1)=(Y(end-1)-b)/a;
                    X(end-2)=X(end-1);
                    X(end)=X_a_ext(15);
                    Y(end)=Y_a_ext(15);
                    [p,~]=size(ladrillos);
                    problematic=[problematic, p];
                case 2
                    X(end)=(Y(end)-b)/a;
                    X(end-3)=X(end);
            end
        end
        
        
        
        if i==1 && j==5
            X(end-3)=(Y(end-3)-b)/a;
            X=[X,X_a_ext(16)];
            Y=[Y,Y_a_ext(16)];
            a=(Y_a_ext(16)-Y_a_ext(17))/(X_a_ext(16)-X_a_ext(17));
            b=Y_a_ext(17)-a*X_a_ext(17);
            X(end-1)=(Y(end-2)-b)/a;
            contL=contL-4;
            ladrillos(end,:)=[contL, contL+1, contL+2,contL+3,contL+4,0];
            contL=contL+5;
            [p,~]=size(ladrillos);
            problematic=[problematic, p];
        end
        
                
        if i==1 && j==6
            X(end-3)=(Y(end-3)-b)/a;
            X(end)=(Y(end)-b)/a;
        end
        
        
        if i<3 && j==7
            switch i
                case 1
            X(end-3)=(Y(end-3)-b)/a;
            X=[X,X_a_ext(17)];
            Y=[Y,Y_a_ext(17)];
            a=(Y_a_ext(18)-Y_a_ext(17))/(X_a_ext(18)-X_a_ext(17));
            b=Y_a_ext(17)-a*X_a_ext(17);
            X(end-1)=(Y(end-2)-b)/a;
            X(end-2)=X(end-2)+0.1;
            X(end-3)=X(end-2);
            contL=contL-4;
            ladrillos(end,:)=[contL, contL+1, contL+2,contL+3,contL+4,0];
            contL=contL+5;
            [p,~]=size(ladrillos);
            problematic=[problematic, p];
                case 2
                    X(end)=X(end)+0.1;
                    X(end-3)=X(end);
            end
        end
        if i==1 && j==8
            X(end-3)=(Y(end-3)-b)/a;
            X(end)=(Y(end)-b)/a;
            [p,~]=size(ladrillos);
            problematic=[problematic, p];
        end
        
        if i==1 && j>8
            X(end-3)=X_a_ext(18);
            X(end)=X_a_ext(18);
        end
    end
    
    for k=ini+1:pos-1
        if rem(j,2)==1
            if rem(k,2)==1
                ep=2;
            else
                ep=3;
            end
        else
            if rem(k,2)==1
                ep=4;
            else
                ep=5;
            end
        end
        EP(k)=ep;
    end
        ini=pos-1;
end

%simetria de los ladrillos
[mlad,~]=size(ladrillos);
for i=1:mlad
    duplicate=nonzeros(ladrillos(i,:))'+length(X);
ladrillos(i+mlad,:)=[duplicate zeros(1,6-length(duplicate))];
end

problematic=[problematic,problematic+mlad];
EP=[EP,EP];
X=[X,-X];
Y=[Y,Y];

nplat=2; %ladrillos en la plataforma
y0=geometria.Harco+geometria.hlad*nplat;
[pos,~]=size(ladrillos);
pos=pos+1;
refpos=pos;
contL=length(X)+1;
ini=length(ladrillos);


for j=1:nplat
    if rem(j,2)==0
        for i=1:nlat*2+1
            origenX=-geometria.L/2-geometria.blad/2;
            if i==1
                X=[X,-geometria.L/2,origenX+(i)*geometria.blad,...
                    origenX+(i)*geometria.blad,-geometria.L/2];
            elseif i==nlat*2+1
                X=[X,origenX+(i-1)*geometria.blad,geometria.L/2,...
                    geometria.L/2,origenX+(i-1)*geometria.blad];
            else
                X=[X,origenX+(i-1)*geometria.blad,origenX+(i)*geometria.blad,...
                    origenX+(i)*geometria.blad,origenX+(i-1)*geometria.blad];
                
            end
            Y=[Y,y0-geometria.hlad*(j-1),y0-geometria.hlad*(j-1),...
                y0-geometria.hlad*(j),y0-geometria.hlad*(j)];
            ladrillos(pos,:)=[contL, contL+1, contL+2, contL+3, 0,0];
            pos=pos+1;
            contL=contL+4;
        end
    else
        for i=1:nlat*2
            origenX=-geometria.L/2;
            X=[X,origenX+(i-1)*geometria.blad,origenX+(i)*geometria.blad,...
                origenX+(i)*geometria.blad,origenX+(i-1)*geometria.blad];
            Y=[Y,y0-geometria.hlad*(j-1),y0-geometria.hlad*(j-1),...
                y0-geometria.hlad*(j),y0-geometria.hlad*(j)];
            ladrillos(pos,:)=[contL, contL+1, contL+2, contL+3, 0,0];
            pos=pos+1;
            contL=contL+4;
        end
    end
    for k=ini+1:pos-1
        if rem(j,2)==1
            if rem(k,2)==1
                ep=2;
            else
                ep=3;
            end
        else
            if rem(k,2)==1
                ep=4;
            else
                ep=5;
            end
        end
        EP(k)=ep;
    end
    ini=pos-1;
end

ep=max(Ydat.EP)+1;
corr=length(Ydat.Xnode);



[m,~]=size(ladrillos);
for i=1:m
    actual=nonzeros(ladrillos(i,:))';
    pgon=polyshape(X(actual),Y(actual));
    plot(pgon);
    hold on
    model = createpde;
    tr = triangulation(pgon);
    tnodes = tr.Points';
    telements = tr.ConnectivityList';
    geometryFromMesh(model,tnodes,telements)
    if i>=refpos
        reff=0.75;
    else 
        reff=1;
    end
    generateMesh(model,'GeometricOrder','linear','Hmax',geometria.elemMin*reff*2)
    if find(i==problematic)>0
        Ydat.Xnode=[Ydat.Xnode tnodes(1,:)];
        Ydat.Ynode=[Ydat.Ynode tnodes(2,:)];
        Ydat.elements=[Ydat.elements; telements'+corr];
        [~, nd]=size(telements);
        Ydat.EP=[Ydat.EP ones(1,nd)*EP(i)];
    else
        Ydat.Xnode=[Ydat.Xnode model.Mesh.Nodes(1,:)];
        Ydat.Ynode=[Ydat.Ynode model.Mesh.Nodes(2,:)];
        Ydat.elements=[Ydat.elements; model.Mesh.Elements'+corr];
        [~, nd]=size(model.Mesh.Elements);
        Ydat.EP=[Ydat.EP ones(1,nd)*EP(i)];
    end
    corr=length(Ydat.Xnode);
    ep=ep+1;
    % pdemesh(model)
    hold on
end

for i=1:length(ladrillos)
    actual=nonzeros(ladrillos(i,:))';
    la=length(actual);
    xs1=0;
    ys1=0;
    for j=1:la
        xs1=xs1+X(actual(j));
        ys1=ys1+Y(actual(j));
    end
    xs1=xs1/la;
    ys1=ys1/la;
    text(xs1,ys1,num2str(i+Ydat.arcoL,'%d'),'fontsize',10,...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end

corr=max(max(Ydat.ladrillos));
Ydat.ladrillos=[Ydat.ladrillos; ladrillos+corr];


 end