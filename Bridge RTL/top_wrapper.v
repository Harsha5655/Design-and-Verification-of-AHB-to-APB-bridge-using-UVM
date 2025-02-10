module top_wrapper(
                     input          Pclk,
                     input          Pready,
                     input [31:0]   HADDR_TEMP,
                     input [1:0 ]   HBURST,
                     input          Hclk,
                     input          HREADY,
                     input          Hresetn,
                     input          HSEL,
                     input [1:0 ]   HTRANS,
                     input [31:0]   HWDATA,
                     input          HWRITE,
                     input          Presetn,
                     input          transfer,
                     input          write_enable,
                     output  [31:0]      Paddr,
                     output  [31:0]      Pdata,
                     output         Penable,
                     output         Psel,
                     output         Pwrite,
                     output  [31:0]      rdata_temp,
                     output         rempty,
                     output         wfull
                     );
      
      
      
          top_bridge  DUT0 ( 
                        //input [31:0] wdata,
                           .HSEL(HSEL),
                           .HWRITE(HWRITE),
                           .HBURST(HBURST),
                           .HTRANS(HTRANS),
                           .HREADY(HREADY),
                           .write_enable(write_enable),
                           .Pready(Pready),
                           .HADDR_TEMP(HADDR_TEMP),
                           .HWDATA(HWDATA),        // Input data - data to be written
                        //input winc,                  // write enable
                           .wclk(Hclk),
                           .wrst_n(Hresetn),       // Write increment, write clock, write reset
                           .transfer(transfer),
                           .rclk(Pclk),
                           .rrst_n(Presetn),      // Read increment, read clock, read reset
                        //output [31:0] rdata,       // Output data - data to be read
                           .wfull(wfull),                   // Write full signal
                           .rempty(rempty),
                           .Psel(Psel),             // Slave select
                           .Paddr(Paddr), // Address to APB slave
                           .Pdata(Pdata), // Data to write to the slave
                           .rdata_temp(rdata_temp), // Data read from the slave
                           .Pwrite(Pwrite),            // Write control signal
                           .Penable(Penable)
                        //output  [31:0] memory_data 
    );                 

    
endmodule