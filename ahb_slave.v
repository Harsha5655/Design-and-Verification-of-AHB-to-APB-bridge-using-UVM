`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.01.2025 15:54:14
// Design Name: 
// Module Name: ahb_slave
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


module ahb_slave(input               HRESETn,
                 input               HCLK,
                 input               HSEL,
                 input [31:0]        HADDR,
                 input               HWRITE,
                 input[1:0]          HBURST,
                 input[1:0]          HTRANS,
                 input               HREADY,
                 input[31:0]         HWDATA,
                 output reg [31:0]   HADDR_TEMP,
                 output reg [31:0]   HWDATA_TEMP,
                 output reg          VALID,
                 output reg          HWRITE_TEMP);

parameter IDLE = 2'b00;
parameter BUSY = 2'b01;
parameter NONSEQ=2'b10;
parameter SEQ=2'b11;

reg [1:0] present_state, next_state;
reg [31:0] addr, data;

always@(posedge HCLK )
begin
    if(~HRESETn)
    begin
        addr <= 0;
        data <= 0;
    end

    else
    begin
        addr <=HADDR;
        data <=HWDATA;
    end

end

always@(posedge HCLK) //present state logic
begin
    if(~HRESETn)
        present_state <= IDLE;
    else
        present_state <= next_state;
end


always@(*)//next state logic
begin
    case(present_state)
        IDLE:
        begin
            if(HSEL && HTRANS==2'b01)
                next_state = BUSY;
            else if(HSEL &&  (HTRANS==2'b10 || HTRANS==2'b11) && HREADY) begin
                next_state = NONSEQ;
                end
            else
                next_state = IDLE;
        end

        BUSY:
        begin
            if(HSEL && HTRANS==2'b10 && HREADY)
                next_state = NONSEQ;
            else if(HSEL && HTRANS==2'b01 || !HREADY)
                next_state = BUSY;
            else
                next_state = IDLE;
        end
               
        NONSEQ:
        begin
            if(HSEL && (HTRANS==2'b10 || HTRANS==2'b11) && HREADY)
                next_state = SEQ;
            else if(HSEL && HTRANS==2'b01 || !HREADY)
                next_state = BUSY;
            else
                next_state = IDLE;
        end
            

        SEQ:
        begin
            if(~HSEL || HTRANS==2'b00 )
                next_state = IDLE;
            else if(HSEL && HTRANS==2'b01 ||  (!HREADY))
                next_state = BUSY;
            else begin
                case(HBURST)
                    2'b00: next_state = NONSEQ;//single transfer
                    2'b01: next_state = SEQ;//increment transfer
                    2'b10:if(HADDR_TEMP < HADDR+4)
                          next_state = SEQ;
                          else
                            next_state = NONSEQ;
                    2'b11:if(HADDR_TEMP < HADDR+8)
                          next_state = SEQ;
                          else
                            next_state = NONSEQ;
                    default: next_state = IDLE;
                endcase
            end
           
end
endcase
end


always@(posedge HCLK) //output logic
begin
    case(present_state)
    IDLE:begin      //idle state
    VALID<=1'b0;
    HADDR_TEMP<=1'b0;
    HWDATA_TEMP<=1'b0;
    HWRITE_TEMP<=1'b0;
    end
  
  BUSY:begin   //busy state
      VALID<=VALID;
      HADDR_TEMP<=HADDR_TEMP;
      HWDATA_TEMP<=HWDATA_TEMP;
      HWRITE_TEMP<=HWRITE_TEMP;
  end

  NONSEQ:begin //NONSEQ transfer
         VALID<=VALID;
         HADDR_TEMP<=addr;
         if(HBURST==2'b00)
         begin
         HWDATA_TEMP<=data;
         HWRITE_TEMP<=HWRITE;
        end
        else begin
        HWDATA_TEMP<=HWDATA_TEMP;
         HWRITE_TEMP<=HWRITE_TEMP;
        end
  end

  SEQ:begin //seq transfer
      case(HBURST)

      2'b00:begin //single transfer
      VALID<=1'b1;
      HADDR_TEMP<=HADDR_TEMP;
      HWDATA_TEMP<=data;
      HWRITE_TEMP<=HWRITE;
     end

     2'b01:begin // incremental 1 transfer
     VALID<=1'b1;
      HADDR_TEMP<=HADDR_TEMP+1;
      HWDATA_TEMP<=data;
      HWRITE_TEMP<=HWRITE;
    end

    2'b10:begin //incremental 4 transfer
    if(HADDR_TEMP<(HADDR +4)) begin
    VALID<=1'b1;
    HADDR_TEMP<=HADDR_TEMP+1;
    HWDATA_TEMP<=data;
    HWRITE_TEMP<=HWRITE;
    end
    else begin
    VALID<=1'b1;
    HADDR_TEMP<=addr;
    HWDATA_TEMP<=data;
    HWRITE_TEMP<=HWRITE;
    end
    end

   2'b11:begin //incremental 8 transfer
    if(HADDR_TEMP<(HADDR +8)) begin
    VALID<=1'b1;
    HADDR_TEMP<=HADDR_TEMP+1;
    HWDATA_TEMP<=data;
    HWRITE_TEMP<=HWRITE;
    end
    else begin
    VALID<=1'b1;
    HADDR_TEMP<=addr;
    HWDATA_TEMP<=data;
    HWRITE_TEMP<=HWRITE;
    end
    end

    default:begin
    VALID<=1'b0;
    HADDR_TEMP<=1'b0;
    HWDATA_TEMP<=1'b0;
    HWRITE_TEMP<=1'b0;
    end
    
   endcase
    end


    endcase
end


endmodule


