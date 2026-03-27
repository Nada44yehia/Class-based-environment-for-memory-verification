import pack::*;
class driver;
  
event  drv_done;
  
virtual memory_intf vif_mem;
  
  mailbox seq_to_dr;

    
  // constructor
  function new(virtual memory_intf vif_mem, mailbox seq_to_dr ,event drv_done);
    this.vif_mem = vif_mem;
    this.drv_done = drv_done;
    this.seq_to_dr = seq_to_dr;
     
   endfunction
  
    
        task run_drive();
		
		$display("T = %0t [Driver] Starting .... \n", $time);
             

		forever begin                 
	           transaction trans;
                   $display ("T=%0t [Driver] waiting for item ...", $time);
                        seq_to_dr.get(trans);
			trans.print("Driver");
			vif_mem.write_enable = trans.write_enable;
			vif_mem.read_enable = trans.read_enable;
                        vif_mem.Data_in=  trans.Data_in;
                        vif_mem.Address=  trans.Address;
                         @(posedge vif_mem.clk);
                         @(posedge vif_mem.clk);
			
	             ->drv_done;
                 end

	endtask 

endclass
