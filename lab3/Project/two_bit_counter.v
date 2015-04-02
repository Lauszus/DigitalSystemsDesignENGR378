module two_bit_counter(
	output [1:0] Q,
	input clk, reset,
	output reg dir
);
	wire qClk;
	
	assign qClk = dir ? ~Q[0] : Q[0];
	
	JK M1(Q[0], 1'b1,1'b1, clk, reset);
	JK M2(Q[1], 1'b1,1'b1, qClk ,reset);
	
	initial dir = 0;

	always @ (posedge clk, posedge reset) begin
		if (reset) dir = 0;
		else if ((Q == 2'b00 | Q == 2'b11))
			dir = ~dir;
	end
	
	
endmodule
