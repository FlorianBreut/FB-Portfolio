function [values] = axisadjust (xmin,xmax,ymin,ymax,width,height)

% Function routine to adjust the axis limits so that the viewport 
% and window in Matlab 5.0 is closer to that in Matlab 4.2 when
% the command "axis equal" is used.  The input variables are:

% xmin = minimum value for horizontal axis
% xmax = maximum value for horizontal axis
% ymin = minimum value for vertical axis
% ymax = maximum value for vertical axis
% width = width of viewport in normalized units (0 - 1)
% height = height of viewport in normalized units (0 - 1)

% The results are returned in the vector values where 
% values(1) = corrected xmin
% values(2) = corrected xmax
% values(3) = corrected ymin
% values(4) = corrected ymax

rangex=xmax-xmin;
rangey=ymax-ymin;
ratx=rangex/width;
raty=rangey/height;
xmint=xmin;
xmaxt=xmax;
ymint=ymin;
ymaxt=ymax;
if ratx > raty
	rangey1=height*ratx;
	delta=(rangey1-rangey)/2;
	ymint=ymin-delta;
	ymaxt=ymax+delta;
end
if raty > ratx
	rangex1=width*raty;
	delta=(rangex1-rangex)/2;
	xmint=xmin-delta;
	xmaxt=xmax+delta;
end
values(1)=xmint;
values(2)=xmaxt;
values(3)=ymint;
values(4)=ymaxt;
