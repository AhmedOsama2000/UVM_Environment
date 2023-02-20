// uvm_test
class my_test extends uvm_test;
		
	`uvm_component_utils(my_test)
	my_env env_inst;
	my_sequence seq_inst;

	virtual intf1 vif;

	function new(string name = "my_test",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);

		seq_inst = my_sequence::type_id::create("seq_inst");
		env_inst = my_env::type_id::create("env_inst",this);

		if(!uvm_config_db#(virtual intf1)::get(this,"","my_vif",vif)) begin
			`uvm_fatal(get_full_name(),"Error")
		end
		uvm_config_db#(virtual intf1)::set(this,"env_inst","my_vif",vif);

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		seq_inst.start(env_inst.agent_inst.sequencer_inst);
		phase.drop_objection(this);
	endtask
	
endclass