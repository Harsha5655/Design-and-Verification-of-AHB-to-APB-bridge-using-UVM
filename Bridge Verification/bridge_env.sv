`ifndef ENV_
`define ENV_
class bridge_env extends uvm_env;

  `uvm_component_utils(bridge_env)

  ahb_agent ahb_agnt;
  apb_agent apb_agnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ahb_agnt = ahb_agent::type_id::create("ahb_agnt", this);
    apb_agnt = apb_agent::type_id::create("apb_agnt", this);
  endfunction

endclass

`endif