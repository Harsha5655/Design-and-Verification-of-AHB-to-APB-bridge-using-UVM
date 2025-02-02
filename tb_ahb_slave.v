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



                  ahb_slave DUT(HRESETn, HCLK,HSEL, HADDR,HWRITE,HBURST, HTRANS, HREADY, HWDATA, HADDR_TEMP, HWDATA_TEMP, VALID,  HWRITE_TEMP);


                always #5 HCLK=~HCLK;
                initial begin
                    HRESETn=0;
                    HCLK=0;
                    HADDR=0;
                    HBURST=0;
                    HSEL=0;
                    HTRANS=0;
                    HWRITE=0;
                    HREADY=0;
                    HWDATA=0;
                    HRESETn=1;

                    //idle
                   #10 HSEL = 0;
                   HTRANS = 2'b00;
                   HREADY = 1;

                   //nonseq transfer
                    #10 HSEL = 1;
                     HTRANS = 2'b10;
                     HADDR = 32'hA000_0000;
                     HWRITE = 1;
                     HWDATA = 32'h1234_5678;
                     HBURST = 2'b00; 
                     HREADY = 1;

                     //seq transfer
                      #20 HTRANS = 2'b11;
                      HADDR = 32'hA000_0004;
                      HWRITE = 1;
                      HWDATA = 32'h5678_1234;
                      HBURST = 2'b01; //increment 1
                      HREADY = 1;

                      //busy
                       #20 HTRANS = 2'b01;
                       HREADY = 0;

                       //incremental 4 transfer
                        #20 HTRANS = 2'b11;
                            HADDR = 32'hA000_0008;
                            HWRITE = 1;
                            HWDATA = 32'hABCD_EF01;
                            HBURST = 3'b010; // Incremental 4
                           HREADY = 1;

                        //incremental 8 transfer
                         #40 HTRANS = 2'b11;
                             HADDR = 32'hA000_0010;
                             HWRITE = 1;
                             HWDATA = 32'hFEDC_BA98;
                             HBURST = 3'b011; // Incremental 8
                             HREADY = 1;

                            //idle
                            #20 HSEL = 0;
                         HTRANS = 2'b00;
                       HREADY = 1;

        
        #100 $finish;
    end
            
endmodule