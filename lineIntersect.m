function [x, y] = lineIntersect(L1a, L1b, L2a, L2b)
  %****************************************************************************%
  %function to find intersection of two lines
  %****************************************************************************%
  %
  % INPUTS:
  %         L1a         - Line 1 x1 and y1 coordinates [x1, y1]
  %         L1b         - Line 1 x2 and y2 coordinates [x2, y2]
  %         L2a         - Line 2 x1 and y1 coordinates [x1, y1]
  %         L2b         - Line 2 x2 and y2 coordinates [x2, y2]
  %
  % OUTPUTS:
  %         x           - Intersection point, x coordinate, NaN if no intersection
  %         y           - Intersection point, y coordinate, NaN if no intersection
  %
  %****************************************************************************%
  % Data
  x1 = L1a(1);
  y1 = L1a(2);
  x2 = L1b(1);
  y2 = L1b(2);
  x3 = L2a(1);
  y3 = L2a(2);
  x4 = L2b(1);
  y4 = L2b(2);
  
  % line segments intersect
  u = ((x1-x3)*(y1-y2) - (y1-y3)*(x1-x2)) / ((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
  t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4)) / ((x1-x2)*(y3-y4)-(y1-y2)*(x3-x4));
  
  % find intersection
    x = ((x3 + u * (x4-x3)) + (x1 + t * (x2-x1))) / 2; 
    y = ((y3 + u * (y4-y3)) + (y1 + t * (y2-y1))) / 2;
    
 end