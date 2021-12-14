# Prop-Designer

The prop designer is based on BEM theory and classic aerodynamics. The program will design the curvature angles of the airfoils along your prop give that you input / design the inital shape of the prop. 

Typical prop shapes will vary for the type of conditions you are designing for. The prop design in the program as the following cross-section:

   __________________________________            __________________________________
 /                                    \    _   /                                    \
|                                      |  |O| |                                      |
 \                                    /    -   \                                    /
   __________________________________            __________________________________ 

The prop was designed simply by the merging of two geometries: a rectangle with two semi-circles on both ends.

Besides prop shape, the program takes in important variables that may change depending on your own design criteria and conditions.
1. Vinf
2. x (Note: the array does not start at 0 since an asymptote exists their)
3. P_avalible
4. n
5. cd_min
6. cl_min
7. alpha_zero_lift
8. D
9. rho
10. Temp
11. P

Most of these characterisitics will be determined by the plane you are choosing to create a prop for such as engine output, coefficient of lift and drag, zero lift angle. Others are determined by flying conditions such as density, flying speed, and Temp.
 
