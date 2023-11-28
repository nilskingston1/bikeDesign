%*****************************************************************************%
% INPUTS
%   angle_rage              - angles to solve through (set as negative if link rotates clockwise) [deg]
%   angle_st  ep              - step for angle (set as negative if link rotates clockwise) [deg]
%   position_step           - step for pivot location [mm]
%   min_travel              - min required travel for a design to pass
%   A_start, B_start,...
%   C_start, D_start        - starting pivot locations
%   A_end, B_end,...
%   C_end, D_end            - ending pivot locations
%   goal                    - struct containing all the requirements/goals that the design must pass
%
%
%*****************************************************************************%
%% Define Inputs
angle_range = -100; % set as negative if link rotates clockwise [deg]
angle_step = -1; % set as negative if the link rotates clockwise [deg]
position_step = 16.67; % [mm]
animate = false;
test = false;
min_travel = 160;
E2E = [185, 205, 210, 230]; % eye to eye lengths that fox offers for the DHX2. Used to calculate
% possible pivot locations for F

% intial pivot coordinates (lowest x and y values)
A_start = [-35, 82]; % coordinates of A
B_start = [-346, 21];
C_start = [-133, 292];
D_start = [-49, 280]; % coordinates of D
E_start = [

% define end coordinates (highest x and y values)
A_end = [14, 132];
B_end = [-296, 71];
C_end = [-83, 342];
D_end = [1, 330];
E_end = [

%% Define Goals %%
%** Index of name and values must match up!!!
goal = struct(...
  'name', {'mean_low', 'mean_high', 'std', 'sag'},...
  'aR', {35, 65, 10, 0},...
  'aS', {0, 0, 0, [100,150]})


%*****************************************************************************%
% intialize values for loops
A = A_start;
B = B_start;
C = C_start;
D = D_start;
E = E_start;
Axi = A(1); Ayi = A(2); Bxi = B(1); Byi = B(2); Cxi = C(1); Cyi = C(2); Dxi = D(1); Dyi = D(2);
Exi = E(1); Eyi = E(2);
j = 0;
z = 0;
k = 0;

for Axi = A_start(1):position_step:A_end(1)
  A = [Axi, Ayi]; % increase x coordiate by step amount
  %[aS, aR, IC, travel] = fourBar(A, B, C, D, angle_range, angle_step, animate);
  [aS, pD, aR, IC, travel, spring_travel, motion_ratio] = fourBar(A, B, C, D, E, F, angle_range, step, animate, test)
  % pivot locations allow at least 160mm, check kinematic characteristics
  if travel(end) > min_travel
    pass = checkPass(aS, aR, travel, goal);
    if pass == true
      % iterate through E and F locations and check which meet motion_ratio condidtions. Save those values
      for Exi = E_start(1):position_step:E_end(1)
        for Eyi = E_start(1):position_step:E_end(2)
          E = [Exi, Eyi];
          F =



        endfor
        [aS, pD, aR, IC, travel, spring_travel, motion_ratio] = fourBar(A, B, C, D, E, F, angle_range, step, animate, test)


      endfor
      j = j + 1;
      % save anti squat values that met conditions
      aS_good.fiftyone(1:length(aS),j) = aS(:,1);
      aS_good.fortyfive(1:length(aS),j) = aS(:,2);
      aS_good.thirtythree(1:length(aS),j) = aS(:,3);
      aS_good.ten(1:length(aS),j) = aS(:,4);
      aR_good(1:length(aR),j) = aR; % save anti rise values that met conditions
      travel_good(1:length(travel),j) = travel;
      pivot_good.x(1:4,j) = [A(1); B(1); C(1); D(1)];
      pivot_good.y(1:4,j) = [A(2); B(2); C(2); D(2)];
    endif
  endif

  for Ayi = A_start(2):position_step:A_end(2)
    A = [Axi, Ayi];
    [aS, aR, IC, travel] = fourBar(A, B, C, D, angle_range, angle_step, animate);
    % pivot locations allow at least 160mm, check kinematic characteristics
    if travel(end) > min_travel
      pass = checkPass(aS, aR, travel, goal);
      if pass == true
        j = j + 1;
        % save anti squat values that met conditions
        aS_good.fiftyone(1:length(aS),j) = aS(:,1);
        aS_good.fortyfive(1:length(aS),j) = aS(:,2);
        aS_good.thirtythree(1:length(aS),j) = aS(:,3);
        aS_good.ten(1:length(aS),j) = aS(:,4);
        aR_good(1:length(aR),j) = aR; % save anti rise values that met conditions
        travel_good(1:length(travel),j) = travel;
        pivot_good.x(1:4,j) = [A(1); B(1); C(1); D(1)];
        pivot_good.y(1:4,j) = [A(2); B(2); C(2); D(2)];
      endif
    endif

    for Bxi = B_start(1):position_step:B_end(1)
      B = [Bxi, Byi];
      [aS, aR, IC, travel] = fourBar(A, B, C, D, angle_range, angle_step, animate);
      % pivot locations allow at least 160mm, check kinematic characteristics
      if travel(end) > min_travel
        pass = checkPass(aS, aR, travel, goal);
        if pass == true
         j = j + 1;
         % save anti squat values that met conditions
         aS_good.fiftyone(1:length(aS),j) = aS(:,1);
         aS_good.fortyfive(1:length(aS),j) = aS(:,2);
         aS_good.thirtythree(1:length(aS),j) = aS(:,3);
         aS_good.ten(1:length(aS),j) = aS(:,4);
         aR_good(1:length(aR),j) = aR; % save anti rise values that met conditions
         travel_good(1:length(travel),j) = travel;
         pivot_good.x(1:4,j) = [A(1); B(1); C(1); D(1)];
         pivot_good.y(1:4,j) = [A(2); B(2); C(2); D(2)];
        endif
      endif

      for Byi = B_start(2):position_step:B_end(2)
        B = [Bxi, Byi];
        [aS, aR, IC, travel] = fourBar(A, B, C, D, angle_range, angle_step, animate);
        % pivot locations allow at least 160mm, check kinematic characteristics
        if travel(end) > min_travel
          pass = checkPass(aS, aR, travel, goal);
            if pass == true
            j = j + 1;
            % save anti squat values that met conditions
            aS_good.fiftyone(1:length(aS),j) = aS(:,1);
            aS_good.fortyfive(1:length(aS),j) = aS(:,2);
            aS_good.thirtythree(1:length(aS),j) = aS(:,3);
            aS_good.ten(1:length(aS),j) = aS(:,4);
            aR_good(1:length(aR),j) = aR; % save anti rise values that met conditions
            travel_good(1:length(travel),j) = travel;
            pivot_good.x(1:4,j) = [A(1); B(1); C(1); D(1)];
            pivot_good.y(1:4,j) = [A(2); B(2); C(2); D(2)];
          endif
        endif

        for Cxi = C_start(1):position_step:C_end(1)
          C = [Cxi, Cyi];
          [aS, aR, IC, travel] = fourBar(A, B, C, D, angle_range, angle_step, animate);
          % pivot locations allow at least 160mm, check kinematic characteristics
          if travel(end) > min_travel
           pass = checkPass(aS, aR, travel, goal);
            if pass == true
              j = j + 1;
              % save anti squat values that met conditions
              aS_good.fiftyone(1:length(aS),j) = aS(:,1);
              aS_good.fortyfive(1:length(aS),j) = aS(:,2);
              aS_good.thirtythree(1:length(aS),j) = aS(:,3);
              aS_good.ten(1:length(aS),j) = aS(:,4);
              aR_good(1:length(aR),j) = aR; % save anti rise values that met conditions
              travel_good(1:length(travel),j) = travel;
              pivot_good.x(1:4,j) = [A(1); B(1); C(1); D(1)];
              pivot_good.y(1:4,j) = [A(2); B(2); C(2); D(2)];
            endif
          endif

          for Cyi = C_start(2):position_step:C_end(2)
            C = [Cxi, Cyi];
            [aS, aR, IC, travel] = fourBar(A, B, C, D, angle_range, angle_step, animate);
            % pivot locations allow at least 160mm, check kinematic characteristics
            if travel(end) > min_travel
              pass = checkPass(aS, aR, travel, goal);
              if pass == true
               j = j + 1;
               % save anti squat values that met conditions
               aS_good.fiftyone(1:length(aS),j) = aS(:,1);
               aS_good.fortyfive(1:length(aS),j) = aS(:,2);
               aS_good.thirtythree(1:length(aS),j) = aS(:,3);
               aS_good.ten(1:length(aS),j) = aS(:,4);
               aR_good(1:length(aR),j) = aR; % save anti rise values that met conditions
               travel_good(1:length(travel),j) = travel;
               pivot_good.x(1:4,j) = [A(1); B(1); C(1); D(1)];
               pivot_good.y(1:4,j) = [A(2); B(2); C(2); D(2)];
               endif
            endif

            for Dxi = D_start(1):position_step:D_end(1)
              D = [Dxi, Dyi];
              [aS, aR, IC, travel] = fourBar(A, B, C, D, angle_range, angle_step, animate);
              % pivot locations allow at leaRt 160mm, check kinematic characteristics
              if travel(end) > min_travel
                pass = checkPass(aS, aR, travel, goal);
               if pass == true
                 j = j + 1;
                 % save anti squat values that met conditions
                 aS_good.fiftyone(1:length(aS),j) = aS(:,1);
                 aS_good.fortyfive(1:length(aS),j) = aS(:,2);
                 aS_good.thirtythree(1:length(aS),j) = aS(:,3);
                 aS_good.ten(1:length(aS),j) = aS(:,4);
                 aR_good(1:length(aR),j) = aR; % save anti rise values that met conditions
                 travel_good(1:length(travel),j) = travel;
                 pivot_good.x(1:4,j) = [A(1); B(1); C(1); D(1)];
                 pivot_good.y(1:4,j) = [A(2); B(2); C(2); D(2)];
                 endif
              endif

              for Dyi = D_start(2):position_step:D_end(2)
                D = [Dxi, Dyi];
                [aS, aR, IC, travel] = fourBar(A, B, C, D, angle_range, angle_step, animate);
                % pivot locations allow at least 160mm, check kinematic characteristics
                if travel(end) > min_travel
                  pass = checkPass(aS, aR, travel, goal);
                  if pass == true
                   j = j + 1;
                   % save anti squat values that met conditions
                   aS_good.fiftyone(1:length(aS),j) = aS(:,1);
                   aS_good.fortyfive(1:length(aS),j) = aS(:,2);
                   aS_good.thirtythree(1:length(aS),j) = aS(:,3);
                   aS_good.ten(1:length(aS),j) = aS(:,4);
                   aR_good(1:length(aR),j) = aR; % save anti rise values that met conditions
                   travel_good(1:length(travel),j) = travel;
                   pivot_good.x(1:4,j) = [A(1); B(1); C(1); D(1)];
                   pivot_good.y(1:4,j) = [A(2); B(2); C(2); D(2)];
                  endif
                endif

              endfor
            endfor
          endfor
        endfor
      endfor
    endfor
  endfor
endfor
sol_size = size(travel_good); % solution matrix size
fprintf('Done\n%i solutions found\n', sol_size(2))
