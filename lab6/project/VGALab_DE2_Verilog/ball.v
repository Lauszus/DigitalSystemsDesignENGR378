module ball#(
		parameter PaddleHeight,
					 PaddleWidth,
					 BallRadius,
					 yTopBar,
					 yBottomBar,
					 xRightBar,
					 xLeftBar,
					 xPLOffset,
					 xPROffset,
					 xBallInit,
					 yBallInit
	)(
		output reg [10:0] xBall, yBall, 
		output reg hitDetectRight,  hitDetectLeft,
		input BallClock, SW,
		input [10:0] yPL, yPR
	);
	parameter S_RESET	= 0, // Reset position
				 S_1		= 1, // LEFT_UP
				 S_2		= 2, // RIGHT_UP
				 S_3		= 3, // RIGHT_DOWN
				 S_4		= 4; // LEFT_DOWN
	reg [2:0] state, nextState;
	integer xBallVector, yBallVector;
	
	always @ (posedge BallClock)
	begin
		if(SW) state <= S_RESET;
		else state <= nextState;
	end
			
	always @ (posedge BallClock) begin // Will only trigger on state since yPLReg, yPRReg, xBall, yBall are all synced with the clock. , xBall, yBall, yPLReg, yPRReg
		hitDetectLeft = 0;
		hitDetectRight = 0;

		/*xBallVector = 0;
		yBallVector = 0;*/

		case(state)
			S_RESET :
							begin
								xBall = xBallInit;
								yBall = yBallInit;
								xBallVector <= 0;
								yBallVector <= 0;
								nextState = S_1;
							end
			S_1	: 		begin // Left, Up
								xBallVector <= -1;
								yBallVector <= -1;

								if(xBall == xLeftBar + BallRadius) // Hit left bar
								begin
									hitDetectLeft = 1;
									nextState = S_2;
								end
								else if(yBall == yTopBar + BallRadius) // Hit top bar
									nextState = S_4;
								else if(yBall >= yPL && yBall <= yPL + PaddleHeight && xBall == xPLOffset + BallRadius) // Hit left paddle
									nextState = S_2;
								//else nextState = S_1;
							end
			S_2	: 		begin // Right, Up
								xBallVector <= 1;
								yBallVector <= -1;
								if(xBall == xRightBar - BallRadius) // Hit right bar
								begin
									nextState = S_1;
									hitDetectRight = 1;
								end
								else if(yBall == yTopBar + BallRadius) // Hit top bar
									nextState = S_3;
								else if(yPR <= yBall && yBall <= yPR + PaddleHeight && xBall == xPROffset - PaddleWidth - BallRadius) // Hit right paddle
									nextState = S_1;
								//else nextState = S_2;
							end
			S_3	: 		begin // Right, Down
								xBallVector <= 1;
								yBallVector <= 1;
								if(xBall == xRightBar - BallRadius) // Hit right bar 
								begin
									nextState = S_4;
									hitDetectRight = 1; 
								end
								else if(yBall == yBottomBar - BallRadius) // Hit bottom bar
									nextState = S_2;
								else if(yPR <= yBall && yBall <= yPR + PaddleHeight && xBall == xPROffset - PaddleWidth - BallRadius) // Hit right paddle
									nextState = S_4;
								//else nextState = S_3;
							end
			S_4	: 		begin	// Left, Down
								xBallVector <= -1;
								yBallVector <= 1;
								if(xBall == xLeftBar + BallRadius) // Hit left bar
								begin
									nextState = S_3;
									hitDetectLeft = 1; 
								end
								else if(yBall == yBottomBar - BallRadius) // Hit bottom bar
									nextState = S_1;
								else if(yPL <= yBall && yBall <= yPL + PaddleHeight && xBall == xPLOffset + BallRadius) // Hit left paddle
									nextState = S_3;
								//else nextState = S_4;
							end
			default nextState = S_RESET;
		endcase
			
		xBall = xBall + xBallVector;
		yBall = yBall + yBallVector;
	end
endmodule