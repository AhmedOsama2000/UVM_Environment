// uvm_scoreboard class
class my_scoreboard extends uvm_scoreboard;
	
	`uvm_component_utils(my_scoreboard)
	my_sequence_item seq_item;

	uvm_tlm_analysis_fifo #(my_sequence_item) my_tlm_analysis_fifo;
	uvm_analysis_export #(my_sequence_item) my_analysis_export_scoreboard;

	function new(string name = "my_scoreboard",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		
		seq_item = my_sequence_item::type_id::create("seq_item");
		my_tlm_analysis_fifo 	 	  = new("my_tlm_analysis_fifo",this);
		my_analysis_export_scoreboard = new("my_analysis_export_scoreboard",this);

	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		// connecting the analysis_export of the scorebaord to the one in the tlm_analysis_fifo
		my_analysis_export_scoreboard.connect(my_tlm_analysis_fifo.analysis_export);

	endfunction

	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		forever begin
			my_tlm_analysis_fifo.get_peek_export.get(seq_item);
			$display("in SB seq_item.en == %0d",seq_item.en);
			$display("in SB seq_item.rst_n == %0d",seq_item.rst_n);
			$display("in SB seq_item.wr == %0d",seq_item.wr);
			$display("in SB seq_item.data_in == %0d",seq_item.data_in);
			$display("in SB seq_item.addr == %0d",seq_item.addr);
			// Filling up the reference model from monitor
			if (seq_item.wr && seq_item.rst_n && seq_item.en) begin
				data_sent2Mem_assoc[seq_item.addr] = seq_item.data_in;
				$display("info of data_assoc ==>",data_sent2Mem_assoc[seq_item.addr]);
			end
			// Read From Dut then comparing the reference that has been created
			else if (!seq_item.wr && seq_item.rst_n && seq_item.en) begin
				if ( (seq_item.data_out == data_sent2Mem_assoc[seq_item.addr]) && (seq_item.valid_out == 1) ) begin
					$display("At Time %0t, Test Passes",$time);
					Correct_Cases++;
					$display("Correct Cases ==> %0d",Correct_Cases);
					$display("Valid_out = %0d",seq_item.valid_out);
				end
				else begin
					$display("At Time %0t, Test Fails, (DUT_Output = %0d) != (data_out = %0d) or valid_out = %0d != 1",
							  $time,seq_item.data_out,data_sent2Mem_assoc[seq_item.addr],seq_item.valid_out);
					inCorrect_Cases++;
				end
			end
			else if (!seq_item.rst_n) begin
				if (!seq_item.valid_out) begin
					$display("At Time %0t, RESET Passes",$time);
					Correct_Cases++;
				end
				else begin
					$display("RESET Fails");
					inCorrect_Cases++;
				end
			end
		end
	endtask
endclass