module keyboard(
	output reg [6:0] HEX0, HEX1, HEX2, HEX3, // 7-segment displays
	input  PS2_CLK, PS2_DAT, // The clock and data signals from the PS/2 device
	input [0:0] KEY // Used as reset signal
 );
	wire newChar;
	wire [7:0] char;
	reg [7:0] lastChar, lastChar2;
	
	receiver M1(.newChar(newChar), .char(char), .PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), .reset(!KEY[0]));
	
	always @ (posedge newChar or negedge KEY[0]) begin
		if (!KEY[0]) begin
			HEX0 = 7'b1111111; // OFF
			HEX1 = 7'b1111111; // OFF
			HEX2 = 7'b1111111; // OFF
			HEX3 = 7'b1111111; // OFF
		end
		else if (char == 8'hF0) begin // This will ensure that we only display the last value once the button is released
			if (lastChar == 8'hE0) begin // Make sure that it display the entire key-code of the arrows and other buttons that sends a 16-bit transmission
				HEX2 = display_driver(lastChar[3:0]);
				HEX3 = display_driver(lastChar[7:4]);
				HEX0 = display_driver(lastChar2[3:0]);
				HEX1 = display_driver(lastChar2[7:4]);
			end
			else begin
				HEX2 = HEX0; // Shift value to next two displays
				HEX3 = HEX1;
				HEX0 = display_driver(lastChar[3:0]);
				HEX1 = display_driver(lastChar[7:4]);
			end
		end
		else begin
			lastChar2 = lastChar; // Save the char before last char
			lastChar = char; // Save last char
		end
	end
	
	function [6:0] display_driver;
		input [3:0] in;
		case (in)
			4'b0000 : display_driver = 7'b1000000; // 0
			4'b0001 : display_driver = 7'b1111001; // 1
			4'b0010 : display_driver = 7'b0100100; // 2
			4'b0011 : display_driver = 7'b0110000; // 3
			4'b0100 : display_driver = 7'b0011001; // 4
			4'b0101 : display_driver = 7'b0010010; // 5
			4'b0110 : display_driver = 7'b0000011; // 6
			4'b0111 : display_driver = 7'b1111000; // 7
			4'b1000 : display_driver = 7'b0000000; // 8
			4'b1001 : display_driver = 7'b0011000; // 9
				
			4'b1010 : display_driver = 7'b0001000; // A
			4'b1011 : display_driver = 7'b0000000; // B (8)
			4'b1100 : display_driver = 7'b1000110; // C
			4'b1101 : display_driver = 7'b1000000; // D (0)
			4'b1110 : display_driver = 7'b0000110; // E
			4'b1111 : display_driver = 7'b0001110; // F
				
			default : display_driver = 7'b1111111; // OFF
		endcase
	endfunction
endmodule

module t_keyboard;
	wire [6:0] HEX0, HEX1, HEX2, HEX3; // 7-segment displays
	reg  PS2_CLK, PS2_DAT; // The clock and data signals from the PS/2 device
	reg reset; // Used as reset signal
	
	keyboard M1(.PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), .KEY(reset), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3));

	initial begin
		PS2_CLK = 1; reset = 1; // Set initial values
	end

	always #5 PS2_CLK = !PS2_CLK; // Generate clk signal

	// Test by releasing up arrow
	always begin
		reset = 0;
		#10 reset = 1;

		// Send 0x75
		PS2_DAT = 0; // Start bit
		#10 PS2_DAT = 1; // D0
		#10 PS2_DAT = 0; // D1
		#10 PS2_DAT = 1; // D2
		#10 PS2_DAT = 0; // D3
		#10 PS2_DAT = 1; // D4
		#10 PS2_DAT = 1; // D5
		#10 PS2_DAT = 1; // D6
		#10 PS2_DAT = 0; // D7
		#10 PS2_DAT = 0; // Parity bit
		#10 PS2_DAT = 1; // Stop bit
		
		// Send E0
		#50 PS2_DAT = 0; // Start bit
		#10 PS2_DAT = 0; // D0
		#10 PS2_DAT = 0; // D1
		#10 PS2_DAT = 0; // D2
		#10 PS2_DAT = 0; // D3
		#10 PS2_DAT = 0; // D4
		#10 PS2_DAT = 1; // D5
		#10 PS2_DAT = 1; // D6
		#10 PS2_DAT = 1; // D7
		#10 PS2_DAT = 0; // Parity bit
		#10 PS2_DAT = 1; // Stop bit
		
		// Send F0
		#50 PS2_DAT = 0; // Start bit
		#10 PS2_DAT = 0; // D0
		#10 PS2_DAT = 0; // D1
		#10 PS2_DAT = 0; // D2
		#10 PS2_DAT = 0; // D3
		#10 PS2_DAT = 1; // D4
		#10 PS2_DAT = 1; // D5
		#10 PS2_DAT = 1; // D6
		#10 PS2_DAT = 1; // D7
		#10 PS2_DAT = 1; // Parity bit
		#10 PS2_DAT = 1; // Stop bit

		#50 reset = 0;
		#10 $stop;
	end
	
endmodule