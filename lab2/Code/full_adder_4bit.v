module full_adder_4bit(
	output cout,
	output[3:0] sum,
	input[3:0] a, b,
	input cin
	);
	wire cin1, cin2, cin3;
	
	full_adder M1(cin1, sum[0], a[0], b[0], cin);
	full_adder M2(cin2, sum[1], a[1], b[1], cin1);
	full_adder M3(cin3, sum[2], a[2], b[2], cin2);
	full_adder M4(cout, sum[3], a[3], b[3], cin3);
endmodule