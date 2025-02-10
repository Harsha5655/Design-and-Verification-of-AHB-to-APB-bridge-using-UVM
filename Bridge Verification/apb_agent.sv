`ifndef AGENT_H
 `define AGENT_H
class apb_agent extends uvm_agent;

  `uvm_component_utils(apb_agent)

  //apb_sequencer sequencer;
  apb_driver    driver;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   // sequencer = apb_sequencer::type_id::create("sequencer", this);
    driver    = apb_driver::type_id::create("driver", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   // driver.seq_item_port.connect(sequencer.seq_item_export); 
  endfunction

endclass

 `endif