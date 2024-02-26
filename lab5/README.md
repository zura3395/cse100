CSE100/L Lab 5  
Competition Stop It
Martine Schlag  
Winter 24  
--------------------------------------------------------

**Demo due:** Tuesday February 20 end of your section.

In this lab you will again implement a state machine as part of a sequential circuit for the competition version of the _Stop It_ game.

Remember that your design must be synchronous with **the clock** signal specified in this lab. This means that you must

*   use only [positive edge-triggered flip-flops](https://classes.soe.ucsc.edu/cse100/Winter24/lab/FDRE/FDRE.html),
*   not use asynchronous clears or pre-sets of any sequential elements,
*   connect only **the system clock** provided to you to the clock input pins of any sequential components,
*   not connect **the system clock** to any input pins other than the clock input pins of sequential components, and
*   and only use the **assign** statement in your design.

### Overview

In Lab 4 you implemented the single player training version of _Stop It_. In Lab 5 you will implement the two player version of this game. In the two player version, a point is scored by a player if they are first to press their button when the counter matches the target button, but they lose a point if the counter did not match. The counter stops as soon as either player presses their button. If both players press their buttons simultaneously (same clock edge) then either they both score or lose a point. Each player starts with 3 points. The game is over when either player reaches 6 points or 0 points.

1.  A Go signal is given (pushbutton btnC is pressed) to start the next round.
2.  In each round, a random 5-bit binary value, the target number, is selected and displayed on the two leftmost digits while the 5-bit game counter (still displayed on the rightmost digits) is held at 1F.
3.  After 2 seconds the game counter begins to decrement every quarter second.
4.  The game counter will keep decrementing, rolling under to 1F(31 decimal), after 0.
5.  When either or both players press their button (pushbuttons btnL and btnR) the game counter stops decrementing.
6.  When the buttons are pressed the leds are adjusted as follow:  
        a.  If the target number matches the counter, then the player who pressed first (or both players if they pressed simultaneously), score a point. This is indicated by turning on an additional led for that player (or both players).  
        b.  If the target number does not match the counter, then the player who pressed first (or both players if they pressed simultaneously), lose a point. This is indicated by turning off an led for that player (or both players).
7.  If the target was matched when the counter was stopped then all four digits flash in unison for four seconds. Otherwise the target digits and counter digits alternate as they flash.
8.  The flashing continues for four seconds and what happens next depends on whether the game is over. The game is over if either player has 6 leds on or no leds on.
9.  When the game is not over, the leftmost digits are again blank and a new round can begin with a Go signal.
10.  When the game is over, the leds of the winning player(s) flash. A player will win if they have 6 leds or they have at least one led and the other player has none. If both players have no leds on, then they both lost and this is indicated by flashing the DP segments of all four digits.
11.  To make the target easier to match, turning on sw[14] slows the game counter so that it decrements every half second instead of quarter second.
12.  To test the cases where both players press simultaneously, turning on sw[15] will make pressing btnL the same as pressing both btnL and btnR.

https://github.com/zura3395/cse100/assets/68401942/6ce138b7-5f24-45ca-97c3-34ffc61e70d5

(Note that sw[14], not sw[15] as mentioned in the video, slows the game counter.)

On the Basys 3 board,

*   PushButton btnC will be used as the "Go" signal.
*   PushButton btnU will be used as global reset and should only be connected to the module **qsec_clks** described below.
*   PushButtons btnL and btnR will be the buttons used by Player L and Player R.
*   Player R's leds will be led[5:0] with led[2:0] on at the start.
*   Player L's leds will be led[15:10] with led[15:13] on at the start.
*   You will be given a clock and a signal **qsec** which is **high for one clock cycle** roughly every 1/4 of a second. The signal **qsec** should **NOT** be used as a clock. It can be connected to clock enable inputs possibly with other logic to control the rate at which a counter advances.

No overview this time. You probably should make your own. Here's some **Gratuitous Advice:**

1.  This is an extension of Lab 4, so you probably want to start by making a copy of your Lab 4 project in Vivado (use the copy option under the Project menu in Vivado). You will need to modify the state machine and create a new LED processor.
2.  You can make a 6 bit shifter that initializes with 3 1's and use two instances of it, one for each player. (You will need to _manually_ reverse the output of one of them.)
3.  Your state machine does not need to remember the score nor which player pressed first nor won the game. But it does need an input that tells it when the game is over based on the leds.
4.  Getting a state machine right usually requires several iterations. It is likely that in demonstrating your design the TA will discover some case that is not properly handled. Often changes to the state machine are not simple. A complete redesign may be necessary. Trying to patch it by changing one signal here or there, or inserting a gate/FF, or more, almost always makes things worse. Please leave yourself enough time. Hurrying will introduce more bugs that you will need to hunt down and squash. It is strongly suggested that your entire design be entered and simulating **before** your second section.

### Instructions

1.  Read all of the instructions below before beginning any design.
    
2.  Draw a state diagram for your state machine, obtain the next state and output logic equations. You'll want to use one-hot encoding.
    
3.  Enter the logic for your next state and output equations using the **assign** statement and provide flip-flops to hold the present state.  
    Remember that the global reset will reset all flip-flops. Make sure this will put your state machine into its desired initial state.  
    **For Lab 5, btnU will be connected to the global reset input.**
    
4.  Download [this verilog file](qsec_clks.v) and save it as **qsec\_clks.v**
    
5.  In the Vivado Project Manager, add it to your project. Make sure you select the option to copy it into your project.
    
6.  Add an instance of the module **qsec\_clks** to your top level as follows:  
    
    ```verilog
    qsec_clks slowit (.clkin(clkin), .greset(btnU), .clk(clk), .digsel(digsel), .qsec(qsec));
    ```
    
    The signal **clk** is your system clock. The signal **digsel** should be used to advance the Ring Counter for the 7-segment displays; it should not be used as a clock!!!  
    The signal **qsec** is high for one clock cycle each 1/4 second (4 times per second) and should be used to advance a time Counter; **it should not be used as a clock!!!**
    
7.  Simulate your entire design.  
    You will need to implement a clock in your testbench. The signals **qsec** and **digsel** will be high every 16th cycle of **clk** during simulation. They are much faster during simulation than when implemented so that less time must elapse during simulation.  
    You should simulate until the signals from your timer go high to make sure your State Machine and timer are working properly together.
    
8.  Implement your design, configure the FPGA and demonstrate your design to the TA.
    
9.  Once your working design has been demonstrated, follow [these directions](https://classes.soe.ucsc.edu/cse100/Winter24/lab/submit.html) to submit your project.  
    The zipped project file must be submitted no later than **February 26**.
    
10.  Remember to [archive](https://classes.soe.ucsc.edu/cse100/Winter24/lab/archive/archive.html) your project. Files left on the PC are not protected.
    
11.  **Important** Please remember to turn off the power to Basys 3 board when you are done.

**Don't forget to submit the zipped project file** following [these directions](https://classes.soe.ucsc.edu/cse100/Winter24/lab/submit.html).
