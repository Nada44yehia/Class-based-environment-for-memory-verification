class transaction;
  
  rand bit [31:0] Data_in;
  randc bit [3:0] Address;
  rand bit        write_enable;
  rand bit        read_enable;
  bit             rst;
  bit [31:0]      Data_out;
  bit             Valid_out;
  


  // This function allows us to print contents of the data packet
  // so that it is easier to track in a logfile                 
  
  function void print (string tag="");

    $display("T = %0t [%s] \t Address = %0d \t Wr_En = %0d \t Data_in = %0h \t Rd_En = %0d \t Data_out = %0h",
              $time, tag, Address, write_enable, Data_in, read_enable, Data_out);
              
    $display(" --------------------------------------------------------- ");

  endfunction

endclass
