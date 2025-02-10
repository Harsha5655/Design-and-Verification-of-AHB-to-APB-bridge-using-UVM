`ifndef AGENT_
`define AGENT_
class ahb_agent extends uvm_agent;

  `uvm_component_utils(ahb_agent)

  ahb_driver    driver;
  ahb_sequencer sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver = ahb_driver::type_id::create("driver", this);
    sequencer = ahb_sequencer::type_id::create("sequencer", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass
`endif














