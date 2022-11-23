# Single player FPGA Pong game

photo

## Contents
- [Introduction](#Introduction)
- [The setup](#The-Setup)
- [Installation](#installation)

## Introduction
In this project, I've coded in Verilog a one-player FPGA pong game on a **max 10 10m08 evaluation kit** using **Quartus prime** as IDE.
the board is connected to a display with jumper wires connected to a vga addapter. the infromation is past to the display threw VGA protocol.

In the game, there's a pedal controlled with two buttons. The goal is to keep the ball on the screen and not let it pass the paddle line.
If the player fails, the game restarts after 3 seconds.

There are two versions of the code, representing two approaches - the memory map approach, and the coordinate calculation approche. 
Both do the same, but the coordinate approach uses much fewer rescources and is an improved version of the other.

[Inside the code file, you can find a thorough explanation of every code block and its purpose.]

## The setup
the disply is connected with a VGA cable to a jumperwire addapter. using 2 sync control inputs and 3 RGB inputs.
all connected to digital IO pins on the board.
two buttons are coonected to the IO pins as well.

photo


## Installation
With the IDE you're using, load the Verilog file and make sure you set the inputs and outputs address with your IDE's Pin-planner. Then, flush it to your FPGA board.
The board I used has a 50 Mhz clock frequency. Therefor, the H-sync and V-sync counters are set accordingly. Pay attention that you configure your counters according to your board's clock speed. Else, the display won't be able to read the output data the board is sending. 

The timing has to be set as follows:

<img src="https://github.com/Talzaidman/Pong/blob/078d2ed1bbc40f8d17dcb29f80c88ef32998d2a8/Photos/Timingtable.png" width=50% height=50%>

If needed, a full time restriction guide can be seen [here](http://javiervalcarce.eu/html/vga-signal-format-timming-specs-en.html).


