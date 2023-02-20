// uvm_env class
class my_env extends uvm_env;
	
	`uvm_component_utils(my_env)
	my_agent 	  agent_inst;
	my_subscriber subscriber_inst;
	my_scoreboard scoreboard_inst;
	
	virtual intf1 vif;

	function new(string name = "my_env",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		agent_inst 		= my_agent::type_id::create("agent_inst",this);
		subscriber_inst = my_subscriber::type_id::create("subscriber_inst",this);
		scoreboard_inst = my_scoreboard::type_id::create("scoreboard_inst",this);

		if(!uvm_config_db#(virtual intf1)::get(this,"","my_vif",vif)) begin
			
			`uvm_fatal(get_full_name(),"Error")

		end
		uvm_config_db#(virtual intf1)::set(this,"agent_inst","my_vif",vif);

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		agent_inst.my_analysis_port_agent.connect(scoreboard_inst.my_analysis_export_scoreboard);
		agent_inst.my_analysis_port_agent.connect(subscriber_inst.analysis_export);

	endfunction

	task run_phase (uvm_phase phase);
		super.run_phase(phase);
	endtask
	
endclass