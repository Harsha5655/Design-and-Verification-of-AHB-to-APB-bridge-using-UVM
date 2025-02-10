`timescale 1ns / 1ps

module APB_SLAVE #(parameter DSIZE = 32, parameter ASIZE = 32, parameter MEM_DEPTH = 16)(
    input  Pclk,          // Clock signal
    input  Presetn,       // Active-low reset
    input  [ASIZE-1:0] Paddr, // Address input from APB Master
    input  [DSIZE-1:0] Pdata, // Data input from APB Master
    input  Pwrite,  // Write enable signal
    //input Penable,
    output reg [DSIZE-1:0] memory_out // Data output
);

// Memory array
reg [DSIZE-1:0] memory [0:MEM_DEPTH-1];

// Memory Write Operation
integer i;
always @(posedge Pclk or negedge Presetn) begin
    if (!Presetn) begin
        for (i = 0; i < MEM_DEPTH; i = i + 1) begin
            memory[i] <= 0;
        end
    end else if (Pwrite) begin
        memory[Paddr] <= Pdata; 
        $display("data at apb slave memory is =%0h,aaddress=%0h",Pdata,Paddr);
    end
end

// Memory Read Operation
always @(posedge Pclk) begin
    if (!Pwrite) begin
        memory_out <= memory[Paddr]; 
    end
end

endmodule
