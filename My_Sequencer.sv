// uvm_sequencer class
class my_sequencer extends uvm_sequencer #(my_sequence_item);

	`uvm_component_utils(my_sequencer)
	function new(string name = "my_sequencer",uvm_component parent = null);
		super.new(name,parent);
	endfunction

endclass