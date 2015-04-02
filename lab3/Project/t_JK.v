
module t_JK;
	reg j,k,clk, reset;
	wire q;
	
	JK M1(q,j,k,clk,reset);
	
	initial begin
		clk = 0; j = 0; k = 0; reset = 0;
	end
	always #5 clk = ~clk;
	
	
	initial #200 $stop;
	initial begin
		#2.5
		#10 {j,k} = 2'b00;
		#10 {j,k} = 2'b10;
		#10 {j,k} = 2'b01;
		#10
		#10 {j,k} = 2'b11;
	end
	
	
endmodule

module t_two_bit_counter;
	reg clk, reset;
	wire [1:0] Q;
	wire dir;
	
	two_bit_counter M1(.Q(Q),.clk(clk), .reset(reset), .dir(dir));
	
	initial begin
		clk = 0; reset = 0;
	end
	always #10 clk = ~clk;
	
	initial #200 $stop;
	initial begin
		#10;
		#5 reset = 1;
		#5 reset = 0;
	end
	
endmodule
