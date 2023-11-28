function pass = checkPass(aS, aR, travel, goal)
  %****************************************************************************%
  %function to check if pivot points meet kinematic requirements
  %****************************************************************************%
  %
  % INPUTS:
  %         goal       - struct containing goals
  %         aR         - antiRise values for this iteration
  %         aS         - antiSquat values for this iteration
  %         
  %      
  %
  % OUTPUTS:
  %         pass        - Whether or not conditions meet goals [true or false]
  %
  %****************************************************************************%
  
  %% determine statistics of values
  aR_mean = mean(aR);
  aR_std = std(aR);
  
  %% determine antisquat at sag for 51 tooth
  travel_max = travel(end-1,1); % take max travel [mm]
  sag = .3*travel_max; % find 30% sag [mm]
  % find index closest to sag
  [d, ix] = min(abs(travel-sag));
  aS_sag = aS(ix, 1); % find antisquat at index closest to sag (51)
  
  % verify that sag index is actually close to sag
  sag_actual = travel(ix);
  if sag_actual > sag*1.19 || sag_actual < sag*0.85; % about >35% or <25%
    disp("error: angle step not granular enough for accurate antisquat calculation at sag")
  endif
  
  %% pull goal values out of struct
  TF = strcmp({goal.name}, 'mean_low');
  goal_aR_mean_low = goal(TF).aR;
 
  TF = strcmp({goal.name}, 'mean_high');
  goal_aR_mean_high = goal(TF).aR;
  
  TF = strcmp({goal.name}, 'std');
  goal_aR_std = goal(TF).aR;
  
  TF = strcmp({goal.name}, 'sag');
  sag_bounds = goal(TF).aS;
  goal_aS_sag_high = sag_bounds(2);
  goal_aS_sag_low = sag_bounds(1);
  
  if aR_mean > goal_aR_mean_low && aR_mean < goal_aR_mean_high && aR_std < goal_aR_std...
  && aS_sag > goal_aS_sag_low && aS_sag < goal_aS_sag_high
    disp("Got one")
    pass = true;
  elseif
    pass = false;
  endif
 end