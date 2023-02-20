// uvm_agent class
class my_agent extends uvm_agent;
  	
  	`uvm_component_utils(my_agent)
	my_driver 	 driver_inst;
	my_monitor 	 monitor_inst;
	my_sequencer sequencer_inst;
	
	uvm_analysis_port #(my_sequence_item) my_analysis_port_agent;

	virtual intf1 vif;

	function new(string name = "my_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		driver_inst    = my_driver::type_id::create("driver_inst",this);
		monitor_inst   = my_monitor::type_id::create("monitor_inst",this);
		sequencer_inst = my_sequencer::type_id::create("sequencer_inst",this);

		my_analysis_port_agent = new("my_analysis_port_agent",this);

		if(!uvm_config_db#(virtual intf1)::get(this,"","my_vif",vif)) begin
			`uvm_fatal(get_full_name(),"Error")
		end

		uvm_config_db #(virtual intf1)::set(this,"driver_inst","my_vif",vif);
		uvm_config_db #(virtual intf1)::set(this,"monitor_inst","my_vif",vif); 

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		// Initiate the communication between the driver and sequencer
		driver_inst.seq_item_port.connect(sequencer_inst.seq_item_export);
		monitor_inst.my_analysis_port_monitor.connect(my_analysis_port_agent);
	endfunction

	task run_phase (uvm_phase phase);
		super.run_phase(phase);
	endtask
	
endclass