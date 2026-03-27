import pack::*;
module tb_top;
// Test-Bench Signals 
     bit tb_clk;
     bit tb_rst;
     parameter CLK_PER=10;

// Clock Generation 
  always #(CLK_PER/2) tb_clk = ~tb_clk;
 // Memory Interface instance
   memory_intf m_if (tb_clk, tb_rst);

// Creating Test calss instance  
      test t1;
		
// DUT Instantiation, connect the DUT with the interface 
     memory DUT (m_if);	
		  
  initial begin
    tb_clk = 1'b0;

    // Reset Assertion
    tb_rst = 1'b1;

    // Reset De-Assertion
    #2 tb_rst = 1'b0;

    #(CLK_PER/2);

    // PASS interface to test
    t1 = new(m_if);

    t1.run();

    #10 $stop;
   end

// Dump Generation
     initial
        begin
		
	$dumpfile("mem_dump.vcd");
	$dumpvars;
			
      end	
  
	
endmodule 
