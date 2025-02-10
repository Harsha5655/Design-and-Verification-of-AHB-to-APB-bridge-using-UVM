`ifndef INTF_H
  `define INTF_H
interface apb_if();
   logic              Pclk;
   logic              Presetn;
   logic               Pready;                  
  logic [31:0]        Paddr;
  logic [31:0]        Pdata;
  logic               Penable;
  logic               Psel;
  logic               Pwrite;
  logic [31:0]        rdata_temp;
  logic               rempty;
  logic               wfull;
 
endinterface
`endif