# CSE100/L Lab 1

**Martine Schlag**  
**Winter 2024**

**Pre-lab due:** Thursday January 11 9am PDT in Canvas/GradeScope

**Demo due:** Thursday January 11 (in-person demo by the end of your lab section)

You should have already completed question 3 of the [prelab](prelab1.html) before proceeding with this.

In this lab you will display an octal digit on the rightmost digit of the 7-segment display of the Basys 3 board.  
The octal digit will correspond to the rightmost three switches.  
A pushbutton will provide the value of DP (the decimal point).

1. Read about the 7-Segment Displays in the [Basys3 Board Reference Manual](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual).  
   The FPGA pin names used for the 7-segment display controls in this manual are `CA,CB,CC,CD,CE,CF,CG,DP,AN3,AN2,AN1,AN0`.
   
2. From the prelab you should have equations for the 7-segment controls, `CA,CB,CC,CD,CE,CF,CG`.  
   Figure out what the values should be for `AN3,AN2,AN1,AN0`.

   ![7 Segment Display](7seg-8.gif)

3. Follow these [steps](https://classes.soe.ucsc.edu/cse100/Winter24/lab/new_project/new_project.html) to create a project.  
   **Make sure the project is created in the Desktop.**

4. Follow these [steps](https://classes.soe.ucsc.edu/cse100/Winter24/lab/design/design.html) to enter and implement your design.  
   For this project your inputs should be: `d2,d1,d0, btnD`.  
   The outputs should be: `CA,CB,CC,CD,CE,CF,CG,DP,AN3,AN2,AN1,AN0`.
   
   a. Using the equations you obtained in the pre-lab, add `assign` statements for `CA,CB,CC,CD,CE,CF,CG` to your module.  
      Add: `assign DP = btnD;`  
      and `assign` statements for `AN3,AN2,AN1,AN0`.
   
   b. As described in [steps](https://classes.soe.ucsc.edu/cse100/Winter24/lab/design/design.html), you will need to modify the constraints file **Basys3_Master.xdc** to edit the pin names so that they match the inputs/outputs of your module.

   | Input | btnD | d0    | d1    | d2    |
   | ----- | ---- | ----- | ----- | ----- |
   | PIN   | btnD | sw[0] | sw[1] | sw[2] |

   | Output | CA     | CB     | CC     | CD     | CE     | CF     | CG     | DP | AN0   | AN1   | AN2   | AN3   |
   | ------ | ------ | ------ | ------ | ------ | ------ | ------ | ------ | -- | ----- | ----- | ----- | ----- |
   | PIN    | seg[0] | seg[1] | seg[2] | seg[3] | seg[4] | seg[5] | seg[6] | dp | an[0] | an[1] | an[2] | an[3] |

   c. Implement your design as described in [steps](https://classes.soe.ucsc.edu/cse100/Winter24/lab/design/design.html).  
   There may be an error that you need to fix. Check the console window.  
   When it successfully generates the bitfile, **do not select** "Open Implemented Design".

5. Download the bitfile to the Basys3 board by following the same [steps](https://classes.soe.ucsc.edu/cse100/Winter24/lab/configure configure.html) as in the Prelab (but if you already have Vivado open you can just open the Hardware Manager).  
   The bit file will have the same name as your top level module (*top_module.bit*).

6. Demonstrate your design to the TA.

7. [archive](https://classes.soe.ucsc.edu/cse100/Winter24/lab/archive/archive.html) your project. Files left on the PC are not protected. Should it become necessary to re-image that PC, its disks will be wiped clean.

8. **Important** Please remember to turn off the power of Basys3 board when you are done.
