import pack::*;

class scoreboard;

  mailbox mon_to_scb;

  // Reference model: stores last written transaction per address
  // Index = address, Value = transaction containing expected data
  transaction transq[16];

  // constructor
  function new(mailbox mon_to_scb);
    this.mon_to_scb = mon_to_scb;    
  endfunction


  task run_scoreboard();
    forever begin
      transaction trans;

      mon_to_scb.get(trans);

      trans.print("Scoreboard");


      // =========================
      // WRITE OPERATION
      // =========================
      // If write is enabled, store data in reference model
      if (trans.write_enable) begin

        // Allocate entry if not used before
        if (transq[trans.Address] == null)
          transq[trans.Address] = new;

        // Store latest transaction (reference expected value)
        transq[trans.Address] = trans;

        $display ("T=%0t [Scoreboard] STORE: addr=0x%0h data=0x%0h",
                  $time, trans.Address, trans.Data_in);
      end


      // =========================
      // READ OPERATION
      // =========================
      // Check read data against stored expected value
      if (!trans.write_enable && trans.read_enable) begin

        // Case 1: First time reading this address (no prior write)
        if (transq[trans.Address] == null) begin

          // Expected value = 0 (memory default)
          if (trans.Data_out != 0)
            $display ("T=%0t [Scoreboard] ERROR! First read addr=0x%0h exp=0 act=0x%0h",
                      $time, trans.Address, trans.Data_out);
          else
            $display ("T=%0t [Scoreboard] PASS! First read addr=0x%0h exp=0 act=0x%0h",
                      $time, trans.Address, trans.Data_out);
        end


        // Case 2: Address was written before ? compare with stored value
        else begin

          if (trans.Data_out != transq[trans.Address].Data_in)
            $display ("T=%0t [Scoreboard] ERROR! addr=0x%0h exp=0x%0h act=0x%0h",
                      $time,
                      trans.Address,
                      transq[trans.Address].Data_in,
                      trans.Data_out);
          else
            $display ("T=%0t [Scoreboard] PASS! addr=0x%0h exp=0x%0h act=0x%0h",
                      $time,
                      trans.Address,
                      transq[trans.Address].Data_in,
                      trans.Data_out);
        end
      end

    end
  endtask

endclass
