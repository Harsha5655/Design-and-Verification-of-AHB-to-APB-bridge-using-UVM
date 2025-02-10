`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2025 03:03:12
// Design Name: 
// Module Name: tb_APB_MASTER
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module apb_master_tb;

// Testbench Signals
reg Presetn;
reg Pclk;
reg [30:0] addr_temp;   // Address for APB transaction (ASIZE-2:0)
reg [31:0] data_temp;   // Data to be written
reg [31:0] Prdata;      // Data read from the slave
reg transfer;
reg Pready;
reg write_enable;

wire Psel;
wire [30:0] Paddr;
wire [31:0] Pdata;
wire [31:0] rdata_temp;
wire Pwrite;
wire Penable;

// Instantiate the DUT 
APB_MASTER #(32, 32) dut (
    .Presetn(Presetn),
    .Pclk(Pclk),
    .addr_temp(addr_temp),
    .data_temp(data_temp),
    .Prdata(Prdata),
    .transfer(transfer),
    .Pready(Pready),
    .write_enable(write_enable),
    .Psel(Psel),
    .Paddr(Paddr),
    .Pdata(Pdata),
    .rdata_temp(rdata_temp),
    .Pwrite(Pwrite),
    .Penable(Penable)
);

// Clock Generation
initial begin
  Pclk = 0;
  forever #5 Pclk = ~Pclk;  // Generate a 10ns clock period (100MHz)
end

// Test Sequence
initial begin
  // Initialize inputs
  Presetn = 0;
  addr_temp = 31'b0;
  data_temp = 32'b0;
  Prdata = 32'b0;
  transfer = 0;
  Pready = 0;
  write_enable = 0;
    
  // Apply Reset
  #20 Presetn = 1;  // Hold reset for 20ns for proper initialization

  // Wait for a few cycles
  #10;

  // Test 1: Write Operation
  $display("\nStarting Write Operation...");
  addr_temp = 31'h0000_0000;        // Set address
  data_temp = 32'hDEADBEEF;         // Data to write
  write_enable = 1;                 // Indicate write operation
   transfer = 1;                      // Start transaction
  #10 Pready = 1;                    // Set Pready high (slave ready)
    
  #20 transfer = 0;                   // End transfer
  Pready = 0;

  // Wait for a few cycles
  #20;

  // Test 2: Read Operation
  $display("\nStarting Read Operation...");
  addr_temp = 31'h0000_0004;        // Set address for read
  write_enable = 0;                 // Indicate read operation
  Prdata = 32'h12345678;            // Data from slave
  transfer = 1;                      // Start transaction
  #10 Pready = 1;                    // Set Pready high
    
  #20 transfer = 0;                   // End transfer
  Pready = 0;

  // Wait for a few cycles
  #20;

  // Test 3: No Transfer (Idle State)
  $display("\nTesting Idle State...");
  transfer = 0;
  addr_temp = 31'b0;
  data_temp = 32'b0;
  Pready = 0;

  // Wait for a few cycles
  #50;

  // End simulation
  $display("\nSimulation Complete.");
  $finish;
end

// Monitor Outputs
initial begin
  $monitor("Time = %0t | Pclk = %b | Presetn = %b  | Psel = %b | Paddr = 0x%h | Pdata = 0x%h | rdata_temp = 0x%h | Pwrite = %b | Penable = %b", 
  $time, Pclk, Presetn,Psel, Paddr, Pdata, rdata_temp, Pwrite, Penable);
end

endmodule