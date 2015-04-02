module gamescore(
	input hitDetectRight,  hitDetectLeft, SW,
	output gameOver,
	output [6:0] HEX6, HEX7
);
	reg [3:0] rightPlayerScore, leftPlayerScore;
	
	display_driver M1(.out(HEX7), .in(leftPlayerScore));	// Output score to segment displays.
	display_driver M2(.out(HEX6), .in(rightPlayerScore));
	
	assign gameOver = leftPlayerScore == 4'd9 || rightPlayerScore == 4'd9; // Needed for gameover to update immediately since the always 
	//	loop only executes on changes to its event control and there would be no change if this would be checked directly in S_COUNT.

	always@(posedge hitDetectLeft, posedge SW) 
		if(SW) rightPlayerScore = 0;
		else if (!gameOver) rightPlayerScore = rightPlayerScore + 1'd1;
	always@(posedge hitDetectRight, posedge SW)
		if(SW) leftPlayerScore = 0;
		else if(!gameOver) leftPlayerScore = leftPlayerScore + 1'd1;

endmodule
module t_gamescore();
	reg hitDetectRight,  hitDetectLeft, SW;
	wire gameOver;
	wire [6:0] HEX6, HEX7;
	
	gamescore M1(.hitDetectRight(hitDetectRight), .hitDetectLeft(hitDetectLeft), .SW(SW), .gameOver(gameOver), .HEX6(HEX6), .HEX7(HEX7));
	
	initial begin
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b001;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;

		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#50
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b001; // Reset
		#10
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b010;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#50
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#20
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b100;
		#10 {hitDetectRight, hitDetectLeft, SW} = 3'b000;
		#20$stop;
	end

endmodule

module display_driver(
		output reg[6:0] out,
		input [3:0] in
	);
	
	always @ (in) begin
		case (in)
			4'b0000 : out = 7'b1000000; // 0
			4'b0001 : out = 7'b1111001; // 1
			4'b0010 : out = 7'b0100100; // 2
			4'b0011 : out = 7'b0110000; // 3
			4'b0100 : out = 7'b0011001; // 4
			4'b0101 : out = 7'b0010010; // 5
			4'b0110 : out = 7'b0000011; // 6
			4'b0111 : out = 7'b1111000; // 7
			4'b1000 : out = 7'b0000000; // 8
			4'b1001 : out = 7'b0011000; // 9
			
			4'b1010 : out = 7'b0001000; // A
			4'b1011 : out = 7'b0000000; // B (8)
			4'b1100 : out = 7'b1000110; // C
			4'b1101 : out = 7'b1000000; // D (0)
			4'b1110 : out = 7'b0000110; // E
			4'b1111 : out = 7'b0001110; // F
			
			default : out = 7'b1111111; // OFF
		endcase
	end
endmodule


