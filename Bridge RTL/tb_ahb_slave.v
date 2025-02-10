`timescale 1ns / 1ps

module tb_ahb_slave;

    reg               HRESETn;
    reg               HCLK;
    reg               HSEL;
    reg    [31:0]     HADDR;
    reg               HWRITE;
    reg    [2:0]      HBURST;
    reg    [1:0]      HTRANS;
    reg               HREADY;
    reg    [31:0]     HWDATA;
    wire   [31:0]     HADDR_TEMP;
    wire   [31:0]     HWDATA_TEMP;
    wire              VALID;
    wire              HWRITE_TEMP;

    ahb_slave DUT (
        HRESETn, HCLK, HSEL, HADDR, HWRITE, HBURST, HTRANS, HREADY, HWDATA, 
        HADDR_TEMP, HWDATA_TEMP, VALID, HWRITE_TEMP
    );

    always #5 HCLK = ~HCLK;

    initial begin
        HRESETn = 0;
        HCLK = 0;
        HADDR = 0;
        HBURST = 0;
        HSEL = 0;
        HTRANS = 0;
        HWRITE = 0;
        HREADY = 0;
        HWDATA = 0;
        #10 HRESETn = 1;

        // Idle state
        #10 HSEL = 0;
            HTRANS = 2'b00;
            HREADY = 1;
        
        // Writing 16 transactions
        repeat (16) begin
            #10 HSEL = 1;
                HTRANS = 2'b10;
                HADDR = HADDR + 32'h00000004;
                HWRITE = 1;
                HWDATA = HWDATA + 32'h11111111;
                HBURST = 3'b000; // Single transfer
                HREADY = 1;
        end
        
        // Reading 16 transactions
        repeat (16) begin
            #10 HSEL = 1;
                HTRANS = 2'b10;
                HADDR = HADDR - 32'h00000004;
                HWRITE = 0;
                HBURST = 3'b000; // Single transfer
                HREADY = 1;
        end
        
        // Idle state
        #20 HSEL = 0;
            HTRANS = 2'b00;
            HREADY = 1;

        #500 $finish;
    end

endmodule
