%****************************************************************************%
% Code to calculate the kinematics of a 4 bar suspension
% Current functionality includes:
%   - position of pivots and axle throughout the travel
%   - position of instant center (IC) throughout the travel
%   - antiRise percentage throughout the travel using antiRise function
%
% FUNCTIONS
%   - lineIntersect.m
%   - antiRise.m
%
% DATUM
%   - Bottom bracket = [0, 0]
%   - +x is torwards front of bike
%   - +y is torwards sky
%
% INPUTS
%         A, B, C, D, E     - Initial coordinates of pivot locations [x, y]
%         E, F              - Initial coordinates of the shock mounts. F is
%                             fixed
%         P                 - Initial coordinate of axle [x, y]
%         bb_drop           - Bottom bracket drop
%         COGy              - y coordinate of the bike-rider center of gravity
%         RC                - Rear center length of bike at 0% travel
%         Fground           - Coordinates of the contact patch of the front tire
%         branchNum         - Value is either 1 or 2 depending on if 4 bar system
%                             is crossed or not. Only one value will lead to a solution
%                             that matches in the input coordinates
%         num_cogs           - Number of cogs to solve antirise values for. See antiRise
%                             function to see cogs
%
% INDEPENDENT VARIABLE
%         theta2            - angle that controls iterative solving
%
%
% OUTPUTS
%         IC                - Matrix with instant center values [mm, mm]
%         aS                - Matrix with antisquat values [%]
%         pD                - Matrix with pedal kickback values [deg]
%         aR                - Matrix with anti rise values [%]
%         travel            - Matrix with vertical travel values aligning with
%                             positions at which IC, aS, aR, pD have been
%                             solved [mm]
%         spring_travel     - Matrix with travel (displacement) values of spring
%                             alingning with positions at which IC, aS, aR, pD
%                             have been solved [mm]
%         motion_ratio      - Matrix with motion ratio aligning with positions
%                             at which travel is calculated
%         Animation of linkage movement
%
%****************************************************************************%
% TO DO, CALCULATE RGROUND THROUGHOUT THE TRAVEL

function [aS, pD, aR, IC, travel, spring_travel, motion_ratio] = fourBar(A, B, C, D, E, F, angle_range, step, animate, test)
close

% Define bike geometry
bb_drop = 32; % bottom bracket drop
RC = 445; % rear center
COGy = 805.8; % y coordinate of bike-rider center of gravity
Rground = [-RC, bb_drop-374.5]; % contact patch of rear tire. set aR constant for now but should account for movement through travel
Fground = [816.9, bb_drop-374.5]; % coordinates of front tire. leave aR constant
P = [-RC, bb_drop]; % rear axle coordinates

% define number of cogs to solve antisquat for
num_cogs = 4;

% calculate r1 and theta1
if D(1) > A(1)
  theta1 = atand((D(2)-A(2))/(D(1)-A(1))); % theta based on D coordinates NEED TO CHECK BY HAND %%%
else
  theta1 = 180+atand((D(2)-A(2))/(D(1)-A(1))); % theta based on D coordinates NEED TO CHECK BY HAND %%%
endif
r1 = sqrt((D(2)-A(2))^2+(D(1)-A(1))^2);
r2 = sqrt((B(2)-A(2))^2+(B(1)-A(1))^2);
r4 = sqrt((C(2)-D(2))^2+(C(1)-D(1))^2);
r3 = sqrt((C(2)-B(2))^2+(C(1)-B(1))^2);
rP = sqrt((P(2)-B(2))^2+(P(1)-B(1))^2); %length of B to P
rP2 = sqrt((P(2)-C(2))^2+(P(1)-C(1))^2); % length of C to P
beta = acosd((rP^2+r3^2-rP2^2)/(2*rP*r3)); % law of cosines
rE = sqrt((E(2)-D(2))^2+(E(1)-D(1))^2); % length of D to E
rE2 = sqrt((E(2)-C(2))^2+(E(1)-C(1))^2); % length of C to E
gamma = acosd((r4^2+rE^2-rE2^2)/(2*r4*rE)); % law of cosines
shock_eye2eye = norm(E-F); % length if E to F

branchNum = 1; %either 1 or 2 represents the two possible solutions;
% need to figure out later if this needs a conditional statement inside of the iteration loop

% independent variable
theta2i = 180+atand((B(2)-A(2))/(B(1)-A(1))); %NEEDS TO ALIGN WITH AB POSITION!!!! NEED TO CHECK BY HAND %%%

% let
R1 = r3;
R2 = -r4;

% generate plot
if animate == true
  figure; hold; grid;
  xlim([-500, 200])
  ylim([0, 500])
endif

% set up loop
iter = 0;
angles = [theta2i:step:theta2i+angle_range]; % angles to calculate

% pre define matrix lengths
aS = zeros(length(angles),num_cogs); % set up column matrix to save anti squat values into
aR = zeros(length(angles),1); % set up column matrix to save anti rise values into
IC = zeros(length(angles),2); % set up column matrix to save instant center values into
travel = zeros(length(angles),1); % set up column matrix to save travel values into
spring_travel = zeros(length(angles),1); % set up column matrix to save travel values into

for theta2 = angles
  iter = iter + 1;
  x3 = r1*cosd(theta1)-r2*cosd(theta2);
  y3 = r1*sind(theta1)-r2*sind(theta2);

  if branchNum == 1
    phi2 = atan2d(y3,x3)+acosd((x3^2+y3^2+R2^2-R1^2)/(2*R2*sqrt(x3^2+y3^2)));
  elseif branchNum == 2
    phi2 = atan2d(y3,x3)-acosd((x3^2+y3^2+R2^2-R1^2)/(2*R2*sqrt(x3^2+y3^2)));
  else
    print("Branch number must be 1 or 2")
  endif
  if isreal(phi2) == false
    disp("Error, potential linkage binding")
    break
  endif
  phi1 = atan2d((y3-R2*sind(phi2))/R1,(x3-R2*cosd(phi2))/R1);

  theta3 = phi1;
  theta4 = phi2;

  %find vectors rAB
  rAB = zeros([1,2]);
  rAB(1) = r2*cosd(theta2);
  rAB(2) = r2*sind(theta2);

  %find coordinate B
  B = rAB+A;

  % find vector rBP
  rBP = zeros([1,2]);
  rBP(1) = rP*cosd(beta+theta3); % theta3 is due to geometry, might need to change for bike application
  rBP(2) = rP*sind(beta+theta3);

  % find coordinate P (axle)
  P = rBP+B;
  % find coordinate of contact patch of rear tire
  Rground = [P(1), P(2)-374.5];

  % find vectors rDC
  rDC = zeros([1,2]);
  rDC(1) = r4*cosd(theta4);
  rDC(2) = r4*sind(theta4);

  % find coordinates C
  C = rDC+D;


  % for first iteration, print B and C coordinates to check if branchNum is set correctly
  if iter == 1 && test == true
    fprintf('B = [%4.2f, %4.2f]\nC = [%4.2f, %4.2f]\nIf these are not the original input coordinates then change branchNum and try again\n', B(1), B(2), C(1), C(2))
  end


  % find vector rDE
  rDE = zeros([1,2]);
  rDE(1) = rE*cosd(theta4-gamma); % theta4-gamma is due to geometry, might need to chnange for bike application
  rDE(2) = rE*sind(theta4-gamma);

  % find coordinate P (rocker shock mount)
  E = rDE+D;

  % calculate instant center coordinates
  [ICx, ICy] = lineIntersect(A, B, D, C);
  ICi = [ICx, ICy]; % coordinates of instant center

  % calculate antisquat
  % for starting position, calculate initial values for kickback calculation
  if iter == 1
    first_call = true;
    initial_values = 0; % no initial values yet
  else
    first_call = false;
  endif
  [aSi, pDi, initial_values] = antiSquat(ICi, Rground, COGy, Fground, P, num_cogs, first_call, initial_values);

  % calculate antirise
  aRi = antiRise(ICi, Rground, COGy, Fground);

  % calculate travel at this iteration
  travel_i = P(2)-bb_drop; % travel in y axis

  % calculate spring travel at this iteration
  spring_travel_i = shock_eye2eye-norm(E-F);

  %****************************************************************************%
  % SAVE VALUES
  aS(iter,1:num_cogs) = aSi;
  pD(iter,1:num_cogs) = pDi;
  aR(iter,1) = aRi;
  IC(iter,1:2) = ICi;
  travel(iter,1) = travel_i;
  spring_travel(iter,1) = spring_travel_i;
  %****************************************************************************%
  % PLOT
  if animate == true
    Linkage = [A;B;C;D]; % combine positions into matrix
    fig1 = plot(Linkage(:,1),Linkage(:,2),"m",'LineWidth', 5);

    Chainstay = [B;P;C]; % combine positions into matrix
    fig2 = plot(Chainstay(:,1),Chainstay(:,2),"r", 'LineWidth', 5);

    Rocker = [C;E;D]; % combine positions into matrix
    fig3 = plot(Rocker(:,1),Rocker(:,2),"b", 'LineWidth', 5);

    Shock = [E;F]; % combine positions into matrix
    fig4 = plot(Shock(:,1),Shock(:,2),"g", 'LineWidth', 5);
    pause(0.1) % pause for 1/4 second
  endif

  %****************************************************************************%
  % STOP SOLVER IF REAR TRAVEL STARTS TO DECREASE
  if iter>1 && travel_i < travel(iter-1,1)
    break
  endif
  % Stop solver if travel reaches 170mm
  if iter>1 && travel_i > 170
    break
  endif

  % logic to not delete graph on the last iteration
  if animate == true
    if iter < length(angles)
      delete(fig1)
      delete(fig2)
      delete(fig3)
      delete(fig4)
    endif
  endif
%****************************************************************************%
end

% Truncate saved vectors if necessary if solver didn't iterate through all angles
aS = aS(1:iter,1:num_cogs);
pD = 180/pi*pD(1:iter,1:num_cogs);
aR = aR(1:iter,1);
IC = IC(1:iter,1:2);
travel = travel(1:iter,1);
spring_travel = spring_travel(1:iter,1);

% Calculate motion ratio (inverse of leverage ratio)
motion_ratio = zeros(length(spring_travel), 1); % initialize column vector
% setup numerical differentiation
for j =1:length(motion_ratio)
  if j==1 % for first point, use forward difference differentiation
    motion_ratio(j,1) = (spring_travel(j+1,1) - spring_travel(j,1))/(travel(j+1,1)-travel(j,1));
  else
    motion_ratio(j,1) = (spring_travel(j,1)-spring_travel(j-1,1))/(travel(j,1)-travel(j-1,1));
  endif
end
%{
calculate leverage ratio. not currently an output of the function
leverage_ratio = 1./motion_ratio
%}
end
