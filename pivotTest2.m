% Script to test pivots
%% Pivot locations represents Kingston V1_HorstLink linkage file %%

A = [-.2, 56.3];
B = [-358.4, 14.1];
C = [-96.7, 312.1];
D = [-20.1, 287.1];
E = [56.6, 340.8];
F = [76.6, 120.8];
angle_range = -100;
angle_step = -1;
animate = true;

[aS, pD, aR, IC, travel, spring_travel, motion_ratio] = fourBar(A, B, C, D, E, F, angle_range, angle_step, animate, 0);
