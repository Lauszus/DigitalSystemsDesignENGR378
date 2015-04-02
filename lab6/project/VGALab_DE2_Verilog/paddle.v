module paddle#(
	parameter 	PaddleHeight = 200,
					yPaddleInit = 600,					
					yTopBar = 100,
					yBottomBar = (1024 - 100)
)
(
	output reg [10:0] y,
	input PaddleClock, 
			SW,
	input [10:0] 	XPixelPosition, 	// Position on x-axis. Increments on pixelClock with some deadzone at start and end.
						YPixelPosition,	// Position on y-axis. Increments when XPixelPosition has reached end of screen+deadzone.
	input KeyUp, KeyDown
);
			
	parameter 	S_Reset = 1'b0,		
					S_Loop = 1'b1;
	
	always@(posedge PaddleClock) begin
		if(SW == 1)
		begin
			y = yPaddleInit;
		end
		else if((KeyDown == 0)&&(y <= (yBottomBar - PaddleHeight)))
			y = y + 1'b1;
		else if((KeyUp == 0)&&(y >= yTopBar))
			y = y - 1'b1;
	end
endmodule