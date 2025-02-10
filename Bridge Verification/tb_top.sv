`include "uvm_macros.svh"
import uvm_pkg::*;
      

`include "top_wrapper.v"      
`include "ahb_intf.sv"         
`include "apb_intf.sv"         


`include "ahb_seq_item.sv"    
`include "ahb_sequence.sv"    
`include "ahb_driver.sv"      
`include "ahb_sequencer.sv"   
`include "ahb_agent.sv"       

`include "apb_driver.sv"      
`include "apb_agent.sv"      

`include "bridge_env.sv"     
`include "test.sv"    





typedef class bridge_test;
typedef class bridge_env;
typedef class ahb_agent;
typedef class apb_agent;
typedef class ahb_driver;
typedef class apb_driver;
typedef class ahb_sequencer;
typedef class ahb_seq_item;
typedef class ahb_sequence;


module testbench_top;

  logic HRESETn; 
  logic HCLK;   
  logic Presetn; 
  logic Pclk;    


  initial begin
    HCLK = 0;
    forever #5 HCLK = ~HCLK; 
  end


  initial begin
    Pclk = 0;
    forever #10 Pclk = ~Pclk;
  end

  
  initial begin
    HRESETn = 0; 
    Presetn = 0; 
    #20;        
    HRESETn = 1; 
    Presetn = 1; 
  end

  initial begin
    #1000 $finish;
  end

  ahb_if ahb_if0(); 
  apb_if apb_if0(); 

  
  top_wrapper dut (
    
    .Pclk(apb_if0.Pclk),
    .Pready(apb_if0.Pready),
    .HADDR_TEMP(ahb_if0.HADDR_TEMP),
    .HBURST(ahb_if0.HBURST),
    .Hclk(ahb_if0.Hclk),
    .HREADY(ahb_if0.HREADY),
    .Hresetn(ahb_if0.Hresetn),
    .HSEL(ahb_if0.HSEL),
    .HTRANS(ahb_if0.HTRANS),
    .HWDATA(ahb_if0.HWDATA),
    .HWRITE(ahb_if0.HWRITE),
    .Presetn(apb_if0.Presetn),
    //.rinc(ahb_if0.rinc),
    //.write_enable(ahb_if0.write_enable),
    .Paddr(apb_if0.Paddr),
    .Pdata(apb_if0.Pdata),
    .Penable(apb_if0.Penable),
    .Psel(apb_if0.Psel),
    .Pwrite(apb_if0.Pwrite),
    .rdata_temp(apb_if0.rdata_temp)
    //.rempty(apb_if0.rempty),
    //.wfull(apb_if0.wfull)

  );

  assign ahb_if0.Hclk=HCLK;
  assign ahb_if0.Hresetn=HRESETn;
  assign apb_if0.Pclk=Pclk;
  assign apb_if0.Presetn=Presetn;
  initial begin

    uvm_config_db#(virtual ahb_if)::set(null, "uvm_test_top.env.ahb_agnt.driver", "ahb_vif", ahb_if0);


    uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top.env.apb_agnt.driver", "apb_vif", apb_if0);

    run_test("bridge_test"); 
  end

  

endmodule