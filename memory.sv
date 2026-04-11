
module memory (memory_intf i1);

  // 2D Array
    reg [31:0] memory_arr [15:0]; 
   always @(posedge i1.clk or posedge i1.Rst_n) 
     begin
       if (i1.Rst_n) 
        begin
          foreach ( memory_arr[i])
             memory_arr[i] <= 0; 
            i1.Data_out<= 0;
            i1.Valid_out<= 0;
    
          end 
       else 
         begin
            if (i1.write_enable && !i1.read_enable)
             begin 
              memory_arr[i1.Address] <= i1.Data_in;
    
             end
	    else if (i1.read_enable && !i1.write_enable)
             begin
            i1.Data_out <= memory_arr[i1.Address]; 
            i1.Valid_out <=1;

             end   
            else 
             begin
            i1.Data_out <= 0; 
            i1.Valid_out <=0;
             end
       end
      end
endmodule
