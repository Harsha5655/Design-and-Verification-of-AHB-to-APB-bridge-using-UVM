`ifndef INTF_
`define INTF_

interface ahb_if();

                     //logic          Pclk;
                    // logic          Pready;
                     logic [31:0]   HADDR_TEMP;
                     logic [1:0 ]   HBURST;
                     logic          Hclk;
                     logic          HREADY;
                     logic          Hresetn;
                     logic          HSEL;
                     logic [1:0 ]   HTRANS;
                     logic [31:0]   HWDATA;
                     logic          HWRITE;
                    // logic          Presetn;
                   //  logic          rinc;
                   //  logic          write_enable;

endinterface

`endif