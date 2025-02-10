`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.02.2025 16:26:16
// Design Name: 
// Module Name: fifo_tb
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


module tb_top
#(parameter DSIZE =6,ASIZE=4)();

    reg [DSIZE-1:0] wdata;   // Input data
    reg winc;
    reg rinc;
    reg wclk;
    reg rclk;
    reg wrst_n;
    reg rrst_n; // Write and read signals
    wire [DSIZE-1:0] rdata;  // Output data
    wire wfull;
    wire rempty; 
    
   
 top #(     
    .DSIZE(DSIZE),
    .ASIZE(ASIZE)
) DUT
(
        .rdata(rdata), 
        .wdata(wdata),
        .wfull(wfull),
        .rempty(rempty),
        .winc(winc), 
        .rinc(rinc), 
        .wclk(wclk), 
        .rclk(rclk), 
        .wrst_n(wrst_n), 
        .rrst_n(rrst_n)
     );
   
     always #5 wclk = ~wclk;   // Generate 100 MHz clock
     always #10 rclk = ~rclk;  // Generate 50 MHz clock

     
initial begin
        wrst_n = 0; rrst_n = 0;
        wclk = 1; rclk = 1;
        winc = 0; rinc = 0;
        wdata = 0;
        
        #20 wrst_n = 1;   rrst_n = 1;  
    end
    
//    initial begin
//        #30;     // Ensure data has been written before reading
//        repeat(17) begin
//            @(posedge rclk);
//            if (!rempty) begin
//                rinc = 1;
//            end
//        end
//        rinc = 0;
//    end
    
//    initial begin
//        #200;     // Ensure reset has been deasserted before starting writes
//        repeat(17) begin
//            @(posedge wclk);
//            if (!wfull) begin
//                winc = 1;
//                wdata = $random;
//            end
//        end
//        winc = 0;
//    end
    
  initial begin
        #30;     // Ensure reset has been deasserted before starting writes
         repeat(20) begin
        @(posedge wclk);
        if (!wfull) begin
            winc = 1;       // Enable write
            wdata = $random;
            @(posedge wclk); // Wait for the next clock cycle
            winc = 0;       // Disable write to prevent duplicate writes
        end
    end
end


    
     initial begin
        #500;     // Ensure data has been written before reading
        repeat(20) begin
            @(posedge rclk);
            if (!rempty) begin
                rinc = 1;
            end
        end
        rinc = 0;
    end
    
    initial begin
        #1000;
        $finish;
    end

         
endmodule
