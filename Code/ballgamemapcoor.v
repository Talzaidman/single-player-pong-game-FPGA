
////////////////////////////////////////////////////////////////////////////////////////////////////////
//FileName: ballgamecoor.v
//FileType: Verilog code
//Author : Tal Zaidman
//Created On : 23/08/22
//Last Modified On : 30/10/22
//Description : FPGA Single player pong game 
////////////////////////////////////////////////////////////////////////////////////////////////////////



// module declaration
module ballgame(rightbutton,leftbutton,clk,resetb,vsync,hsync,r,g,b);

input leftbutton,rightbutton;	// buttons input
input clk;
input resetb;
output vsync;
output hsync;
output r,g,b;

reg vsync = 0;
reg hsync = 0;
reg loseflag = 0;
reg triger = 0;
reg r = 1;
reg b = 1;
reg g = 1;

reg [12:0] hcounter = 0;	// hsync and vsync counters
reg [25:0] refreshmap;		// ball position update counter
integer i,j,k;
reg[10:0] xscreen, yscreen;
integer z;
integer deltamatandball;

//////////////////////////
parameter width = 639; 		 // screen resolution
parameter height = 479;
parameter ballradius = 10;	 // ball size
parameter halfpaddlelength = 80; // paddle length
parameter paddleheight = 19; 	 // paddle height
//////////////////////////

integer paddlex = 320;	// paddle and ball coordinates
integer bally = 50;
integer ballx = 370;
integer xdelt = 0;
integer ydelt = -5;


always@(posedge clk) begin
	if(!triger) begin
		xscreen <= 0;
		yscreen <= 0;
		triger <= 1;
	end	
end
    
always@(posedge clk) begin	// paddle movement block
	if(triger) begin
		if(leftbutton==1 && rightbutton==0 && (paddlex - halfpaddlelength > 5)) begin
			paddlex <= paddlex - 1;
		end
		if(rightbutton==1 && leftbutton==0 && (paddlex + halfpaddlelength < width - 5)) begin
			paddlex <= paddlex + 1;
		end
	end
end


always@(posedge clk) begin	// changing ball position
	if(triger) begin
		if(refreshmap == 40000000) begin
			deltamatandball <= (paddlex>ballx)?(paddlex-ballx):(ballx-paddlex);
		
			if((bally+ydelt+ydelt <= 18) && (deltamatandball>halfpaddlelength)) begin			// end game loosing check
				bally <= 0;
				ballx <= 0;
				ydelt <= 0;
				xdelt <= 0;
				loseflag <= 1;
			end
		
			//y axis collition
			if((bally+ydelt+ydelt <= 22) && (paddlex-ballx<=0) && (paddlex-ballx>-halfpaddlelength)) begin	// left side paddle hit
				xdelt <= $ceil(5*$cos(1.125*(-paddlex+ballx)));
				ydelt <= -$ceil(5*$sin(1.125*(-paddlex+ballx)));
			end
		
			if((bally+ydelt+ydelt <= 22) && (paddlex-ballx>0) && (paddlex-ballx<80halfpaddlelength)) begin	// right side paddle hit
			xdelt <= -$ceil(5*$cos(1.125*(paddlex-ballx)));
			ydelt <= $ceil(5*$sin(1.125*(paddlex-ballx)));
			end
		
			if(bally+ydelt+ydelt >= height ) begin						// top hit
				ydelt <= -ydelt;
			end
		
			//x axis colission
			if(xdelt>0 && (ballx+xdelt+xdelt >= width)) begin				// right hit
				xdelt <= -xdelt;
			end
			if(xdelt<0 && (ballx+xdelt+xdelt <= 0)) begin					// left hit
				xdelt <= -xdelt;
			end
			
			bally = bally + ydelt;
			ballx = ballx + xdelt; 

			refreshmap <= 0;
		end
		else begin
			refreshmap <= refreshmap + 1;
		end
	end
end


always@(posedge clk or negedge resetb) begin	// horizontal counter for hsync and rgb update - for 50 mhz clock, 794 clock cycles
if(triger) begin
		if(!resetb) begin
			hcounter <= 0;
		end
		else begin
			if(hcounter == 793) begin
				hcounter <= 0;
				hsync <= 0;
			end
			else begin
				if(hcounter == 94) begin
					hsync <= 1;
				end
				hcounter <= hcounter + 1;
			end
		end

		xscreen <= xscreen + 1;

		if(xscreen == width) begin	//display running pixel position horizontal counter
			xscreen <= 0;
			yscreen <= yscreen + 1;
		end
		if(yscreen == height) begin	//display running pixel position vertical counter
			yscreen <= 0;
		end

		//if coordinates inside the ball radius or paddle boundaries, sends white to the disply.
		if((sqrt(((ballx-screenx)^2)+((bally-screeny)^2))<radius) || ((yscreen < paddleheight) && (xscreen < paddlex + halfpaddlelength) && (xscreen < paddlex - halfpaddlelength)) begin	
			r = 1;
			g = 1;
			b = 1;	
		end
		else begin
			r = 0;
			g = 0;
			b = 0;	
		end
	end
end

always@(posedge clk or negedge resetb) begin	// vertical counter for vsync output - for 50 mhz clock, 417075 clock cycles
if(triger) begin
		if(!resetb) begin
			vcounter <= 0;
		end
		else begin
			if(vcounter == 417074) begin
				vcounter <= 0;
				vsync <= 0;
			end
			else begin
				if(vcounter == 1599) begin
					vsync <= 1;
				end
				vcounter <= vcounter + 1;
			end
		end
	end
end

endmodule

