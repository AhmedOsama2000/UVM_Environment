// Include Interface and the uvm_classes
`include "interface.sv"
`include "Classes.sv"

module top;

	import uvm_pkg::*;
	import UVM_Classes::*;

	intf1 my_intf();

	// Dut instantiation with inteface
	Memory DUT (
		.clk(my_intf.clk),
        .rst_n(my_intf.rst_n),
        .en(my_intf.en),
        .wr(my_intf.wr),
    	.addr(my_intf.addr),
    	.data_in(my_intf.data_in),
    	.data_out(my_intf.data_out),
        .valid_out(my_intf.valid_out)
	);

	initial begin

	uvm_config_db #(virtual intf1)::set(null,"uvm_test_top","my_vif",my_intf);
		run_test("my_test");
	end

endmodule