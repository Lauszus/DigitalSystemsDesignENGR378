// ENGR 378 (VGA Lab)
// Date: 12/13/11
// Written by: Michael Chan
// San Francisco State University
// Note: This code is used for the VGA lab for ENGR 378 and is written to support monitor display resolutions of 1280 x 1024 at 60 fps

// (DETAILS OF THE MODULES)
// VGAInterface.v is the top most level module and asserts the red/green/blue signals to draw to the computer screen
// VGAController.v is a submodule within the top module used to generate the vertical and horizontal synch signals as well as X and Y pixel positions
// VGAFrequency.v is a submodule within the top module used to generate a 108Mhz pixel clock frequency from a 50Mhz pixel clock frequency using the PLL

// (USER/CODER Notes)
// Note: User should modify/write code in the VGAInterface.v file and not modify any code written in VGAController.v or VGAFrequency.v

module VGAInterface(

	//////////// CLOCK //////////
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,

	//////////// LED //////////
//	LEDG,
//	LEDR,

	//////////// KEY //////////
	KEY,

	//////////// SW //////////
	SW,

	//////////// SEG7 //////////
//	HEX0,
//	HEX1,
//	HEX2,
//	HEX3,
//	HEX4,
//	HEX5,
	HEX6,
	HEX7,

	//////////// VGA //////////
	VGA_B,
	VGA_BLANK_N,
	VGA_CLK,
	VGA_G,
	VGA_HS,
	VGA_R,
	VGA_SYNC_N,
	VGA_VS 
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input		          		CLOCK_50;
input		          		CLOCK2_50;
input		          		CLOCK3_50;

//////////// LED //////////
//output		     [8:0]		LEDG;
//output		    [17:0]		LEDR;

//////////// KEY //////////
input		     [3:0]		KEY;

//////////// SW //////////
input		    [17:0]		SW;

//////////// SEG7 //////////
//output		     [6:0]		HEX0;
//output		     [6:0]		HEX1;
//output		     [6:0]		HEX2;
//output		     [6:0]		HEX3;
//output		     [6:0]		HEX4;
//output		     [6:0]		HEX5;
output		     [6:0]		HEX6;
output		     [6:0]		HEX7;

//////////// VGA //////////
output		     [7:0]		VGA_B;
output		          		VGA_BLANK_N;
output		          		VGA_CLK;
output		     [7:0]		VGA_G;
output		          		VGA_HS;
output		     [7:0]		VGA_R;
output		          		VGA_SYNC_N;
output		          		VGA_VS;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg	aresetPll = 0; // asynchrous reset for pll
wire 	pixelClock;
wire	[10:0] XPixelPosition;
wire	[10:0] YPixelPosition; 
wire	[7:0] redValue;
wire	[7:0] greenValue;
wire	[7:0] blueValue;

// slow clock counter variables
reg 	[17:0] slowClockCounter = 0;
wire 	slowClock;

// variables for the dot 
//reg	[10:0] XDotPosition = 500;
//reg	[10:0] YDotPosition = 500; 

//=======================================================
//  Structural coding
//=======================================================

// output assignments
assign VGA_BLANK_N = 1'b1;
assign VGA_SYNC_N = 1'b1;			
assign VGA_CLK = pixelClock;

// PLL Module (Phase Locked Loop) used to convert a 50Mhz clock signal to a 108 MHz clock signal for the pixel clock
VGAFrequency VGAFreq (aresetPll, CLOCK_50, pixelClock);

// VGA Controller Module used to generate the vertial and horizontal synch signals for the monitor and the X and Y Pixel position of the monitor display
VGAController VGAControl (pixelClock, redValue, greenValue, blueValue, VGA_R, VGA_G, VGA_B, VGA_VS, VGA_HS, XPixelPosition, YPixelPosition);

// COLOR ASSIGNMENT PROCESS (USER WRITES CODE HERE TO DRAW TO SCREEN)

//eight_colors M1(.LEDR(LEDR[10:0]), .SW1(SW[1]),.XPixelPosition(XPixelPosition), .YPixelPosition(YPixelPosition), .redValue(redValue), .blueValue(blueValue), .greenValue(greenValue), .pixelClock(pixelClock), .slowClock(slowClock));
pong M1( .XPixelPosition(XPixelPosition), .YPixelPosition(YPixelPosition), .redValue(redValue), .blueValue(blueValue), .greenValue(greenValue), .pixelClock(pixelClock), .CLOCK_50(CLOCK_50), .HEX7(HEX7), .HEX6(HEX6), .KEY(KEY), .SW(SW[0]));

endmodule
