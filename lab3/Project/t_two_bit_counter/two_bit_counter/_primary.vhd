library verilog;
use verilog.vl_types.all;
entity two_bit_counter is
    port(
        Q               : out    vl_logic_vector(1 downto 0);
        clk             : in     vl_logic
    );
end two_bit_counter;
