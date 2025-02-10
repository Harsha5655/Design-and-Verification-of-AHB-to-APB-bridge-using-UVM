`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.02.2025 00:01:03
// Design Name: 
// Module Name: top_bridge
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_bridge( 
                        //input [31:0] wdata,
                        input HSEL,
                        input HWRITE,
                        input [1:0] HBURST,
                        input [1:0] HTRANS,
                        input HREADY,
                        input write_enable,
                        input Pready,
                        input [31:0] HADDR_TEMP,
                        input [31:0] HWDATA,        // Input data - data to be written
                        //input winc,                  // write enable
                        input wclk,
                        input wrst_n,       // Write increment, write clock, write reset
                        input transfer,
                        input rclk,
                        input rrst_n,       // Read increment, read clock, read reset
                        //output [31:0] rdata,       // Output data - data to be read
                        output wfull,                   // Write full signal
                        output rempty,
                        output  Psel,             // Slave select
                        output  [31:0] Paddr, // Address to APB slave
                        output  [31:0] Pdata, // Data to write to the slave
                        output  [31:0] rdata_temp, // Data read from the slave
                        output  Pwrite,            // Write control signal
                        output  Penable
                        //output  [31:0] memory_data 
    );
    
      wire  [31:0] rdata;
      wire [31:0] ADDR_TEMP;
      wire [31:0]   HWDATA_TEMP;
      wire          VALID;
      wire       HWRITE_TEMP;
      wire [31:0] address_out;
      //wire  [31:0] Paddr;
      //wire  [31:0] Pdata;
      //wire   Pwrite;
      //wire   Penable;
     // wire  [31:0] memory_data;
      //wire  [31:0] rdata_temp;
    
    
             ahb_slave DUT(
                             .HRESETn(wrst_n),
                             .HCLK(wclk),
                             .HSEL(HSEL),
                             .HADDR(HADDR_TEMP),
                             .HWRITE(HWRITE),
                             .HBURST(HBURST),
                             .HTRANS(HTRANS),
                             .HREADY(HREADY),
                             .HWDATA(HWDATA),
                             //.HRDATA(rdata_temp),
                             .HADDR_TEMP(ADDR_TEMP),
                             .HWDATA_TEMP(HWDATA_TEMP),
                             .VALID(VALID),
                             .HWRITE_TEMP(HWRITE_TEMP)
                     );
    
            top DUT1 ( 
                    .address(ADDR_TEMP),
                    .wdata(HWDATA_TEMP),        // Input data - data to be written
                    .winc(HWRITE_TEMP),                    // write enable
                    .wclk(wclk),
                    .wrst_n(wrst_n),       // Write increment, write clock, write reset
                    .rinc(Penable),
                    .rclk(rclk),
                    .rrst_n(rrst_n),       // Read increment, read clock, read reset
                    .rdata(rdata),       // Output data - data to be read
                   .wfull(wfull),                   // Write full signal
                   .rempty(rempty),
                   .address_out(address_out)
                    
    );
    
          APB_MASTER DUT2(
    // Global signals
               .Presetn(rrst_n),           
               .Pclk(rclk),              
    
    // Controller inputs
               .addr_temp(address_out), 
               .data_temp(rdata),  
               //.Prdata(memory_data),     
               .transfer(transfer),              
               .Pready(Pready),                 
               .write_enable(write_enable),        
    
    // Output signals
               .Psel(Psel),             
               .Paddr(Paddr), 
               .Pdata(Pdata),      // output 
               .rdata_temp(rdata_temp), 
               .Pwrite(Pwrite),            
               .Penable(Penable)            
);
      
//         APB_SLAVE DUT3  (
//                            .Pclk(rclk),
//                            .Presetn(rrst_n),
//                            .Paddr(Paddr),
//                            .Pdata(Pdata),
//                            .Pwrite(Pwrite),
//                            //.Penable(Penable),
//                            .memory_out(memory_data)
//                            );
    
endmodule
