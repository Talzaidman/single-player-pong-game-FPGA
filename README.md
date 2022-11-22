# One player FPGA Pong game

In this project, I've coded in Verilog a one-player FPGA pong game on a max 10 10m08 evaluation kit using Quartus prime as ide.

In the game, there's a pedal controlled with two buttons. The goal is to keep the ball onthe screen and not let it pass the paddle line.
If the player fails, the game restarts after 3 seconds.

There are two versions of the code, representing two approaches - the memory mesh approach, and the coordinate calculations approche. 
Both do the same, but the coordinate approach uses much fewer rescources and is an improved version of the other.
