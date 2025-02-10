`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2025 17:56:02
// Design Name: 
// Module Name: write_operation
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

module write_operation#(parameter SIZE = 4)(   
    input [SIZE:0] rq2_wptr,      //read to write this is also gray pointer which is coming from rptr_empty
    input winc,
    input wclk,
    input wrst_n,
    output reg wfull,                 
    output  [SIZE-1:0] waddr,     
    output reg [SIZE:0] wptr   // this is sending to read 
    );
    
    reg [SIZE:0] wbin;           // Binary Write Pointer
    wire [SIZE:0] wbin_next;     // Next value of Binary Write Pointer
    wire [SIZE:0] wgray_next;    // Next value of Gray-coded Write Pointer
    wire wfull_next;
    
  // incrementing
    assign wbin_next  = wbin + (winc & ~wfull);
      
      always @(posedge wclk or negedge wrst_n) begin
                if (!wrst_n) begin
                    wbin  <= 0;    // Reset Binary Write Pointer
                end
                else begin
                   //@(negedge wclk)
                    wbin  <= wbin_next;   // Update Binary Write Pointer
                end
      end
 
 // converting binary to gray 
    
    assign waddr = wbin[SIZE-1:0];       
    assign wgray_next = (wbin_next >> 1) ^ wbin_next;
      
       always @(posedge wclk or negedge wrst_n) begin
                if (!wrst_n) begin
                    wptr  <= 0;    
                end
                else begin
                    wptr  <= wgray_next;   
                end
       end
     
 // fifo full condition    
   
   assign wfull_next = rq2_wptr == {!wgray_next[SIZE:SIZE-1],wgray_next[SIZE-2:0]};
        
      always @(posedge wclk or negedge wrst_n) begin
            if (!wrst_n)
                wfull <= 1'b0;   // FIFO starts empty (not full)
            else
                wfull <= wfull_next;  // Update full flag
           end
                  
endmodule