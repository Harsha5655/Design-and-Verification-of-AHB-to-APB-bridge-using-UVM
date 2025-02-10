`ifndef TEST_
`define TEST_
class bridge_test extends uvm_test;

  `uvm_component_utils(bridge_test)

  bridge_env env;
  ahb_sequence ahb_seq;
  //apb_sequence apb_seq;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = bridge_env::type_id::create("env", this);
    ahb_seq = ahb_sequence::type_id::create("ahb_seq");
    //apb_seq = apb_sequence::type_id::create("apb_seq");
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    ahb_seq.start(env.ahb_agnt.sequencer);
    //apb_seq.start(env.apb_agnt.sequencer);
    phase.drop_objection(this);
  endtask

endclass
`endif






















