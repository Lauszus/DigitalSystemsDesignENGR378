module pong(
	output reg [7:0] redValue, blueValue, greenValue,
	output [6:0] HEX6, HEX7,
	input pixelClock,	// VGA frequency
			CLOCK_50,	// 50Mhz
			SW,
	input [10:0] 	XPixelPosition, 	
						YPixelPosition,	
	input [3:0] KEY
);
	parameter 	PaddleHeight = 11'd150,
					PaddleWidth = 11'd10,
					BallRadius = 11'd10,
					yTopBar = 11'd100,
					yBottomBar = (11'd1024 - 11'd100),
					xRightBar = (11'd1280-11'd100),
					xLeftBar = 11'd100,
					xPLOffset = 11'd150,
					xPROffset = (11'd1280 - 11'd150 + PaddleWidth),
					yPaddleInit = (11'd1024/11'd2 - PaddleHeight/11'd2),
					xBallInit = 11'd1280/11'd2,
					yBallInit = 11'd1025/11'd2;
					
	wire [10:0] yPL, yPR;
	wire [10:0] yBall, xBall;
	wire gameOver, hitDetectLeft, hitDetectRight, BallClock, PaddleClock, gameOverOrReset;
	reg [16:0] PaddleCounter;
	reg [16:0] BallCounter;
	
	// generates a slow clock by selecting the MSB from a large counter
	assign PaddleClock = PaddleCounter[16];
	assign BallClock = BallCounter[16];

	always@ (posedge CLOCK_50) 
	begin
		BallCounter <= BallCounter + 1;
		PaddleCounter <= PaddleCounter + 1;
	end

	assign gameOverOrReset = SW == 1 ? 1'b1 : gameOver == 1 ? 1'b1 : 1'b0; // If gameover then lock paddles and ball movement. This is input to all modules instead of SW.
	
	// Controls paddle movement. 
	paddle 	#(.yBottomBar(yBottomBar), .yTopBar(yTopBar), .PaddleHeight(PaddleHeight), .yPaddleInit(yPaddleInit)) 
				M1(.YPixelPosition(YPixelPosition), .XPixelPosition(XPixelPosition), .PaddleClock(PaddleClock),	.SW(gameOverOrReset), .y(yPL), .KeyUp(KEY[0]), .KeyDown(KEY[1]));
	paddle 	#(.yBottomBar(yBottomBar), .yTopBar(yTopBar), .PaddleHeight(PaddleHeight), .yPaddleInit(yPaddleInit)) 
				M2(.YPixelPosition(YPixelPosition), .XPixelPosition(XPixelPosition), .PaddleClock(PaddleClock),	.SW(gameOverOrReset), .y(yPR), .KeyUp(KEY[2]), .KeyDown(KEY[3]));
				
	// Outputs gameOver when a player has a score of 9. 
	gamescore M3(.hitDetectLeft(hitDetectLeft), .hitDetectRight(hitDetectRight), .SW(SW), .gameOver(gameOver), .HEX6(HEX6), .HEX7(HEX7));

	// Controls ball movement
	ball 		#(.PaddleHeight(PaddleHeight), .PaddleWidth(PaddleWidth), .BallRadius(BallRadius), .yTopBar(yTopBar), .yBottomBar(yBottomBar), .xRightBar(xRightBar),
					.xLeftBar(xLeftBar), .xPLOffset(xPLOffset), .xPROffset(xPROffset), .xBallInit(xBallInit), .yBallInit(yBallInit))
				M4(.xBall(xBall), .yBall(yBall), .BallClock(BallClock), .SW(gameOverOrReset), .yPL(yPL), .yPR(yPR), .hitDetectRight(hitDetectRight),  .hitDetectLeft(hitDetectLeft));	
	
	always @(*) begin
		// Outputs to screen.
		if(XPixelPosition <= xLeftBar || XPixelPosition >= xRightBar)
		begin // Side bars.
			redValue <= 8'b00000000; 
			blueValue <= 8'b00000000;
			greenValue <= 8'b11111111;
		end
		else if((XPixelPosition > xLeftBar && XPixelPosition < xRightBar) && (YPixelPosition <= yTopBar || YPixelPosition >= yBottomBar))
		begin // Top and Bottom Bar
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b00000000;	
		end 
		else if((YPixelPosition >= yPL && YPixelPosition <= (yPL + PaddleHeight)) && (XPixelPosition >= (xPLOffset - PaddleWidth) && (XPixelPosition <= xPLOffset)))
		begin // Left Paddle
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if((YPixelPosition >= yPR && YPixelPosition <= (yPR + PaddleHeight)) && (XPixelPosition >= (xPROffset - PaddleWidth) && (XPixelPosition <= xPROffset)))
		begin // Right Paddle
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		
		// Start Ball Plot. All the if statements are there to make the ball round(ish) shaped.
		else if(((yBall - 11*BallRadius/10) <= YPixelPosition && YPixelPosition <= (yBall - BallRadius)) && ((xBall - BallRadius/5) <= XPixelPosition   && XPixelPosition <= xBall + 1*BallRadius/5))
		begin 
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall - BallRadius) <= YPixelPosition && YPixelPosition <= (yBall - 4*BallRadius/5)) && ((xBall - 6*BallRadius/10) <= XPixelPosition   && XPixelPosition <= xBall + 6*BallRadius/10))
		begin 
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall - 4*BallRadius/5) <= YPixelPosition && YPixelPosition <= (yBall - 3*BallRadius/5)) && ((xBall - 8*BallRadius/10) <= XPixelPosition   && XPixelPosition <= xBall + 8*BallRadius/10))
		begin
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall - 3*BallRadius/5) <= YPixelPosition && YPixelPosition <= (yBall - 2*BallRadius/5)) && ((xBall - 92*BallRadius/100) <= XPixelPosition   && XPixelPosition <= xBall + 92*BallRadius/100))
		begin
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall - 2*BallRadius/5) <= YPixelPosition && YPixelPosition <= (yBall - BallRadius/5)) && ((xBall - 98*BallRadius/100) <= XPixelPosition   && XPixelPosition <= xBall + 98*BallRadius/100))
		begin
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall - BallRadius/5) <= YPixelPosition && YPixelPosition <= (yBall + BallRadius/5)) && ((xBall - BallRadius) <= XPixelPosition   && XPixelPosition <= (xBall + BallRadius)))
		begin
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall + BallRadius/5) <= YPixelPosition && YPixelPosition <= (yBall + 2*BallRadius/5)) && ((xBall - 98*BallRadius/100) <= XPixelPosition   && XPixelPosition <= xBall + 98*BallRadius/100))
		begin
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall + 2*BallRadius/5) <= YPixelPosition && YPixelPosition <= (yBall + 3*BallRadius/5)) && ((xBall - 92*BallRadius/100) <= XPixelPosition   && XPixelPosition <= xBall + 92*BallRadius/100))
		begin
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall + 3*BallRadius/5) <= YPixelPosition && YPixelPosition <= (yBall + 4*BallRadius/5)) && ((xBall - 8*BallRadius/10) <= XPixelPosition   && XPixelPosition <= xBall + 8*BallRadius/10))
		begin 
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall + 4*BallRadius/5) <= YPixelPosition && YPixelPosition <= (yBall + BallRadius)) && ((xBall - 6*BallRadius/10) <= XPixelPosition   && XPixelPosition <= xBall + 6*BallRadius/10))
		begin
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		else if(((yBall + BallRadius) <= YPixelPosition && YPixelPosition <= (yBall + 11*BallRadius/10)) && ((xBall - BallRadius/5) <= XPixelPosition   && XPixelPosition <= xBall + BallRadius/5))
		begin
			redValue <= 8'b11111111;
			blueValue <= 8'b11111111;
			greenValue <= 8'b11111111;	
		end
		// End Ball Plot
		
		else
		begin
			redValue <= 8'b00000000; 
			blueValue <= 8'b00000000;
			greenValue <= 8'b00000000;	
		end		
	end
endmodule
