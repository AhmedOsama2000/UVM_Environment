// uvm_monitor class
// Samples the output data from the virtual interface
// and deliver it to the scoreboard and subscriber as
// a seq_item
class my_monitor extends uvm_monitor;
	
	`uvm_component_utils(my_monitor)
	virtual intf1 vif;

	my_sequence_item seq_item;
	my_sequence_item temp_seq_item; // save a copy from the seq_item

	// Broadcast communication scheme (using uvm_analysis_port)
	uvm_analysis_port #(my_sequence_item) my_analysis_port_monitor;

	function new(string name = "my_monitor",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		// super.build_phase(phase);
		if(!uvm_config_db #(virtual intf1)::get(this,"","my_vif",vif)) begin
			`uvm_fatal(get_full_name(),"Error")
		end

		seq_item 	  = my_sequence_item::type_id::create("seq_item");
		temp_seq_item = my_sequence_item::type_id::create("temp_seq_item");
		
		my_analysis_port_monitor = new("my_analysis_port_monitor",this);

	endfunction

	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		forever begin
			
			@(negedge vif.clk)
			// Sampling the output data and send it to the subscriber
			seq_item.data_out  <= vif.data_out;
			seq_item.valid_out <= vif.valid_out;
			if (!vif.wr && vif.rst_n && vif.en) begin
				$display("info ==>",vif.valid_out);
				$display("info ==>",vif.rst_n);
				seq_item.wr        <= vif.wr;
				seq_item.addr      <= vif.addr;
			end
			// Send the data to create reference model in the scoreboard when valid is not Activated
			else if (vif.wr && vif.rst_n && vif.en) begin
				$display("info ==>",vif.valid_out);
				$display("info ==>",vif.rst_n);
				seq_item.wr      <= vif.wr;
				seq_item.en      <= vif.en;
				seq_item.rst_n   <= vif.rst_n;
				seq_item.addr 	 <= vif.addr;
				seq_item.data_in <= vif.data_in;
				$display("info ==> ",vif.addr);
				$display("info ==> ",vif.data_in);
				$display("info ==> ",vif.wr);
			end
			else if (!vif.rst_n) begin
				seq_item.rst_n <= vif.rst_n;
			end

			$cast(temp_seq_item,seq_item);

			$display("seq_item.data_in",seq_item.data_in);
			$display("seq_item.data_out",seq_item.data_out);
			$display("temp_seq_item.data_in",temp_seq_item.data_in);
			$display("temp_seq_item.data_out",temp_seq_item.data_out);
			my_analysis_port_monitor.write(temp_seq_item);

		end

	endtask
	
endclass
