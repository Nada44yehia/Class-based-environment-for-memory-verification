import pack::*;
class monitor;
  	virtual memory_intf  vif_mem ;
	
	mailbox mon_to_scb;
        mailbox mon_to_sub;
  
  //constructor
     function new(virtual memory_intf vif_mem, mailbox mon_to_scb, mailbox mon_to_sub);	
                 this.mon_to_scb  = mon_to_scb;
		 this.mon_to_sub  = mon_to_sub;
		 this.vif_mem = vif_mem;
		
      endfunction
	
	// Sampling logic and sending the sampled transaction to the scoreboard
	task run_monitor();
	    transaction trans;
	     forever
		begin
		   @ (posedge vif_mem.clk);
                     trans = new;
                     trans.write_enable= vif_mem.write_enable ;
		     trans.read_enable =vif_mem.read_enable ;
                     trans.Data_in= vif_mem.Data_in  ;
                     trans.Address= vif_mem.Address  ;
                   if (vif_mem.read_enable && !vif_mem.write_enable) begin
                      @(posedge vif_mem.clk);
        	    trans.Data_out = vif_mem.Data_out;
                    trans.Valid_out = vif_mem. Valid_out;
                   end
                     trans.print("Monitor");
                     mon_to_scb.put(trans);
      	             mon_to_sub.put(trans);
			
		end
	
	endtask

endclass
