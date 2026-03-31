import pack::*;

class sequencer;

    transaction trans;
    mailbox seq_to_dr;

    int num = 16;          // Number of addresses
    

    // handshake event
    event drv_done;

    //constructor
     function new(mailbox seq_to_dr, event drv_done);	
		this.seq_to_dr   = seq_to_dr;
		this.drv_done = drv_done;
		
      endfunction

    task run_seq();
          

        $display("T=%0t [Sequencer] Starting WRITE phase...", $time);
        // =========================
        // WRITE PHASE
        // =========================
        // WRITE phase: guarantee each address is written once using randc for address in transaction class
		 trans = new();
		for (int i = 0; i < num; i++) begin
			$display("T = %0t [Sequencer] Sending write trans no %0d", $time, i+1);          
            if (!trans.randomize() with {
                write_enable == 1;
                read_enable  == 0;
             }) $fatal("Write Randomization failed"); 
            trans.print("Sequencer-WR");

            // send to driver
            seq_to_dr.put(trans);

            @(drv_done);
        end

        $display("T=%0t [Sequencer] WRITE DONE (%0d items)", $time, num);

        // =========================
        // READ PHASE
        // =========================
        $display("T=%0t [Sequencer] Starting READ phase...", $time);

		for (int i = 0; i < num; i++) begin
			$display("T = %0t [Sequencer] Sending READ trans no %0d", $time, i+1);
            if (!trans.randomize() with {
                write_enable == 0;
                read_enable  == 1;
             }) $fatal("Read Randomization failed");
            trans.print("Sequencer-RD");

            seq_to_dr.put(trans);
            @(drv_done);
        end

        $display("T=%0t [Sequencer] READ DONE (%0d items)", $time, num);

        // =========================
        // MIXED PHASE (random READ/WRITE)
        // =========================
        $display("T=%0t [Sequencer] Starting MIXED phase...", $time);

		for (int i= 0; i < num; i++) begin

            if (!trans.randomize() with {
                write_enable dist {1 := 10, 0 := 90};
                read_enable  dist {1 := 50, 0 := 50};
            }) $fatal("Mixed Randomization failed");


            trans.print("Sequencer-MIX");

            seq_to_dr.put(trans);
            @(drv_done);
        end

        $display("T=%0t [Sequencer] MIXED DONE (%0d items)", $time, num);
    endtask

endclass
