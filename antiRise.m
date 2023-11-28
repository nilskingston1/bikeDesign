function aR = antiRise(IC, Rground, COGy, Fground)
  %****************************************************************************%
  %function to find anti rise percentage
  %****************************************************************************%
  %
  % INPUTS:
  %         IC          - Coordinates of instant center [ICx, ICy]
  %         Rground     - Coordinates of ground contact with rear tire [ground_x, ground_y]
  %         COGy        - y coordinate of bike-rider center of gravity
  %         Fground     - Coordinates of ground contact with front tire
  %
  % OUTPUTS:
  %         aR          - anti-rise percentage of center of gravity height
  %
  %****************************************************************************%
  % Data
  ICx = IC(1);
  ICy = IC(2);
  ground_x = Rground(1);
  ground_y = Rground(2);
  Fground_x = Fground(1);
  Fground_y = Fground(2);
  
  % Find equation of line rear contact to IC y = m(x-x1)+y1 (point slope formula)
  m = ((ICy-ground_y)/(ICx-ground_x));
  x1 = ICx;
  y1 = ICy;
  
  % find y of line at x set at the front axle
  y = m*(Fground_x-x1)+y1;
  
  % find anti rise as a percentage. Need to measure heights from ground of front wheel, not orgin at BB
  aR = (y-ground_y)/(COGy-ground_y)*100;
 end
  