import pack::*;

class environment;
	sequencer  Seq ;
	driver 	   drv ;
	monitor    mont;
	scoreboard scb ;
    subscriber sub;
    event drv_done;


	virtual memory_intf vif_mem;
	
	mailbox mon_to_scb;
    mailbox mon_to_sub;
  	mailbox seq_to_dr;
  	
  function new(virtual memory_intf vif_mem);
        this.vif_mem = vif_mem;
		mon_to_scb = new();
        mon_to_sub = new();
        seq_to_dr= new();
		Seq  = new(seq_to_dr,drv_done);
		drv  = new(vif_mem,seq_to_dr,drv_done);
		mont = new(vif_mem,mon_to_scb,mon_to_sub);
		scb  = new(mon_to_scb); 
        sub = new(mon_to_sub); 	
		
   endfunction

 virtual task run();
        
    fork
		
	Seq.run_seq();
	drv.run_drive();
	mont.run_monitor();
	scb.run_scoreboard();
    sub.run_subscriber();
          	
		
	join_any
		
	endtask

  
endclass
