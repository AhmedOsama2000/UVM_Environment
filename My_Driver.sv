// uvm_driver
class my_driver extends uvm_driver #(my_sequence_item);
  	
	`uvm_component_utils(my_driver)
	my_sequence_item seq_item;
	virtual intf1 vif;

	function new(string name = "my_driver",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual intf1)::get(this,"","my_vif",vif)) begin
			`uvm_fatal(get_full_name(),"Error")
			seq_item = my_sequence_item::type_id::create("seq_item");
		end

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		forever begin
			seq_item_port.get_next_item(seq_item); 
			@(negedge vif.clk) // sync with the clock
			// Important especialy when the dut samples synchronously with the clk
			vif.rst_n   <= seq_item.rst_n;
			vif.data_in <= seq_item.data_in;
			vif.addr    <= seq_item.addr;
			vif.wr      <= seq_item.wr;
			vif.en      <= seq_item.en;

			#1
			seq_item_port.item_done();
		end
	endtask
	
endclass