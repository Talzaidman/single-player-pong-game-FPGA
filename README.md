# Single player FPGA Pong game

<img src="https://github.com/Talzaidman/single-player-pong-game-FPGA/blob/b148df2372f2d4553ff93f5a0607e8556a20db44/Photos/all.jpg" width=50% height=50%>

## Contents
- [Introduction](#Introduction)
- [The setup](#The-Setup)
- [Installation](#installation)

## Introduction
In this project, I've coded in Verilog a one-player FPGA pong game on a **max 10 10m08 evaluation kit** using **Quartus prime** as IDE.
The board's connected to a display threw a VGA to jumper-wire adapter, And the information passes to the display threw VGA protocol.

In the game, there's a pedal controlled with two buttons. The goal is to keep the ball on the screen and not let it pass the paddle line.
If the player fails, the game restarts after 3 seconds.

There are two versions of the code, representing two approaches - the memory map approach, and the coordinate calculation approche. 
Both do the same, but the coordinate approach uses much fewer rescources and is an improved version of the other.

[Inside the code file, you can find a thorough explanation of every code block and its purpose.]

## The setup
the disply is connected with a VGA cable to a jumper-wire addapter. using 2 sync control inputs and 3 RGB inputs.
All connected to digital IO pins on the board.
Two buttons are coonected to the IO pins as well.

<img src="https://github.com/Talzaidman/single-player-pong-game-FPGA/blob/b148df2372f2d4553ff93f5a0607e8556a20db44/Photos/closeup.jpg" width=50% height=50%>


## Installation
With the IDE you're using, load the Verilog file and make sure you set the inputs and outputs address with your IDE's Pin-planner. 
The board I used has a 50 Mhz clock frequency. Therefor, the H-sync and V-sync counters are set accordingly. Pay attention that you configure your counters according to your board's clock speed. Else, the display won't be able to read the output data the board is sending. 

Also, You can change the ball and paddle shapes, as well as the screen size:

```python
parameter width = 639; 		 // screen resolution
parameter height = 479;
parameter ballradius = 10;	 // ball size
parameter halfpaddlelength = 80; // paddle length
parameter paddleheight = 19; 	 // paddle height
```
Pay attention that if you change your screen resolution, you need to correct hsync and vsync accordinly.
After taking into account the screen resolution and clock speed, use the table below to correct the hsync and vsync: 

<img src="https://github.com/Talzaidman/Pong/blob/078d2ed1bbc40f8d17dcb29f80c88ef32998d2a8/Photos/Timingtable.png" width=50% height=50%>

If needed, a full time restriction guide can be seen [here](http://javiervalcarce.eu/html/vga-signal-format-timming-specs-en.html).

Now you can flush the code into your fpga board and the game should run.
enjoy!


