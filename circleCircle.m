function [t1, t2] = circleCircle(x1, x2, r, R)
  %****************************************************************************%
  %function to find tangent points of chainline (circle-cicle tangent)
  %****************************************************************************%
  %
  % INPUTS:
  %         x1          - Coordinates of smaller circle [x1, y1]
  %         x2          - Coordinates of larger circle [x2, y2]
  %         r           - Radius of smaller circle
  %         R           - Radius of larger circle
  %
  % OUTPUTS:
  %         t1          - coordinates of tangency smaller circle [x, y]
  %         t2          - coordinates point of tangency larger circle [x, y]
  %         
  %****************************************************************************%
  x1 = x1.'; % transpose to column vector
  x2 = x2.'; % transpose to column vector
  
  gamma = -atand((x2(2)-x1(2))/(x2(1)-x1(1)));
  beta1 = asind((R-r)/(sqrt((x2(1)-x1(1))^2+(x2(2)-x1(2))^2)));
  beta2 = -beta1;
  
  alpha = gamma-beta1; %need to detrmine which beta to usejava
  alpha2 = gamma-beta2;
  
  % There are 4 solutions (4 tangent lines), but only one represents the chainline
  % Through testing, solution #3 (c) seems to represent chainline for cog>chainring
  % and solution, # 1 (a) seems to represent chainline for cog<chainring
  
  t1a = x1+r*[sind(alpha);cosd(alpha)];
  t2a = x2+R*[sind(alpha);cosd(alpha)];
  
  %t1b = x1-r*[sind(alpha);cosd(alpha)];
  %t2b = x2-R*[sind(alpha);cosd(alpha)];
  
  t1c = x1+r*[sind(alpha2);cosd(alpha2)];
  t2c = x2+R*[sind(alpha2);cosd(alpha2)];
  
  %t1d = x1-r*[sind(alpha2);cosd(alpha2)];
  %t2d = x2-R*[sind(alpha2);cosd(alpha2)];
  
  %t1 = [t1a;t1b;t1c;t1d]
  %t2 = [t2a;t2b;t2c;t2d]
  
  if x1(1) > x2(1) % If chainring is smaller than cog
    t1 = t1c.'; %transpose and save solution 3
    t2 = t2c.'; %transpose and save solution 3
  else
    t1 = t1a.'; %transpose and save solution 1
    t2 = t2a.'; %transpose and save solution 1
  endif

end