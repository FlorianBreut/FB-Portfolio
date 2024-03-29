function [coords] = bushing(r,x0,y0,ninc,theta)

% This function determines the coordinates of a series of points defining 
% the outside of a bushing.  The radius of the pin is r.  The pin is not 
% computed.  It should be determined using the function "circle".
% The input values are:

%r       = radius of circle
%x0      = x coordinate of center of circle
%y0      = y coordinate of center of circle
%ninc    = number of increments into which the semicircle is divided
%angle 	 = rotation angle relative to the horizontal x axis (degrees)

% The results are returned in the vector "coords".  The answers are 
% stored in values according to the following:

%coords (i,1) = x coordinates of bushing
%coords (i,2) = y coordinates of bushing

% The number of points stored is npoints where npoints = ninc+16

% find the coordinates of the points.

npoints=ninc+16;
inc=pi/ninc;
i=0;
tr=3*r;
fact=pi/180;
thetar=fact*theta;
c=cos(fact*45);
cr=r*c;
p=r*(6-c)/3;
tp=2*p;
delta=(6*r-cr)/3;

% define the base first

i=i+1;
xtemp(i)=-tr+cr;
ytemp(i)=-tr-cr;
i=i+1;
xtemp(i)=-tr;
ytemp(i)=-tr;

% find the dash coordinates starting from the left end

for j=1:1:3
	i=i+1;
	xtemp(i)=xtemp(i-1)+delta;
	ytemp(i)=ytemp(i-1);
	i=i+1;
	xtemp(i)=xtemp(i-1)+cr;
	ytemp(i)=ytemp(i-1)-cr;
	i=i+1;
	xtemp(i)=xtemp(i-2);
	ytemp(i)=ytemp(i-2);
end

% find the coordinates of the end part	

i=i+1;
xtemp(i)=tr;
ytemp(i)=-tr;

% locate the right vertical line

i=i+1;
xtemp(i)=2*r;
ytemp(i)=-tr;
i=i+1;
xtemp(i)=2*r;
ytemp(i)=0;

% locate the semicircle

for j=0:inc:pi
	i=i+1;
	xtemp(i)=2*r*cos(j);
	ytemp(i)=2*r*sin(j);
end

% locate the left vertical line

i=i+1;
xtemp(i)=-2*r;
ytemp(i)=-tr;

% rotate coordinates, translate by (x0, y0) and store coordinates in "coords"

c=cos(thetar);
s=sin(thetar);

for j=1:1:npoints
	coords(j,1)=x0+xtemp(j)*c-ytemp(j)*s;
	coords(j,2)=y0+xtemp(j)*s+ytemp(j)*c;
end
