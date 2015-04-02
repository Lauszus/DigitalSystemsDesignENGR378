module half_adder(
	output cout, sum,
	input a,b
	);
	xor M1 (sum, a, b);
	and M2 (cout, a, b);
endmodule