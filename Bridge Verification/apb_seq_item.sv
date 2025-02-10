`ifndef SEQUENCE_ITEM
`define SEQUENCE_ITEM
class apb_seq_item extends uvm_sequence_item;

                    bit [31:0]        Paddr;
                    bit [31:0]       Pdata;
                    bit         Penable;
                    bit         Psel;
                    bit         Pwrite;
                    bit [31:0]        rdata_temp;
                    bit         rempty;
                    bit         wfull;      
  

  
  `uvm_object_utils_begin(apb_seq_item)
    `uvm_field_int(Paddr, UVM_ALL_ON)
    `uvm_field_int(Pdata, UVM_ALL_ON)
    `uvm_field_int(Penable, UVM_ALL_ON)
    `uvm_field_int(Psel, UVM_ALL_ON)
    `uvm_field_int(Pwrite,UVM_ALL_ON)
    `uvm_field_int(rdata_temp, UVM_ALL_ON)
    `uvm_field_int(rempty, UVM_ALL_ON)
    `uvm_field_int(wfull, UVM_ALL_ON)
    

  `uvm_object_utils_end

  
  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction

endclass


`endif