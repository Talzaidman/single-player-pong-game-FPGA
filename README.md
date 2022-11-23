# One player FPGA Pong game



### Contents
- [Introduction](#Introduction)
- [Setup](#Setup)
- [The way it works](#The-way-it-works)
  - [Memory mesh approche](#Memory-mesh-approche)
  - [Coordinates calculation approche](#Coordinates-calculation-approche)
- [Installation](#installation)
- [Reference documentation](#reference-documentation)

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
A more visual selution but much more memory dimanding. a memory map of size 640x480 is set
#### Coordinates calculation approche
Here, instead of a map the data is stored as coordinates.

### Instaltion 
With the IDE you're using, load the Verilog file and make sure you set the inputs and outputs address with your IDE's Pin-planner. Then, flush it to your FPGA board.
The board I used has a 50 Mhz clock speed. Therefor, the H-sync and V-sync counters are set accordingly. Pay attention that you configure your counters according to your board's clock speed. Else, the display won't be able to read the output data the board is sending. 

The timing has to be set as follows:

![Timing table](https://github.com/Talzaidman/Pong/blob/078d2ed1bbc40f8d17dcb29f80c88ef32998d2a8/Photos/Timingtable.png)
