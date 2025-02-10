`timescale 1ns / 1ps

module ahb_slave(
                 input               HRESETn,
                 input               HCLK,
                 input               HSEL,
                 input [31:0]        HADDR,
                 input               HWRITE,
                 input [1:0]         HBURST,
                 input [1:0]         HTRANS,
                 input               HREADY,
                 input [31:0]        HWDATA,
                 //input [31:0]        HRDATA,
                 output reg [31:0]   HADDR_TEMP,
                 output reg [31:0]   HWDATA_TEMP,
                 output reg          VALID,
                 output reg          HWRITE_TEMP);

parameter IDLE = 2'b00;
parameter BUSY = 2'b01;
parameter NONSEQ = 2'b10;
parameter SEQ = 2'b11;

reg [1:0] present_state, next_state;
reg [31:0] addr, data;

// Capture HADDR and HWDATA on the clock edge
always @(posedge HCLK) begin
    if (~HRESETn) begin
        addr <= 0;
        data <= 0;
    end else begin
        addr <= HADDR;
        data <= HWDATA;
    end
end

// State transition logic
always @(posedge HCLK) begin
    if (~HRESETn)
        present_state <= IDLE;
    else
        present_state <= next_state;
end

// Next state logic
always @(*) begin
    case (present_state)
        IDLE: begin
            if (HSEL && HTRANS == 2'b01)
                next_state = BUSY;
            else if (HSEL && (HTRANS == 2'b10 || HTRANS == 2'b11) && HREADY)
                next_state = NONSEQ;
            else
                next_state = IDLE;
        end

        BUSY: begin
            if (HSEL && HTRANS == 2'b10 && HREADY)
                next_state = NONSEQ;
            else if (HSEL && HTRANS == 2'b01 || !HREADY)
                next_state = BUSY;
            else
                next_state = IDLE;
        end

        NONSEQ: begin
            if (HSEL && (HTRANS == 2'b10 || HTRANS == 2'b11) && HREADY)
                next_state = SEQ;
            else if (HSEL && HTRANS == 2'b01 || !HREADY)
                next_state = BUSY;
            else
                next_state = IDLE;
        end

        SEQ: begin
            if (~HSEL || HTRANS == 2'b00)
                next_state = IDLE;
            else if (HSEL && HTRANS == 2'b01 || !HREADY)
                next_state = BUSY;
            else begin
                case (HBURST)
                    2'b00: next_state = NONSEQ; // single transfer
                    2'b01: next_state = SEQ;   // increment transfer
                    2'b10: if (HADDR_TEMP < addr + 4)
                              next_state = SEQ;
                           else
                              next_state = NONSEQ;
                    2'b11: if (HADDR_TEMP < addr + 8)
                              next_state = SEQ;
                           else
                              next_state = NONSEQ;
                    default: next_state = IDLE;
                endcase
            end
        end
    endcase
end

// Output logic
always @(posedge HCLK) begin
    if (~HRESETn) begin
        VALID <= 1'b0;
        HADDR_TEMP <= 0; // Initialize to 0
        HWDATA_TEMP <= 0;
        HWRITE_TEMP <= 0;
    end else begin
        case (present_state)
            IDLE: begin
                VALID <= 1'b0;
                HADDR_TEMP <= 0; // Reset to 0 in IDLE state
                HWDATA_TEMP <= 0;
                HWRITE_TEMP <= 0;
            end

            BUSY: begin
                VALID <= 1'b0; // No valid data in BUSY state
                HADDR_TEMP <= HADDR_TEMP; // Hold address
                HWDATA_TEMP <= HWDATA_TEMP;
                HWRITE_TEMP <= HWRITE_TEMP;
            end

            NONSEQ: begin
                VALID <= 1'b1; // Valid data in NONSEQ state
                HADDR_TEMP <= addr; // Capture the current address
                HWDATA_TEMP <= data; // Capture the current data
                HWRITE_TEMP <= HWRITE; // Capture the write signal
                $display("NONSEQ: HADDR_TEMP = %0h, HADDR = %0h", HADDR_TEMP, addr); // Debugging
            end

            SEQ: begin
                VALID <= 1'b1; // Valid data in SEQ state
                case (HBURST)
                    2'b00: begin // Single transfer
                        HADDR_TEMP <= addr; // No increment
                        HWDATA_TEMP <= data;
                        HWRITE_TEMP <= HWRITE;
                    end

                    2'b01: begin // Increment by 1
                        HADDR_TEMP <= HADDR_TEMP + 1; // Increment address
                        HWDATA_TEMP <= data;
                        HWRITE_TEMP <= HWRITE;
                    end

                    2'b10: begin // Increment by 4
                        if (HADDR_TEMP < addr + 4) begin
                            HADDR_TEMP <= HADDR_TEMP + 1; // Increment address
                        end else begin
                            HADDR_TEMP <= addr; // Reset to base address
                        end
                        HWDATA_TEMP <= data;
                        HWRITE_TEMP <= HWRITE;
                    end

                    2'b11: begin // Increment by 8
                        if (HADDR_TEMP < addr + 8) begin
                            HADDR_TEMP <= HADDR_TEMP + 1; // Increment address
                        end else begin
                            HADDR_TEMP <= addr; // Reset to base address
                        end
                        HWDATA_TEMP <= data;
                        HWRITE_TEMP <= HWRITE;
                    end

                    default: begin
                        HADDR_TEMP <= 0;
                        HWDATA_TEMP <= 0;
                        HWRITE_TEMP <= 0;
                    end
                endcase
                $display("SEQ: HADDR_TEMP = %0h, HADDR = %0h", HADDR_TEMP, addr); // Debugging
            end
        endcase
    end
end

endmodule