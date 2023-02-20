// uvm_sequence_item class
// Hold I/O of the DUT and the constraints of randomization
class my_sequence_item extends uvm_sequence_item;

	`uvm_object_utils(my_sequence_item)
	function new(string name = "my_sequence_item");
		super.new(name);
	endfunction

    bit                    		 clk;
	logic 				   		 rst_n;
	logic 				   		 en;
	logic 				   		 wr;
	randc logic [ADDR_WIDTH-1:0] addr;
	rand logic [DATA_WIDTH-1:0]  data_in;
	logic [DATA_WIDTH-1:0] 		 data_out;
	logic 				   		 valid_out;

	constraint constr_1 {
		data_in inside {32'hffffffff,32'h1234_ABCD,32'hf0f0f0f0,32'h0f0f0f0f,32'hffff0000,32'h0000ffff,32'hABCD_1234};
	}


endclass