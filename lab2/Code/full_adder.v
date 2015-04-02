module full_adder(
	output cout, sum,
	input a,b, cin
	);
	wire w1, w2, w3;
	
	half_adder M1(w2, w1, a, b);
	half_adder M2(w3, sum, cin, w1);
	or 		  M3(cout, w2, w3);
endmodule