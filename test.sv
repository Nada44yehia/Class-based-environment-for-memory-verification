import pack::*;
class test;
  environment env;


  function new(virtual memory_intf vif_mem);
    env = new(vif_mem);
  endfunction

   task run();

    	env.run();
  endtask


endclass
