//uvm_sequence
class my_sequence extends uvm_sequence;

	`uvm_object_utils(my_sequence)

	my_sequence_item seq_item;

	function new (string name = "my_seq_item");
		super.new(name);
	endfunction

	// Acts as a build phase
	task pre_body;
		seq_item = my_sequence_item::type_id::create("seq_item");
	endtask 

	task reset;
		seq_item.rst_n = 1'b0;
	endtask

	task set;
		seq_item.rst_n = 1'b1;
	endtask

	task get_tests;

		TEST_CASES = Correct_Cases + inCorrect_Cases;

		$display(" ------------------ TEST___CASES  ------------------");
		$display("Test Cases ==> %0d",TEST_CASES);
		$display("Correct_Cases ==> %0d",Correct_Cases);
		$display("Incorrect_Cases ==> %0d",inCorrect_Cases);
		$display("------------------  TEST's DONE!  ------------------");
	endtask

	// Acts as a run phase
	task body;

		// Test Cases

		// Test Case_1
		// Reset
		start_item (seq_item);
		reset;
		seq_item.en = 1'b0;
		TEST_CASES++;
		finish_item(seq_item);
		#DELAY

		// Test Case_2
		// Set
		start_item (seq_item);
		set;
		finish_item(seq_item);
		#DELAY

		// Test Case_3
		// Write To DUT
		for (int i = 0;i < MEM_DEPTH;i++) begin
			start_item(seq_item);
			seq_item.wr = 1'b1;
			seq_item.en = 1'b1;
			seq_item.randomize();
			finish_item(seq_item);
		end

		#DELAY

		// Test Case_4
		// Read From DUT
		for (int i = 0;i < MEM_DEPTH;i++) begin
			start_item(seq_item);
			seq_item.wr = 1'b0;
			seq_item.randomize();
			TEST_CASES++;
			finish_item(seq_item); 
		end

		// Test Case_5
		// Reset Again
		start_item (seq_item);
		reset;
		seq_item.en = 1'b0;
		seq_item.wr = 1'b0;
		TEST_CASES++;
		finish_item(seq_item);
		#5;

		get_tests;

	endtask

endclass