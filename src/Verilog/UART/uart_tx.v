`timescale 1ns / 1ps

module uart_tx (
        input clk,
        input rst_n,
        input [7:0] data_byte_in,
        input send_now,

        output reg finish_tx,
        output reg uart_tx_o
    );

    // FSM states parameters
    localparam INIT = 0,
               SEND_BITS = 1,
               STOP_BIT = 2,
               DONE = 3;
               

    reg [1:0] state;

    reg [13:0] baud_time_counter; // counts clock ticks to measure the duration of one bit period
    reg [3:0] bit_counter; // 10 bits for transfering a whole byte

    reg [16:0] wait_between_byte; // counts clock ticks for the wait duration (20000 ycles)

    reg [7:0] latch_data;
    reg busy;

    
    localparam integer FULL_BAUD = 10417;
    localparam integer WAIT_CYCLES = 20000;
    localparam integer true_FULL_BAUD = FULL_BAUD - 1;

    
    always @(posedge clk) 
        begin
            if (!rst_n) 
                begin
                    state <= INIT;
                    uart_tx_o <= 1'b1;    // idle high
                    finish_tx <= 1'b0;
                    baud_time_counter <= 14'd0;
                    bit_counter <= 4'd0;
                    latch_data <= 8'd0;
                    busy <= 1'b0;
                    wait_between_byte <= 17'd0;
                end 
            
            else 
                begin
                    finish_tx <= 1'b0; // defaults to low

                    case (state)
                
                        INIT: 
                            begin
                                uart_tx_o <= 1'b1; // default tx_o line idle
                                busy <= 1'b0;
                                baud_time_counter <= 14'd0;
                                bit_counter <= 4'd0;
                                
                                // Check if the 20k wait_cycles have passed or not [Additional Check]
                                if (wait_between_byte != 0)
                                    begin
                                        wait_between_byte <= wait_between_byte - 1;
                                    end
                                
                                else 
                                    begin
                                    // accept an incoming pulse only when send_now is pulsed and not busy
                                        if (send_now && !busy) 
                                            begin
                                                latch_data <= data_byte_in;  // latch the byte here
                                                uart_tx_o <= 1'b0; // drive start bit immediately
                                                baud_time_counter <= 14'd0;
                                                busy <= 1'b1;
                                                state <= SEND_BITS;
                                                bit_counter <= 4'd0;
                                            end   
                                    
                                    end
                            
                            end
                
                        // transmitting byte here
                        SEND_BITS: 
                            begin
                                if (baud_time_counter < true_FULL_BAUD) 
                                    begin
                                        baud_time_counter <= baud_time_counter + 1;
                                    end 
                                
                                else 
                                    begin
                                    // reached mid/end of current bit period; advance to next bit period
                                        baud_time_counter <= 14'd0;

                                        // If still have data bits to transmit -> output current data bit in next period
                                        if (bit_counter < 4'd8) 
                                            begin
                                            // put data bit onto line for the next bit period
                                                uart_tx_o <= latch_data[bit_counter];
                                                bit_counter <= bit_counter + 1;
                                            // remain in SEND_BITS until 8 bits sent 
                                            // when bit_counter becomes 8, next go to STOP_BIT
                                            end

                                        if (bit_counter == 4'd8) 
                                            begin
                                            // finished sending bits 0 to 7, next period will be STOP bit
                                                state <= STOP_BIT;
                                            // drive stop bit immediately next period
                                                 uart_tx_o <= 1'b1;
                                            end
                                    end
                                    
                            end

                        STOP_BIT: 
                            begin
                            // hold stop bit for one full baud period
                                if (baud_time_counter < true_FULL_BAUD) 
                                    begin
                                        baud_time_counter <= baud_time_counter + 1;
                                        uart_tx_o <= 1'b1;
                                    end 
                            
                                else 
                                    begin
                                        baud_time_counter <= 14'd0;
                                        // finished stop bit period -> pulse finish_tx for one cycle
                                        //finish_tx <= 1'b1;
                                        wait_between_byte <= WAIT_CYCLES; // after transmitting wait for 20k cycles, in the DONE state
                                        state <= DONE;
                                    end
                                    
                            end

                        DONE: 
                            begin
                                busy <= 1'b0;
                                uart_tx_o <= 1'b1;
                                
                                // stay in DONE until 20k cycles are over
                                if (wait_between_byte != 0)
                                    begin
                                        wait_between_byte <= wait_between_byte - 1; // count down from 20k to 0
                                    end
                                    
                                else 
                                    begin
                                        state <= INIT;
                                        finish_tx <= 1'b1; // after waiting for 20k cycles asserted finish_tx
                                    end
                                    
                            end

                        default: 
                            begin
                                state <= INIT;
                            end
                            
                    endcase
                end
        end

endmodule
