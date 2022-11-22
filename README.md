# One player FPGA Pong game

## Introduction
In this project, I've coded in Verilog a one-player FPGA pong game on a max 10 10m08 evaluation kit using Quartus prime as ide.
the board is connected to a display with jumper wires connected to a vga addapter. the infromation is past to the display threw VGA protocol.

In the game, there's a pedal controlled with two buttons. The goal is to keep the ball onthe screen and not let it pass the paddle line.
If the player fails, the game restarts after 3 seconds.

There are two versions of the code, representing two approaches - the memory mesh approach, and the coordinate calculation approche. 
Both do the same, but the coordinate approach uses much fewer rescources and is an improved version of the other.

### Setup
the dislay is connected with a VGA cable to jumperwired addapter. using 2 sync control inputs and 3 RGB inputs.
all connected to digital IO pins on the board.
two buttons are coonected to the IO pins as well.

### The way it works
#### Memory mesh approche
A more visual selution but much more memory dimanding. a memory map of size 640x480
#### coordinates calculation approche
