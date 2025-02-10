`timescale 1ns / 1ps

module tb_top_bridge();
    // Signals
    //reg wdata;
    reg HSEL;
    reg HWRITE;
    reg [1:0] HBURST;
    reg [1:0] HTRANS;
    reg HREADY;
    reg write_enable;
    reg Pready;
    reg [31:0] HADDR_TEMP;
    reg [31:0] HWDATA;
    reg winc;
    reg wclk;
    reg wrst_n;
    reg transfer;
    reg rclk;
    reg rrst_n;
    
    wire wfull;
    wire rempty;
    wire Psel;
    wire [31:0] Paddr;
    wire [31:0] Pdata;
    wire [31:0] rdata_temp;
   // wire [31:0] memory_data;
    wire Pwrite;
    wire Penable;

    // Instantiate DUT
    top_bridge DUT(
        .HSEL(HSEL),
        .HWRITE(HWRITE),
        .HBURST(HBURST),
        .HTRANS(HTRANS),
        .HREADY(HREADY),
        .write_enable(write_enable),
        .Pready(Pready),
        .HADDR_TEMP(HADDR_TEMP),
        .HWDATA(HWDATA),
        //.winc(winc),
        .wclk(wclk),
        .wrst_n(wrst_n),
        .transfer(transfer),
        .rclk(rclk),
        .rrst_n(rrst_n),
        .wfull(wfull),
        .rempty(rempty),
        .Psel(Psel),
        .Paddr(Paddr),
        .Pdata(Pdata),
        .rdata_temp(rdata_temp),
        //.memory_data(memory_data),
        .Pwrite(Pwrite),
        .Penable(Penable)
    );

    

    // Clock generation
    always #5 wclk = ~wclk;   // 100 MHz
    always #10 rclk = ~rclk;  // 50 MHz

    // Initialization
    initial begin
        wrst_n = 0; rrst_n = 0;
        wclk = 1; rclk = 1;
        winc = 0; transfer = 0;
        HWDATA = 32'h00000000;
        Pready = 0;
        write_enable = 0;
        HADDR_TEMP = 32'h00000000;
        HBURST = 3'b000;
        HSEL = 0;
        HTRANS = 2'b00;
        HWRITE = 0;
        HREADY = 0;
        
        #20 wrst_n = 1; rrst_n = 1;//HADDR_TEMP = 32'h00000000;
        #10 HSEL = 0;
        HTRANS = 2'b00;
        HREADY = 1;
    end
// AHB TRANSACTIONS
    // Write Transactions
    initial begin 
    #10; // Wait for initialization
    repeat (15) begin
        #10 HSEL = 1;
            HTRANS = 2'b10; // NONSEQ transfer
            HWRITE = 1;     // Write operation
            HWDATA = HWDATA + 32'h11111111; // Increment data
            HBURST = 3'b000; // Single transfer
            HREADY = 1;
            $display("Testbench: HADDR_TEMP = %0h, HWDATA = %0h", HADDR_TEMP, HWDATA);
            HADDR_TEMP = HADDR_TEMP + 32'h00000001; // Increment address after transaction
    end
end
       
    
      // read transactions
   initial begin
   #100;
    repeat (15) begin
            #10 HSEL = 1;
                HTRANS = 2'b10;
                //HADDR_TEMP = HADDR_TEMP - 32'h00000001;
                HWRITE = 1;
                HBURST = 3'b000; // Single transfer
                HREADY = 1;
        end
        
        // Idle state
        #20 HSEL = 0;
            HTRANS = 2'b00;
            HREADY = 1;
   end
    // FIFO Read & APB Transaction Control
    initial begin
        #330;  // Ensure writes are done before reads
        Pready = 1;
        write_enable = 1;
        repeat (16) begin
            @(posedge rclk);
            if (!rempty) begin
                transfer = 1;
            end
        end
        //#1500 $stop();
    end

endmodule
