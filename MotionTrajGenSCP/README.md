Motion Trajectory Generation for Robotic Manipulators via Sequential Convex Optimization

![alt tag](http://i.imgur.com/OHOQsEr.png)

Abstract: 

To interact in a dynamic environment alongside humans, it is essential that robots not just 
be able to move as commanded, but also constrain their motions with respect to other entities;
to react. An example of such a situation is obstacle avoidance: given a target manipulator 
position and a sensed obstacle, find a new path for the end effector which reaches the desired 
target while avoiding the obstacle. Specifying the robot dynamics and kinematics in the 3D 
workspace leads to functions involving trigonometric polynomials, causing non-convex constraints. 
In this work we explore an iterative convex approximation method and analyze the computational 
resources required. An example application is presented on a 4 degree of freedom robotic arm of 
a commercial robot.

Overview: 

This work was completed as a research project in graduate course ECE1505 - Convex Optimization
at the University of Toronto. I drew inspiration from working as a robotics engineer and 
brainstorming ways to link optimization strategies to motion planning for nonconvex motion
constraints. The methodology is inspired by Professor Stephen Boyd's lecture on Sequential Convex
Programming from the EE364B course at Stanford: 
http://stanford.edu/class/ee364b/lectures/seq_slides.pdf
The full project thesis is available in the repository in pdf format. 

Software Instructions: 

The file 'robot_model.m' needs to be modified in accordance with your local installation of
RVCtools - the Robotics Toolbox for MATLAB. Download from here: 
http://www.petercorke.com/Robotics_Toolbox.html

Change the following 2 path-dependent lines: 

    cd ../../Robotics/rvctools/     % path-dependent   
    startup_rvc
    cd ../../CVX/MotionTrajGenSCP/  % path-dependent

To appropriately reflect where you have unpacked rvctools with respect to this package, 
MotionTrajGenSCP. 

From there, the full model can be run in one command:

    TestFullModelECOS

This is the main program that uses the ECOS software to iteratively solve the convex
approximation programs of the motion planning problem. After completion, run the following
command to see the trajectory plotted:

    NaoRH.plot(theta_new_matrix')

For any questions or issues with the project or software, feel free to contact me at:
iiJDSii@gmail.com