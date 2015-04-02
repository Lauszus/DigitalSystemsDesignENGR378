module eight_colors(
	output reg [7:0] redValue, blueValue, greenValue,
	input pixelClock,			// 50Mhz.
			slowClock, 			// pixelClock/2^20 => 48Hz
	input [10:0] 	XPixelPosition, 	// Position on x-axis. Increments on pixelClock with some deadzone at start and end.
						YPixelPosition,	// Position on y-axis. Increments when XPixelPosition has reached end of screen+deadzone.
			
	input		SW1,
	input [10:0] LEDR
	);


	
	always@ (posedge pixelClock) begin
		if(YPixelPosition >= 1024/2)
			begin 	
				redValue <= 8'b00000000; 
				blueValue <= 8'b00000000;
				greenValue <= 8'b00000000;		
			end
		else if(XPixelPosition <= 1280/8)
			begin 	
				redValue <= 8'b00000000; 
				blueValue <= 8'b00000000;
				greenValue <= 8'b00000000;		
			end
		else if(XPixelPosition <= 1280/8*2)
			begin 	
				redValue <= 8'b11111111; 
				blueValue <= 8'b00000000;
				greenValue <= 8'b00000000;		
			end	
		else if(XPixelPosition <= 1280/8*3)
			begin 	
				redValue <= 8'b00000000; 
				blueValue <= 8'b11111111;
				greenValue <= 8'b00000000;		
			end	
		else if(XPixelPosition <= 1280/8*4)
			begin 	
				redValue <= 8'b11111111; 
				blueValue <= 8'b11111111;
				greenValue <= 8'b00000000;		
			end	
		else if(XPixelPosition <= 1280/8*5)
			begin // Green
				redValue <= 8'b00000000; 
				blueValue <= 8'b00000000;
				greenValue <= 8'b11111111;		
			end	
		else if(XPixelPosition <= 1280/8*6)
			begin // Magenta
				redValue <= 8'b11111111; 
				blueValue <= 8'b00000000;
				greenValue <= 8'b11111111;		
			end	
		else if(XPixelPosition <= 1280/8*7)
			begin 	
				redValue <= 8'b00000000; 
				blueValue <= 8'b11111111;
				greenValue <= 8'b11111111;		
			end	
		else if(XPixelPosition <= 1280/8*8)
			begin 	
				redValue <= 8'b11111111; 
				blueValue <= 8'b11111111;
				greenValue <= 8'b11111111;		
			end
		else
			begin
				redValue <= 8'b00000000; 
				blueValue <= 8'b00000000;
				greenValue <= 8'b00000000;	
			end
	end
endmodule