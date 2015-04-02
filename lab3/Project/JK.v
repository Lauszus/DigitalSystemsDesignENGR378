
module JK(
	output  reg q,
	input j,k,clk, reset
);

	initial q = 0;

	always @ (posedge clk, posedge reset)
	begin
		if(reset == 1) q = 0;
		else if(j&k) q=~q;
		else if(k==1) q=0;
		else if(j==1) q=1;
		else q=q;
	end
endmodule	

