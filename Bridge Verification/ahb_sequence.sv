`ifndef SEQUENCE_
`define SEQUENCE_

class ahb_sequence extends uvm_sequence#(ahb_seq_item);

  `uvm_object_utils(ahb_sequence)

  function new(string name = "ahb_sequence");
    super.new(name);
  endfunction

  virtual task body();
    ahb_seq_item item;

    repeat (100)
     begin 
      item = ahb_seq_item::type_id::create("item");
      start_item(item);
      assert(item.randomize());
      `uvm_info("","sequence random in ahb",UVM_NONE)
      item.print();
      finish_item(item);
    end
  endtask

endclass



`endif