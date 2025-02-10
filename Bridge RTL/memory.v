`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2025 16:42:09
// Design Name: 
// Module Name: memory
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


module memory #(parameter DSIZE = 32,parameter ASIZE = 5)(        
    input [DSIZE-1:0] wdata,         
    input [ASIZE-1:0] waddr,
    input [ASIZE-1:0] raddr,
    input [31:0] address,  
    input wclk_en,
    input wfull,
    input wclk, 
    input rclk,
    input rclk_en,
    input rempty,
    output reg [DSIZE-1:0] rdata, 
    output reg [31:0] address_out       
      );
      
      localparam DEPTH = 1 << ASIZE;    //declaring memory locations 
      reg [DSIZE-1:0] mem [0:DEPTH-1];     // initating memory locations
      
      /// performing write operation 
       always @(posedge wclk)
        begin
                if (wclk_en && !wfull)
                  begin
                      mem[wdata] = wdata; // Write data
                      $display("data=%0h,address=%0h",wdata,waddr);
                   end
//                else 
//                    begin
//                        mem[waddr] = 0;
//                     end
        end
         //$display("mem= %0p,waddr=%h,full=%0b",mem,waddr,wfull);
        
        /// performing read operation
        always @(*) 
        begin
         if(rclk_en && !rempty)
           begin
              rdata=mem[raddr];
              address_out = raddr+1;
               $display("data output=%0h,address output=%0h",rdata,raddr);
           end
         else 
            begin       
               rdata=0;
            end
        end
  endmodule     
