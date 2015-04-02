module Lab2(
	output[3:0] F,
	output cout,
	input	[3:0] a,b,
	input [1:0] s,
	input cin
	);
	wire[3:0] y0, y1;
	
	assign y0 = !s[1] ? a : !s[0] ? ~a : 0;
	assign y1 = s[0] ? ~b : b;
	
	full_adder_4bit M1(cout, F, y0, y1, cin);
endmodule

/*
module Lab2(
	output [3:0] y,
	output cout,
	input	[3:0] a,b,
	input [1:0] s,
	input cin,

	);
	assign {cout,y} = (s==2'b00) ? (a+b+cin) :
							(s==2'b01) ? (a+(~{1'b1,b})+cin) :
							(s==2'b10) ? ((~{1'b1,a})+b+cin) :
							(s==2'b11) ? ((~{1'b1,b})+cin) :
							0;
endmodule
*/