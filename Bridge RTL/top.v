`timescale 1ns / 1ps

module top #(parameter DSIZE = 32,parameter ASIZE = 5)(
    input [DSIZE-1:0] wdata,        // Input data - data to be written
    input [DSIZE-1:0] address,
    input winc,                    // write enable
    input wclk,
    input wrst_n,       // Write increment, write clock, write reset
    input rinc,
    input rclk,
    input rrst_n,       // Read increment, read clock, read reset
    output [DSIZE-1:0] rdata,       // Output data - data to be read
    output wfull,                   // Write full signal
    output rempty,                  // Read empty signal
    output [31:0] address_out
    );

      wire [ASIZE-1:0] waddr;
      wire [ASIZE-1:0] raddr;
      wire [ASIZE:0] wptr;
      wire [ASIZE:0] rptr;
      wire [ASIZE:0] wq2_rptr;
      wire [ASIZE:0] rq2_wptr; //wq2_rptr: from read to write rq2_wptr : from write to read  

    synch #(ASIZE) sync_r2w (       // Read pointer syncronization to write clock domain
        .q2(rq2_wptr),    // read to write
        .din(rptr),
        .clk(wclk), 
        .rst_n(wrst_n)
    );
    
    synch #(ASIZE) sync_w2r (       // Write pointer syncronization to read clock domain
        .q2(wq2_rptr),    // write to read 
        .din(wptr),
        .clk(rclk), 
        .rst_n(rrst_n)
    );

    
    memory #(DSIZE, ASIZE) fifomem(    // Memory module
        .rdata(rdata), 
        .wdata(wdata),
        .address(address),
        .waddr(waddr), 
        .raddr(raddr),
        .wclk_en(winc), 
        .wfull(wfull),
        .wclk(wclk),
        .rclk(rclk),
        .rclk_en(rinc),
        .rempty(rempty),
        .address_out(address_out)
    );

    read_operation #(ASIZE) rptr_empty(         // Read pointer and empty signal handling
        .rempty(rempty),
        .raddr(raddr),
        .rptr(rptr), 
        .wq2_rptr(wq2_rptr),
        .rinc(rinc), 
        .rclk(rclk),
        .rrst_n(rrst_n)
    );

    write_operation #(ASIZE) wptr_full(           // Write pointer and full signal handling
        .wfull(wfull), 
        .waddr(waddr),
        .wptr(wptr), 
        .rq2_wptr(rq2_wptr),
        .winc(winc), 
        .wclk(wclk),
        .wrst_n(wrst_n)
    );
endmodule
