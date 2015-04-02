module mydlatch(
	output reg q,
	input d,clk
);
	initial q = 0;
	
	always @ (posedge clk)
	begin
		if(d==1) q=1;
		else if(d==0) q=0;
		else q=q;
	end		
endmodule

module t_mydlatch;
	reg d,clk;
	wire q;
	
	mydlatch M1(q,d,clk);
	
	initial #200 $stop;
	initial clk = 0;
	always #2.5 clk = ~clk;
	
	initial begin
		#10 d = 1;
		#10 d = 0;
	end 
endmodule
