%-----------------------------------------------------------------------%
%---------------------------M�canisme 6 barres--------------------------%
%-----------------------------------------------------------------------%

%%% Florian Breut

%%%r�solution num�rique d'un m�canisme 6 barres par la m�thode de Newton
%%%

%-----------------------------------------------------------------------%
%-----------------------------------------------------------------------%
%-----------------------------------------------------------------------%

disp('   ')
disp('        Programme d''analyse d''un m�canisme 6 barres')

clear all;   %% nettoyage de la m�moire

%-----------------------------------------------------------------------%
%------------------------M�canisme plan 6 barres------------------------%
%-----------------------------------------------------------------------%

%%% longueur des barres (en mm)
l1=20;
l2=10;
l3=20;
l4=15;
l5=22;
l6=10;
l7=23.8;
lc=20;

%%% angles constants du m�canisme (en rad)
q1=30*pi/180;
q7=75.4*pi/180;
beta=30*pi/180;
q20=70*pi/180;

%%% Vitesse de d�part (en tr/s)
w=2*pi;

%%% coordonn�es des paliers A,D,G
Ax=0;
Ay=0;
Dx=l1*cos(q1);
Dy=-l1*sin(q1);
Gx=l7*cos(q7);
Gy=-l7*sin(q7);

%-----------------------------------------------------------------------%
%---------------d�termination des positions articulairese---------------%
%-----------------------------------------------------------------------%

%initialisation pour l'utilisationd de la m�thode de NewtonRaphson
%valeurs estim�es pour le d�part � partir de la figure de l'�nonc�
X0=[70*pi/180+0.1, -15*pi/180+0.1, 70*pi/180+0.1, 30*pi/180+0.1,...
    140*pi/180+0.1, 17.5+0.1, -5+0.1];%initialisation du vecteur X
eps=0.001*ones(1,7); %vecteur d�terminant la pr�cision de la m�thode
DX0=[10, 10, 10, 10, 10, 10, 10];%initilisation du vecteur DX

%-----------------------------------------------------------------------%
%------------------------trac� de la trajectoire------------------------%
%-----------------------------------------------------------------------%

%%% Pr�paration du trac� des paliers A,D,G
bush1=bushing((0.5),Ax,Ay,20,0);
cir1=circle((0.5),Ax,Ay,20);
bush2=bushing((0.5),Dx,Dy,20,0);
cir2=circle((0.5),Dx,Dy,20);
bush3=bushing((0.5),Gx,Gy,20,0);
cir3=circle((0.5),Gx,Gy,20);

%Dur�e totale de la simulation
Tf=5;
%%% incr�ment temporel
dt=0.01;
%initialisation de la trajectoire
traj=[0;0];
%Oppos� de la d�riv�e partielle de F par rapport au temps
dFtneg=[0;0;0;0;0;0;w];

%simulation avec un pas dt et une dur�e Tf
for T=0:dt:Tf

    %Algorithme de Newton Raphson
    DX=DX0;
    Xav=X0;
  while (DX(1) >= eps(1) | DX(2) >= eps(2) | DX(3) >= eps(3)| ...
          DX(4) >= eps(4)| DX(5) >= eps(5)| DX(6) >= eps(6)| DX(7) >= eps(7))
    %Expression matricielle de F
    FXav=[l2*cos(Xav(1))+l3*cos(Xav(2))-l4*cos(Xav(3))-l1*cos(q1);...
    l2*sin(Xav(1))-l3*sin(Xav(2))-l4*sin(Xav(3))+l1*sin(q1);...
    l2*cos(Xav(1))+lc*cos(Xav(2)+beta)-Xav(6);...
    l2*sin(Xav(2))-lc*sin(Xav(2)+beta)-Xav(7);...
    l6*cos(Xav(5))+l5*cos(Xav(4))+l7*cos(q7)-Xav(6);...
    l6*sin(Xav(5))+l5*sin(Xav(4))-l7*sin(q7)-Xav(7);...
    Xav(1)-w*T-q20];
    %Expression de la jacobienne
    JXav=[-l2*sin(Xav(1)),-l3*sin(Xav(2)),l4*sin(Xav(3)),0,0,0,0;...
        l2*cos(Xav(1)),-l3*cos(Xav(2)),-l4*cos(Xav(3)),0,0,0,0;...
        -l2*sin(Xav(1)),-lc*sin(Xav(2)+beta),0,0,0,-1,0;...
        l2*cos(Xav(1)),-lc*cos(Xav(2)+beta),0,0,0,0,-1;...
        0,0,0,-l5*sin(Xav(4)),-l6*sin(Xav(5)),-1,0;...
        0,0,0,l5*cos(Xav(4)),l6*cos(Xav(5)),0,-1;...
        1,0,0,0,0,0,0];
    if det(JXav) ~= 0 %cas d�terminant non nul
       DX=(-inv(JXav)*FXav)';
       Xap=Xav+DX;
       Xav=Xap;
    else
      disp('erreur : jacobienne non inversible') %cas d�terminant nul
      break
    end
    X = Xav;%Vecteur X en sortie de la m�thode Newton-Raphson 
    Xp=JXav\dFtneg; 
    %calcul de la d�riv�e du vecteur X et d�termination du mod�le 
    %cin�matique directe
end  

X0=X;

%%% Calcul des positions des points B,C,E,F
Bx = l2*cos(X(1));
By = l2*sin(X(1));
Cx = l1*cos(q1)+l4*cos(X(3));
Cy = -l1*sin(q1)+l4*sin(X(3));
Ex = l2*cos(X(1))+lc*cos(X(2)+beta);
Ey = l2*sin(X(1))-lc*sin(X(2)+beta);
Fx = l7*cos(q7)+l6*cos(X(5));
Fy = -l7*sin(q7)+l6*sin(X(5));

%Pr�paration des trac�s
EE=[Ex;Ey];%coordonn�e de E
if T==0 %remplissage du premier point des graphes
Vx=0;%vitesse de E selon x
Vy=0;%vitesse de E selon y
traj=EE;%coordonn�es du point E
Qsp=0;%vitesse de sortie en rad/s
Qe=mod(X(1)*180/pi,360);%angle d'entr�e en �
Qs=mod(X(5)*180/pi,360);%angle de sortie en �
else
%ajout des points, vitesses et angles suivants � chaque it�ration
Vx=[Vx,Xp(6)];
Vy=[Vy,Xp(7)];
traj=[traj,EE];
Qe=[Qe,mod(X(1)*180/pi,360)];
Qs=[Qs,mod(X(5)*180/pi,360)];
Qsp=[Qsp,Xp(5)*180/pi];
end

% disp('v�rification de longeur de barre EB');
% dC=sqrt((Bx-Ex)^2+(By-Ey)^2);

%%% Pr�paration de la fenetre graphique 
%%% Mise � l'�chelle 
clf;

%trac� de la trajectoire
plot(traj(1,:),traj(2,:),'g');
grid on; %activation de la grille
axis equal %axes de meme �chelle
axis([-15 35 -35 15]) %Limitation de la fenetre d'affichage

%%% Pr�paration des vecteurs n�cessaires au trac� du m�canisme � barres
joint1=line('xdata', [], 'ydata', [], 'marker', 'o','markersize', ...
      6, 'erasemode', 'xor', 'color', 'k');  
joint2=line('xdata', [], 'ydata', [], 'marker', 'o','markersize', ...
      6, 'erasemode', 'xor', 'color', 'k');
joint3=line('xdata', [], 'ydata', [], 'marker', 'o','markersize', ...
      6, 'erasemode', 'xor', 'color', 'k');
joint4=line('xdata', [], 'ydata', [], 'marker', 'o','markersize', ...
      6, 'erasemode', 'xor', 'color', 'k');
bar2=line('xdata', [], 'ydata' ,[], 'linewidth' ,2, 'erasemode', ...
       'xor','color', 'b');
bar3=line('xdata', [], 'ydata' ,[], 'linewidth' ,2, 'erasemode', ...
       'xor','color', 'b');
bar4=line('xdata', [], 'ydata' ,[], 'linewidth' ,2, 'erasemode', ...
       'xor','color', 'b');
bar5=line('xdata', [], 'ydata' ,[], 'linewidth' ,2, 'erasemode', ...
       'xor','color', 'b');
bar6=line('xdata', [], 'ydata' ,[], 'linewidth' ,2, 'erasemode', ...
       'xor','color', 'b');
barE=line('xdata', [], 'ydata' ,[], 'linewidth' ,2, 'erasemode', ...
       'xor','color', 'k');
barEE=line('xdata', [], 'ydata' ,[], 'linewidth' ,2, 'erasemode', ...
       'xor','color', 'k');
bushy1=line('xdata', bush1(:,1), 'ydata',bush1(:,2), 'linestyle', '-',...
        'color', 'r');
circ1=line('xdata', cir1(:,1), 'ydata',cir1(:,2), 'linestyle', '-',...
        'color', 'r');
bushy2=line('xdata', bush2(:,1), 'ydata',bush2(:,2), 'linestyle', '-',...
        'color', 'r');
circ2=line('xdata', cir2(:,1), 'ydata',cir2(:,2), 'linestyle', '-',...
        'color', 'r');
bushy3=line('xdata', bush3(:,1), 'ydata',bush3(:,2), 'linestyle', '-',...
        'color', 'r');
circ3=line('xdata', cir3(:,1), 'ydata',cir3(:,2), 'linestyle', '-',...
        'color', 'r');

%%% Trac� du m�canisme dans une position donn�e
    set(joint1,'xdata', Bx, 'ydata',By);
    set(joint2,'xdata', Cx, 'ydata',Cy);
    set(joint3,'xdata', Ex, 'ydata',Ey)
    set(joint4,'xdata', Fx, 'ydata',Fy)
    set(bar2,'xdata',[0 Bx],'ydata', [0 By]);
    set(bar3,'xdata', [Bx Cx],'ydata', [By Cy]);
    set(bar4,'xdata', [Dx Cx],'ydata', [Dy Cy]);
    set(bar5,'xdata', [Fx Ex],'ydata', [Fy Ey]);
    set(bar6,'xdata', [Gx Fx],'ydata', [Gy Fy]);
    set(barE,'xdata',[Bx Ex],'ydata', [By Ey]);
    set(barEE,'xdata', [Ex Cx],'ydata', [Ey Cy]);
drawnow; %flush the draw buffer

end %fin de boucle for

%-----------------------------------------------------------------------%
%---------------------------Trac� des Graphes---------------------------%
%-----------------------------------------------------------------------%

%Suppression des "discontinuit� de d�part"
Qsp(1)=Qsp(2);
Vx(1)=Vx(2);
Vy(1)=Vy(2);

%trac�s et l�gendes es graphs
L=0:dt:Tf;
figure
%trac� de la vitesse Vx (m/s)
subplot(2,2,1)
plot(L,Vx)
grid on
title('Vitesse de E selon x')
xlabel('t (s)')
ylabel('Vx (m/s)')
%trac� de la vitesse Vy (m/s)
subplot(2,2,2)
plot(L,Vy)
grid on
title('Vitesse de E selon y')
xlabel('t (s)')
ylabel('Vy (m/s)')
%trac� de Qs=f(Qe) angle de sortie (�)
subplot(2,2,3)
plot(Qe,Qs,'.')
grid on
title('Angle de sortie = f(Angle en entr�e)')
xlabel('Qe (�)')
ylabel('Qs (�)')
axis([0 360 min(Qs)-10 max(Qs)+10])
%trac� de Qsp=f(Qe) vitesse de sortie (rad/s)
subplot(2,2,4)
plot(Qe,Qsp,'.')
grid on
title('Vitesse de sortie = f(Angle en entr�e)')
xlabel('Qe (�)')
ylabel('Ws (rad/s)')
axis([0 360 min(Qsp)-10 max(Qsp)+10])