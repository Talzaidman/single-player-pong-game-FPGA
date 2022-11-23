
////////////////////////////////////////////////////////////////////////////////////////////////////////
//FileName: ballgamemap.v
//FileType: Verilog code
//Author : Tal Zaidman
//Created On : 23/08/22
//Last Modified On : 23/10/22
//Description : FPGA Single player pong game 
////////////////////////////////////////////////////////////////////////////////////////////////////////



// module decleration
module ballgame(rb,lb,clk,resetb,vsync,hsync,r,g,b);


input lb,rb;	// buttons input
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
reg [639:0] mem[479:0];
reg [12:0] hcounter = 0;	// hsync and vsync counters
reg [18:0] vcounter = 0;
reg [25:0] refreshmap;		// map update counter
integer i,j,k;
reg[10:0] xscreen, yscreen;
integer z;
integer deltamatandball;

integer matkax = 320;	// paddle and ball coordinates
integer bally = 50;
integer ballx = 370;
integer xdelt = 0;
integer ydelt = -5;


always@(posedge clk) begin	// initialization of the paddle and the ball. changing all relevant cells to 1.
	if(!triger) begin
		for(i=0;i<480;i=i+1) begin
			for(j=0;j<640;j=j+1) begin
				if(i < 19 && j<(matkax+80) && j> (matkax-80)) begin	// A paddle 160x20 pixcels
					mem[i][j] <= 1;		
				end
				else if((i-bally)**2+(j-ballx)**2 <= 25) begin 		// A ball of radius 25 pixcels
					mem[i][j] <= 1;
				end
				else begin
					mem[i][j] <= 0;
				end
				end		
			end
		end
	end
	xscreen <= 0;
	yscreen <= 0;
	triger <= 1;
	end	
end
    
always@(posedge clk) begin	// paddle movement block
	if(triger) begin
		if(lb==1 && rb==0 && (matkax - 80 > 5)) begin
			matkax <= matkax - 1;
			for(k=0;k<19;k=k+1) begin
				mem[k][matkax - 79] <= 1;
				mem[k][matkax + 80] <= 0;
			end
		end
		if(rb==1 && lb==0 && (matkax + 80 < 635)) begin
			matkax <= matkax + 1;
			for(k=0;k<19;k=k+1) begin
				mem[k][matkax - 80] <= 0;
				mem[k][matkax + 81] <= 1;
			end
		end
	end
end


always@(posedge clk) begin	// changing ball position
	if(triger) begin
		if(refreshmap == 40000000) begin
			for(i=0;i<480;i=i+1) 
			begin
				for(j=0;j<640;j=j+1) 
				begin
					if((i-(bally))**2+(j-(ballx))**2 <= 25) 
					begin
						mem[i][j] = 0;
					end
					
					if((i-(bally+ydelt))**2+(j-(ballx+xdelt))**2 <= 25) begin
						mem[i][j] = 1;
					end
				end		
			end
		
			deltamatandball <= (matkax>ballx)?(matkax-ballx):(ballx-matkax);
		
			if((bally+ydelt+ydelt <= 18) && (deltamatandball>80)) begin			// end game loosing check
				bally <= 0;
				ballx <= 0;
				ydelt <= 0;
				xdelt <= 0;
				loseflag <= 1;
			end
		
			//y axis collition
			if((bally+ydelt+ydelt <= 22) && (matkax-ballx<=0) && (matkax-ballx>-80)) begin	// left side hit
				xdelt <= $ceil(5*$cos(1.125*(-matkax+ballx)));
				ydelt <= -$ceil(5*$sin(1.125*(-matkax+ballx)));
			end
		
			if((bally+ydelt+ydelt <= 22) && (matkax-ballx>0) && (matkax-ballx<80)) begin	// right side hit
			xdelt <= -$ceil(5*$cos(1.125*(matkax-ballx)));
			ydelt <= $ceil(5*$sin(1.125*(matkax-ballx)));
			end
		
			if(bally+ydelt+ydelt >= 479 ) begin						// top hit
				ydelt <= -ydelt;
			end
		
			//x axis colission
			if(xdelt>0 && (ballx+xdelt+xdelt >= 639)) begin					// right hit
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
		yscreen <= yscreen + 1;

		if(xscreen == 640) begin
			xscreen <= 0;
		end
		if(yscreen == 420) begin
			yscreen <= 0;
		end

		if(mem[yscreen][xscreen] == 0) begin	// rgb output updated
			r = 0;
			g = 0;
			b = 0;
		end	
		if(mem[yscreen][xscreen] == 1) begin
			r = 1;
			g = 1;
			b = 1;	
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
