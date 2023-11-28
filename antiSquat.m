function [aS, pD, initial_values] = antiSquat(IC, Rground, COGy, Fground, P, num_cogs, first_call, initial_values)
  %****************************************************************************%
  %function to find anti squat percentage
  %****************************************************************************%
  %
  % INPUTS:
  %         IC             - Coordinates of instant center [ICx, ICy]
  %         Rground        - Coordinates of ground contact with rear tire [ground_x, ground_y]
  %         COGy           - y coordinate of bike-rider center of gravity
  %         Fground        - Coordinates of ground contact with front tire
  %         P              - Coordinates of rear axle [x, y]
  %         num_cogs       - Number of rear cogs to solve for (1, 2, or 3)
  %         first_call     - true if this is the first time fourBar is calling antiSquat (means that travel==0)
  %         initial_values - length and angle values at travel==0 needed to calculate pedal kickback
  %                                  if first_call is true then returns 0
  %
  % OUTPUTS:
  %         aS             - anti-squat percentage of center of gravity height
  %         pD             - pedal kickback [rad]
  %         initial_values - length and angle values at travel==0 needed to calculate pedal kickback
  %
  %****************************************************************************%
  % Data

  ICx = IC(1);
  ICy = IC(2);
  ground_x = Rground(1);
  ground_y = Rground(2);
  Fground_x = Fground(1);
  Fground_y = Fground(2);

  % Solve chainline for various cog sizes
  %   num teeth * 0.5in * 25.4mm/in / pi = diameter in mm
  %   Shimano 8100 -> [10-12-14-16-18-21-24-28-33-39-45-51T]

  cog = [103.08, 90.96, 66.70, 20.21]; % radius [51, 45, 33, 10] teeth
  chainring = 64.68; % radius of 32t chainring

  aS = zeros(1, num_cogs); % predefine size of aS
  for i = 1:num_cogs
    % coordinates of smaller and large cogs
    % if cog is larger, x1 (smaller circle) is the chainring, else x1 is cog
    if cog(i) > chainring
      x1 = [0, 0];
      x2 = P; % coordinates of rear axle
      [t1, t2] = circleCircle(x1, x2, chainring, cog(i));
     else
      x1 = P; % coordinates of rear axle
      x2 = [0, 0];
      [t1, t2] = circleCircle(x1, x2, cog(i), chainring);
      % switch values of t1 and t2 so t1 always represents coordinate of...
      % chainring tangent and t2 is cog tangent
      ta = t1;
      t1 = t2;
      t2 = ta;
    endif

    % Find intersect of chainline and line connnecting rear axle to IC
    [x1, y1] = lineIntersect(P, IC, t1, t2);

    % Find equation of line rear contact to above intersect point y = m(x-x1)+y1 (point slope formula)
    m = ((y1-ground_y)/(x1-ground_x));

    % find y of line at x set at the front axle
    y = m*(Fground_x-x1)+y1;

    % find anti squat as a percentage. Need to measure heights from ground of rear wheel, not orgin at BB
    %% Should also fix antiRise to reflect this
    aS(1,i) = (y-ground_y)/(COGy-ground_y)*100;


  %%
  % Pedal kickback
  % Total pedal kickback is comprised of:
  %   1) upper chain length change
  %      rotation = (chainlength-chainlength_initial) / chainring radius
  %   2) wheel moving backwards relative to the bb
  %      cog_rotation = (rear_center - rear_center_initial) / wheel_radius
  %      rotation = cog_rotation * num_teeth_cog/num_teeth_chainring
  %   3) rotation by upper chain coming off and laying on the cogs as the...
  %          chainline rotates with suspension compression
  %      rotation = (chainline_angle - chainline_angle_inital) * ...
  %          (num_teeth_cog/num_teeth_chainring - 1)
  % pedal kickback = sum(rotation 1->3)

  if first_call == true % for starting position, calculate initial values
    pD(1, i) = 0;
    chainlength_initial = norm(t1-t2); % [mm]
    rear_center_initial = abs(P(1));% [mm]
    chainline_angle_inital = atan((t1(2)-t2(2))/(t1(1)-t2(1))); % [rad]
    initial_values(1, i) = chainlength_initial;
    initial_values(2, i) = rear_center_initial;
    initial_values(3, i) = chainline_angle_inital;
  else
  % scenario 1 calculation:
    chainlength = norm(t1-t2); % [mm]
    chainlength_initial = initial_values(1, i);
    rot_1 = (chainlength-chainlength_initial)/chainring; % [rad]

  % scenario 2 calculation:
    rear_center = abs(P(1));
    rear_center_initial = initial_values(2, i);
    cog_rot = (rear_center-rear_center_initial)/374.5; %THIS WOULD NEED TO BE CHANGED IF WHEEL IS NOT 29er%!!!!!
    num_teeth_cog = 4*pi*cog(i)/25.4;
    rot_2 = cog_rot * num_teeth_cog/32;

  % scenario 3 calculation:
    chainline_angle_inital = initial_values(3, i);
    chainline_angle = atan((t1(2)-t2(2))/(t1(1)-t2(1))); % [rad]
    rot_3 = -(chainline_angle-chainline_angle_inital)*(num_teeth_cog/32-1);

  % find pedal kickback
  pD(1, i) = rot_1+rot_2+rot_3;
  endif
  endfor
  end

