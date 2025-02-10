`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2025 17:05:05
// Design Name: 
// Module Name: read_operation
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


module read_operation#(parameter SIZE = 4)(     
    input [SIZE :0] wq2_rptr,      // write to read  this is also gray pointer which is coming from write 
    input rinc,
    input rclk,
    input rrst_n,
    output reg rempty,                  
    output [SIZE-1:0] raddr,       
    output reg [SIZE :0] rptr   // this is sending to write
    );
     
    wire [SIZE:0] rgray_next;   // Next read pointer in gray and binary code
    wire rempty_next;
    
    // fifo empty condition
    assign rempty_next = (rgray_next == wq2_rptr);  
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            rempty <= 1'b0;   // FIFO starts empty    // rempty <= 1'b1 previously
        else
            rempty <= rempty_next;  // Update empty flag
    end
    
    
    reg [SIZE:0] rbin;                     // Binary read pointer
    wire [SIZE:0] rbin_next;
   
  // incerementing    
    assign rbin_next  = rbin + (rinc & ~rempty);
       
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rbin  <= 0;    // Reset Binary Read Pointer    
        end
        else begin
          //@(negedge rclk)
            rbin  <= rbin_next;   // Update Binary Read Pointer
        end
     end   
     
    assign raddr = rbin[SIZE-1:0];

// converting  binary to gray
 
    assign rgray_next = (rbin_next >> 1) ^ rbin_next; 
    
        always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rptr  <= 0;    // Reset Binary Read Pointer    
        end
        else begin
            rptr  <= rgray_next;   // Update Binary Read Pointer
        end
     end  
     
endmodule

