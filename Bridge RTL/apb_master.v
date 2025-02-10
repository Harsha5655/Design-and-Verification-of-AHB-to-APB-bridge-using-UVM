`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.02.2025 21:39:28
// Design Name: 
// Module Name: apb_master
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


module APB_MASTER #(parameter DSIZE = 32, parameter ASIZE = 32)(
    // Global signals
    input  wire Presetn,           // Active-low reset
    input  wire Pclk,              // Clock signal
    
    // Controller inputs
    input  wire [ASIZE-1 :0] addr_temp,  // Address for APB transaction
    input  wire [DSIZE-1:0] data_temp,  // Data to be written
    input  wire [DSIZE-1:0] Prdata,     // Data read from the slave
    input  wire transfer,               // Transfer request signal
    input  wire Pready,                 // Slave ready signal
    input  wire write_enable,           // Signal to indicate read/write
    
    // Output signals
    output reg Psel,              // Slave select
    output reg [ASIZE-1:0] Paddr, // Address to APB slave
    output reg [DSIZE-1:0] Pdata, // Data to write to the slave
    output reg [DSIZE-1:0] rdata_temp, // Data read from the slave
    output reg Pwrite,            // Write control signal
    output reg Penable            // Enable signal
);

// State definitions
reg [1:0] present_state, next_state;
localparam IDLE   = 2'b00;
localparam SETUP  = 2'b01;
localparam ENABLE = 2'b10;

// Sequential block for state transitions
always @(posedge Pclk or negedge Presetn) begin
  if (!Presetn)
    present_state <= IDLE;  // Reset to IDLE state
  else
    present_state <= next_state;
end

// Next-state logic
always @(*) begin
  case (present_state)
    IDLE: begin
      if (transfer)
        next_state = SETUP; // Transition to SETUP on transfer request
      else
        next_state = IDLE;
    end
    SETUP: begin
      next_state = ENABLE; // Move to ENABLE after setup
    end
    ENABLE: begin
      if (Pready) begin
        if (transfer)
          next_state = SETUP; // Continue transaction if another transfer is requested
        else
          next_state = IDLE;  // Return to IDLE if no further transfer
      end else begin
        next_state = ENABLE;   // Stay in ENABLE until Pready is high
      end
    end
    default: next_state = IDLE;  // Default state
  endcase
end

// Output logic for each state
always @(*) begin
  if (!Presetn) begin
    // Reset all outputs to default values
    Psel       <= 1'b0;
    Penable    <= 1'b0;
    Paddr      <= 32'b0; // Corrected to ASIZE-2 for address width
    Pdata      <= 32'b0;
    rdata_temp <= 32'b0;
    Pwrite     <= 1'b0;
  end else begin
    case (present_state)
      IDLE: begin
        Psel    <= 1'b0;   // Deactivate slave selection
        Penable <= 1'b0;   // Disable transactions
      end
      SETUP: begin
        Psel    <= 1'b1;              // Select the slave
        Penable <= 1'b0;              // Disable transactions during setup
        //Paddr   <= addr_temp;         // Assign address
        Pwrite  <= write_enable;      // Set write control based on external signal
      end
      ENABLE: begin
        Penable <= 1'b1;              // Enable transactions
        Psel<=1'b1;
        if (Pready) begin
          if (Pwrite) begin
            Paddr   <= addr_temp; 
            Pdata      <= data_temp;  // Write data to slave
            rdata_temp <= 32'b0;     // Clear read data
          end else begin
            rdata_temp <= Prdata;     // Capture read data from slave
            Pdata      <= 32'b0;  // Clear write data
          end
        end
      end
    endcase
  end
end

endmodule