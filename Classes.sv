`include "interface.sv"
package UVM_Classes;

	parameter ADDR_WIDTH = 4;
	parameter DATA_WIDTH = 32;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	// Initiating Sequences
	localparam DELAY           = 1;
	localparam MEM_DEPTH       = 2**ADDR_WIDTH;

	// Modeling the DUT
	logic [DATA_WIDTH-1:0] data_sent2Mem_assoc [int];

	// Debug Counter
	integer Correct_Cases   = 0;
	integer inCorrect_Cases = 0;
	integer TEST_CASES      = 0;

	`include "My_Sequence_item.sv"
	`include "My_Sequence.sv"
	`include "My_Sequencer.sv"
	`include "My_Driver.sv"
	`include "My_Monitor.sv"
	`include "My_Agent.sv"
	`include "My_Scoreboard.sv"
	`include "My_Subscriber.sv"
	`include "My_Env.sv"
	`include "My_Test.sv"
	
endpackage : UVM_Classes