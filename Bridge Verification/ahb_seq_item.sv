`ifndef SEQ_   
`define SEQ_

class ahb_seq_item extends uvm_sequence_item;
     
                  
                  
                   rand   bit [31:0]   HADDR_TEMP;
                   rand bit [1:0 ]   HBURST;
                   rand bit [1:0 ]   HTRANS;
                   rand   bit [31:0]   HWDATA;
                   rand bit          HWRITE;
                  // rand bit [2:0]   HSIZE;                 

 


  `uvm_object_utils_begin(ahb_seq_item)
    
    `uvm_field_int(HADDR_TEMP, UVM_ALL_ON)
    `uvm_field_int(HBURST, UVM_ALL_ON)
    `uvm_field_int(HTRANS,UVM_ALL_ON)
    `uvm_field_int(HWDATA,UVM_ALL_ON)
    `uvm_field_int(HWRITE,UVM_ALL_ON) 
    //`uvm_field_int(HSIZE, UVM_ALL_ON)  
  `uvm_object_utils_end


  function new(string name = "ahb_seq_item");
    super.new(name);
  endfunction

endclass


`endif