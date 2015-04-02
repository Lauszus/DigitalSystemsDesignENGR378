module Lab2(
	output [4:0] y,
	input	[3:0] a,b,
	input [1:0] s,
	input cin
	);
	assign y = (s==0)?(a+b+cin):(s==1)?(a+(~b)+cin):(s==2)?((~a)+b+cin):(s==3)?((~b)+cin):0;
endmodule
	
	
module test_lab2();
	wire [4:0] y;
	reg	[3:0] a,b;
	reg [1:0] s;
	reg cin;
	Lab2 M1(y,a,b,s,cin);
	
	initial begin
		#3000 $finish;
	end
	initial begin
		#10 s=0; cin=0;
		#20 a=0; b=0;
		#30 a=1; b=3;
		#40 a=4; b=7;
		#50 a=4; b=7;
		#60 s=2;
		#70 s=1;
		#80 a=0; b=0;
		#90 a=1; b=3;
		#100 a=4; b=7;
		#110 a=4; b=7;
		#120 a=15; b=1;
		
		#130 s=0; cin=1;
		#140 a=0; b=0;
		#150 a=1; b=3;
		#160 a=4; b=7;
		#170 a=4; b=7;
		#180 s=2;
		#190 s=1;
		#200 a=0; b=0;
		#210 a=1; b=3;
		#220 a=4; b=7;
		#230 a=4; b=7;
		#240 a=15; b=1;
	end
		
endmodule
	