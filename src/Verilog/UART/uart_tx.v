`timescale 1ns / 1ps

// You MUST NOT change the module name or the ports declarations

module uart_tx (
        input clk,
        input rst_n,
        input [7:0] data_byte_in,
        input send_now,

        output reg finish_tx,
        output reg uart_tx_o
    );

    // These declarations are provided as hints for a possible implementation.
    // You are free to modify, add, or remove them as long as the module's
    // external behavior is correct

    // FSM states parameters
    localparam INIT = 0,
               SEND = 1,
               DONE = 2;

    reg [1:0] state;

    reg [13:0] baud_time_counter; // counts clock ticks to measure the duration of one bit period
    reg [3:0] bit_counter; // 10 bits for transfering a whole byte

    reg [16:0] wait_between_byte; // counts clock ticks for the wait duration (20000 ycles)

    // ----------- Insert your codes below --------------//

endmodule
