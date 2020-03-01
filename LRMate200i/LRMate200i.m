%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------TP 2 LR Mate 200i-----------------------------

% Breut Florian
% MIQ4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%d�finition des organes du robot � partir du param�trage du
%Denavit-Hartenberg
L1=link([pi/2 150 0 350 0], 'standard');
L2=link([0 250 pi/2 0 0], 'standard');
L3=link([pi/2 75 0 0 0], 'standard');
L4=link([pi/2 0 pi  290 0], 'standard');
L5=link([pi/2 0 pi 0 0], 'standard');
L6=link([0 0  0 100 0], 'standard');

%d�claration du robot
LRMate200i=robot({L1 L2 L3 L4 L5 L6});
LRMate200i.name = 'FANUC LR Mate 200i';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------Calcul du mod�le g�om�trique direct--------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%fkine : calcule la matrice homog�ne correspondant au passage � la position 
%et � l'orientation de l'organe en bout de chaine.

%tr2rpy : donne l'angle de roulis,lacet, tangage extraits de la matrice
%homog�ne calcul�e.

%Tn(1:3,4)' correspond � la translation exprim�e sous forme d'un vecteur


%D�finition des postitions articulaires
q1=[0 90 0 180 180 0]*pi/180;
q2=[45 60 30 120 170 45]*pi/180;
q3=[90 30 90 90 90 90]*pi/180;

%Calcul du mod�le g�om�trique direct pour la premi�re configuration
plot(LRMate200i,q1)%Trace la configuration du robot calcul�e pour q1
axis('equal')
title('Configuration q1 = [0 90 0 180 180 0]');
T1=fkine(LRMate200i,q1);%Calcul la matrice de rotation
disp('Configuration q1 = [0 90 0 180 180 0]');
X1=[T1(1:3,4)' tr2rpy(T1)*180/pi]%Calcul des coordonn�es op�rationnels
disp('appuyer sur une ENTREE')
pause();%mise en pause du programme pour 2 secondes
clf

%Calcul du mod�le g�om�trique direct pour la configuration 2
plot(LRMate200i,q2)
axis('equal')
title('Configuration q2 = [45 60 30 120 170 45]');
T2=fkine(LRMate200i,q2);
disp('Configuration q2 = [45 60 30 120 170 45]');
X2=[T2(1:3,4)' tr2rpy(T2)*180/pi]
disp('appuyer sur une ENTREE')
pause();
clf

%Calcul du mod�le g�om�trique direct pour la configuration 3
plot(LRMate200i,q3)
axis('equal')
title('Configuration q3 = [90 30 90 90 90 90]')
disp('Configuration q3 = [90 30 90 90 90 90]')
T3=fkine(LRMate200i,q3);
X3=[T3(1:3,4)' tr2rpy(T3)*180/pi]
disp('appuyer sur une ENTREE')
pause();
clf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-------------------Calcul du mod�le g�om�trique inverse-------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ikine : calcule les positions articulaires en radian � partir de la
%matrice homog�ne correspondant au passage du rep�re R0 au rep�re de bout
%de chaine.

%transl : construit la matrice homog�ne correspondant � la translation
%d�finie par un vecteur.

%rotx,roty,rotz : construisent les matrices homog�nes correspondant � une
%rotation respectivement autour de x,y,z

%MatHomn : Matrice homog�ne globale compos�e des matrices homog�nes de
%translations et de rotation


%D�finition de la postition et orientation de l'organe terminale
X1=[500 0 600 45 45 30];
X2=[450 450 500 0 0 90];
X3=[100 500 400 90 45 0];

%Construction des matrices homog�nes
MatHom1=transl(X1(1:3))*rotz(X1(6)*pi/180)*roty(X1(5)*pi/180)*rotx(X1(4)*pi/180);
MatHom2=transl(X2(1:3))*rotz(X2(6)*pi/180)*roty(X2(5)*pi/180)*rotx(X2(4)*pi/180);
MatHom3=transl(X3(1:3))*rotz(X3(6)*pi/180)*roty(X3(5)*pi/180)*rotx(X3(4)*pi/180);

%Mod�le g�om�trique inverse
qq1=mod(ikine(LRMate200i,MatHom1,q1),2*pi)*180/pi
qq2=mod(ikine(LRMate200i,MatHom2,q1),2*pi)*180/pi
qq3=mod(ikine(LRMate200i,MatHom3,q1),2*pi)*180/pi

%V�rification du mod�le pour les param�tre q1
MatHomV1=[0 -0 1 540;0 -1 -0 -0;1 0 -0 675;0 0 0 1 ];
qqV1=mod(ikine(LRMate200i,MatHomV1,q1),2*pi)*180/pi;

% Trac� des positions du Robot
plot(LRMate200i,qq1*pi/180)
axis('equal')
title('Configuration X1 = [500 0 600 45� 45� 30�]');
disp('appuyer sur une ENTREE')
pause()
clf
plot(LRMate200i,qq2*pi/180)
axis('equal')
title('Configuration X2 = [450 450 500 0� 0� 90�]');
disp('appuyer sur une ENTREE')
pause()
clf
plot(LRMate200i,qq3*pi/180)
axis('equal')
title('Configuration X3 = [100 500 400 90� 45� 0�]');
disp('appuyer sur une ENTREE')
pause()
clf


