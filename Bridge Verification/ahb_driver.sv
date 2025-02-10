`ifndef DRIVER_
`define DRIVER_
class ahb_driver extends uvm_driver#(ahb_seq_item);

  `uvm_component_utils(ahb_driver)

  virtual ahb_if  ahb_if0;

  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (uvm_config_db#(virtual ahb_if)::get(this, "", "ahb_vif", ahb_if0)) 
     `uvm_info(get_full_name(),"got interface in ahb driver",UVM_NONE)
     else
     `uvm_fatal(get_full_name(),"interface not found in ahb driver")
      
    
  endfunction

  
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req); 
      drive_transaction(req); 
      seq_item_port.item_done(); 
    end
  endtask

  
  virtual task drive_transaction(ahb_seq_item item);
  `uvm_info(get_full_name(),"DATA from AHB Driver",UVM_NONE)
    item.print();
    wait (ahb_if0.Hresetn == 1);
      `uvm_info(get_full_name(),"************************** AHB RESET ***************** ",UVM_NONE)
    @(posedge ahb_if0.Hclk);

    ahb_if0.HADDR_TEMP   <= item.HADDR_TEMP;
    ahb_if0.HBURST       <= item.HBURST;
    ahb_if0.HREADY       <= 1'b1;
    ahb_if0.HSEL         <= 1'b1;
    ahb_if0.HTRANS       <= item.HTRANS;
    ahb_if0.HWRITE       <= 1'b1;

    @(posedge ahb_if0.Hclk);

     ahb_if0.HWDATA       <= item.HWDATA;
    
  endtask

endclass

`endif