`ifndef DRIVER_H
  `define DRIVER_H

class apb_driver extends uvm_driver;

  `uvm_component_utils(apb_driver)


  virtual apb_if  apb_if0;


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (uvm_config_db#(virtual apb_if)::get(this, "", "apb_vif", apb_if0)) 
      `uvm_info(get_full_name(), "got interface in apb driver",UVM_NONE)
      else
      `uvm_fatal(get_full_name(),"interface not found in apb driver")
  
  endfunction

  virtual task run_phase(uvm_phase phase);
   begin
      //seq_item_port.get_next_item(req); 
       
      drive_transaction(); 
     // seq_item_port.item_done(); 
    end
  endtask

  virtual task drive_transaction();
  `uvm_info(get_full_name(),"DATA from APB Driver",UVM_NONE)
    // item.print();
   @(posedge apb_if0.Pclk); //iff (apb_if0.Psel && apb_if0.Penable));

    // item.Paddr      = apb_if0.Paddr;
    // item.Pdata      = apb_if0.Pdata;
    // item.Penable     = apb_if0.Penable;
    // item.Psel       = apb_if0.Psel;
    // item.Pwrite    = apb_if0.Pwrite;
    // item.wfull      = apb_if0.wfull;      
    // item.rempty     = apb_if0.rempty;     
    // item.rdata_temp = apb_if0.rdata_temp; 
  endtask

endclass
























  `endif