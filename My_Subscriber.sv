// uvm_subscriber
class my_subscriber extends uvm_subscriber #(my_sequence_item);
	
	`uvm_component_utils(my_subscriber)
	my_sequence_item seq_item;

	// No need for creating the analysis export because it's in the uvm_subscriber itself

	// No need for sampling synchronously with the clock, because write function samples synchronouslt
	covergroup addr_cov_grp;

		addr: coverpoint seq_item.addr {
			bins addr_range[16] = {[15:0]};
		}
		
	endgroup
	covergroup data_cov_grp;

		DATA_ZERO: coverpoint seq_item.data_in {
			bins ZERO = {32'h00000000};
		}

		DATA_ONES: coverpoint seq_item.data_in {
			bins ONES = {32'hffffffff};
		}

	endgroup
	covergroup valid_out_cov_grp;
		VALID_TOGGLE: coverpoint seq_item.valid_out {
			bins ZERO_ONE = (0 => 1);
			bins ONE_ZERO = (1 => 0);
		}
	endgroup

	function new(string name = "my_subscriber",uvm_component parent = null);
		super.new(name,parent);
		// Construction of covergroups

		addr_cov_grp = new();
		data_cov_grp = new();
		valid_out_cov_grp = new();

	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		seq_item = my_sequence_item::type_id::create("seq_item");
	endfunction

	// This function must be implemented because uvm_subscriber has pure virtual function (write)
	function void write(my_sequence_item t);
		// For coverage purpose
		seq_item = t;

		$display("info in sub ==> %0d",seq_item.valid_out);

		// Calling sample Method
		// No need for instance of the covergroups because it's constructed in new function of class
		addr_cov_grp.sample;
		data_cov_grp.sample;
		valid_out_cov_grp.sample;

	endfunction

endclass