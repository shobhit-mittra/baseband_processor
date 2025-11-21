`timescale 1ns / 1ps

module uart_rx(
    input clk,
    input rst_n,
    input uart_rx_i,

    output reg rec_full_byte,  // A full byte has been received
    output reg [7:0] text_msg_chara
);

    reg [13:0] baud_time_counter; // counts clock ticks to measure the duration of one bit period
    reg [3:0] bit_counter; // 10 bits for transferring a whole byte
    reg en_baud_counter; // enables counting when a UART frame is being received
    wire neg_uart_rx; // single-cycle pulse that detects the falling edge of the start bit


localparam integer FULL_BAUD = 10417;
localparam integer HALF_BAUD  = FULL_BAUD >> 1; // Divide Baud cycle by 2 using arithmetic right shift
localparam integer data_bit = 8;

// local params adjusted to counting from 0 to (param - 1) to get the full param width
localparam integer true_FULL_BAUD = FULL_BAUD - 1;
localparam integer true_HALF_BAUD = HALF_BAUD - 1;
localparam integer true_data_bit = data_bit - 1;

// FSM states
localparam IDLE    = 3'd0,
           START   = 3'd1,
           RECEIVE = 3'd2,
           STOP    = 3'd3,
           DONE    = 3'd4;

reg [2:0] rx_state;

// two-stage synchroniser for async input
reg sync_0, sync_1, sync_prev;

assign neg_uart_rx = (sync_prev == 1'b1) && (sync_1 == 1'b0); // pulse goes high when negative edge is seen

// storage for sampled bits
reg [7:0] data_shift;

// make rec_full_byte default to low
always @(posedge clk) begin
  if (!rst_n) 
  begin
    // defaulted values to high : Idle state
    sync_0 <= 1'b1;
    sync_1 <= 1'b1;
    sync_prev <= 1'b1;
  end 
  else 
  begin
    // update synchroniser (clocked)
    sync_0 <= uart_rx_i;
    sync_1 <= sync_0;
    sync_prev <= sync_1;
  end
end

// FSM Logic
always @(posedge clk) 
    begin
        if (!rst_n) 
            begin
                rx_state <= IDLE;
                baud_time_counter <= 0;
                bit_counter <= 0;
                data_shift <= 8'd0;
                rec_full_byte <= 1'b0;
                text_msg_chara <= 8'd0;
                en_baud_counter <= 1'b0;
            end 
    
        else 
            begin
            // default: clear one-cycle signals
                rec_full_byte <= 1'b0;

                case (rx_state)
                    // IDLE
                    IDLE: 
                        begin
                            en_baud_counter <= 1'b0;
                            baud_time_counter <= 0;
                            bit_counter <= 0;
                            // waiting for falling edge (start bit)
                            if (neg_uart_rx) 
                                begin
                                    // start half-bit timer
                                    baud_time_counter <= 0;
                                    en_baud_counter <= 1'b1;
                                    rx_state <= START;
                                end
                        end

                    // START (wait half-baud)
                    START: 
                        begin
                            if (en_baud_counter) 
                                begin
                                   if (baud_time_counter == true_HALF_BAUD) 
                                        begin
                                            // reached middle of start bit then prepare for first data bit
                                            baud_time_counter <= 0;
                                            bit_counter <= 0;
                                            rx_state <= RECEIVE;
                                        end 
                            	
                                   else 
                                        begin
                                            baud_time_counter <= baud_time_counter + 1;
                                        end 
                                end
                        end

                    // RECEIVE (sample 8 data bits) 
                    RECEIVE: 
                        begin
                            if (en_baud_counter) 
                                begin
                                    if (baud_time_counter == true_FULL_BAUD) 
                                        begin
                                        // Full BAUD after start-bit elapsed 
                                            data_shift[bit_counter] <= sync_1;
          
                                            if (bit_counter < true_data_bit) 
                                                begin
                                                // not last bit yet
                                                    bit_counter <= bit_counter + 1;
                                                    baud_time_counter <= 0;
                                                    // stay in RECEIVE
                                                end
                                                 
                                            else 
                                                begin
                                                // we just sampled bit 7 - next wait is for the stop bit
                                                    baud_time_counter <= 0;
                                                    rx_state <= STOP;
                                                end
                                        end 
                                
                                    else 
                                        begin
                                            baud_time_counter <= baud_time_counter + 1;
                                        end
                                
                                end
                            
                        end

                    // STOP (sample stop bit)
                    STOP: 
                        begin
                            if (en_baud_counter) 
                                begin
                                    if (baud_time_counter == true_FULL_BAUD) 
                                        begin      
                                            if (sync_1 == 1'b1) 
                                                begin
                                                    text_msg_chara <= data_shift;
                                                    rec_full_byte <= 1'b1; // one-cycle pulse
                                                    rx_state <= DONE;
                                                end
                                     
                                            else 
                                                begin
                                                // framing error: reset and go idle
                                                    rx_state <= IDLE;
                                                    en_baud_counter <= 1'b0;
                                                    baud_time_counter <= 0;
                                                    bit_counter <= 0;
                                                end
                                        end 
                                
                                    else 
                                        begin
                                            baud_time_counter <= baud_time_counter + 1;
                                        end
                                end
                            
                        end

                    // DONE (one cycle, then go IDLE)
                    DONE: 
                        begin
                            // rec_full_byte already asserted for this cycle in STOP handling
                            // clear counters and return to IDLE
                            en_baud_counter <= 1'b0;
                            baud_time_counter <= 0;
                            bit_counter <= 0;
                            rx_state <= IDLE;
                        end

                    default: 
                        begin
                            rx_state <= IDLE;
                        end
                endcase
            end
    end

endmodule
