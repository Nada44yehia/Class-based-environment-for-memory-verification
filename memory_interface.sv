interface memory_intf(input logic clk, Rst_n);
 
  logic 	   write_enable;
  logic	   	   read_enable;
  logic [31:0] Data_in;
  logic [3:0]  Address  ;
  logic [31:0] Data_out ;
  logic		   Valid_out;
  

	
endinterface
