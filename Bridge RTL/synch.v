`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2025 16:54:13
// Design Name: 
// Module Name: synch
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


module synch #(parameter ASIZE =4)(
    input [ASIZE:0] din,      
    input clk,
    input  rst_n,            
    output reg [ASIZE:0] q2
    );

    reg [ASIZE:0] q1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            {q2, q1} <= 2'b0;         
        else 
            {q2, q1} <= {q1, din};  
    end 

endmodule
