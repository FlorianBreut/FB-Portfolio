function [coords] = circle(r,x0,y0,ninc)

% This function determines the coordinates of a series of points defining a
% circle of radius r.  The number of points stored is ninc+1. 
% The input values are:

%r       = radius of circle
%x0      = x coordinate of center of circle
%y0      = y coordinate of center of circle
%ninc    = number of increments into which circle is divided

% The results are returned in the vector "coords".  The answers are 
% stored in values according to the following:

%coords (i,1) = x coordinate of points on circle
%coords (i,2) = y coordinate of points on circle

% find the coordinates of the points.

inc=2*pi/ninc;
npoints = ninc+1;
i=0;
for j=0:inc:2*pi
	i=i+1;
	coords(i,1)=x0+r*cos(j);
	coords(i,2)=y0+r*sin(j);
end

