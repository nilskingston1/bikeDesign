# Mountain Bike Suspension Kinematics Design
This directory contains scripts and functions that calculate the movement of a four bar linkage used to aid in the development of a 4 bar suspension design for a mountain bike. Anti-rise, anti-squat, motion ratio, and pedal kickback are common metrics in motorcycle and bicycle design that describe how a suspension bike behaves under acceleration, braking, and suspension compression. I have written functions that solve for these variables through the suspension travel based on a set of pivot locations. I am now working on a pivot optimization script that will iteratively solve for all initial pivot locations in a defined space constraint that satisfy user-defined parameters for anti-rise, anti-squat, motion ratio, and pedal kickback.

A brief description of each of the files is below:
| File                | Description                                                                                                        |
|---------------------|--------------------------------------------------------------------------------------------------------------------|
|fourBar.m            |Calculates the motion (see derivation below) and kinematics of a 4 bar suspension layout. Calls the below functions.| 
|antiRise.m           |Calculates the anti-rise values through suspension travel                                                           |
|antiSquat.m          |Calculates the anti-squat values through suspension travel. Calls circleCircle.m                                    |
|circleCircle.m       |Calculates the tangent coordinates of the chainline at the rear cog and front chainring (see derivation)            |
|lineIntersect.m      |Calculates the intersect of two lines. Used to find instant center coordinates.                                     |
|pivotTest2.m         |Sovles for motion and kinematics for a set of defined pivot locations. Calls fourBar.m                              |
|pivotOptimizationV2.m|Optimization iterative solver. Still a work in progress.                                                            | 
|checkPass.m          |Checks if pivot points in optimization solver meet the user-defined kinematic specifications                        |

Bike geomemetry will affect results. Bottom bracket drop, rear center, front center, wheel size, and the bike-rider center of gravity can all be defined in the fourBar.m file.

![4 Bar Derivation](https://github.com/nilskingston1/bikeDesign/blob/main/4%20Bar%20Derivation.png)
