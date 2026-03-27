import pack::*;

class subscriber;

    transaction trans;
    mailbox mon_to_sub;
    virtual memory_intf vif_mem;

   
  
  covergroup group_1;
    // WRITE address coverage
    cp_addr_write : coverpoint trans.Address iff (trans.write_enable) {
        bins addr_bins[] = {[0:15]};
    }

    // READ address coverage
   cp_addr_read : coverpoint trans.Address iff (trans.read_enable) {
    bins addr_bins_r[] = {[0:15]};
}

    // Read enable
    cp_read : coverpoint trans.read_enable {
        bins read_on  = {1};
        bins read_off = {0};
    }

    // Write enable
    cp_write : coverpoint trans.write_enable {
        bins write_on  = {1};
        bins write_off = {0};
    }

    // Valid output
    cp_valid : coverpoint trans.Valid_out {
        bins valid = {1};
    }

    // =========================
    // Read/Write combination
    // =========================
    cross_rw : cross cp_read, cp_write {
        bins read_only  = binsof(cp_read)  intersect {1} &&
                          binsof(cp_write) intersect {0};

        bins write_only = binsof(cp_read)  intersect {0} &&
                          binsof(cp_write) intersect {1};

        bins read_write = binsof(cp_read)  intersect {1} &&
                          binsof(cp_write) intersect {1};
    }

  


endgroup

//constructor
     function new(virtual memory_intf vif_mem, mailbox mon_to_sub);	
		 this.mon_to_sub  = mon_to_sub;
		 this.vif_mem = vif_mem;
		 group_1 = new();
      endfunction

    task run_subscriber();
        forever begin
            mon_to_sub.get(trans);

            group_1.sample();

            $display("Subscriber received: Data_in: %0h, Address: %b", 
                     trans.Data_in, trans.Address);

            $display("Subscriber received: Data_out: %0h, Valid_out: %b", 
                     trans.Data_out, trans.Valid_out);
        end
    endtask

endclass
