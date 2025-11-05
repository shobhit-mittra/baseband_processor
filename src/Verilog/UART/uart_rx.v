`timescale 1ns / 1ps

// You MUST NOT change the module name or the ports declarations

module uart_rx(
    input clk,
    input rst_n,
    input uart_rx_i,

    output reg rec_full_byte,  // A full byte has been received
    output reg [7:0] text_msg_chara
);
    // These declarations are provided as hints for a possible implementation.
    // You are free to modify, add, or remove them as long as the module's
    // external behavior is correct

    reg [13:0] baud_time_counter; // counts clock ticks to measure the duration of one bit period
    reg [3:0] bit_counter; // 10 bits for transferring a whole byte
    reg en_baud_counter; // enables counting when a UART frame is being received
    wire neg_uart_rx; // single-cycle pulse that detects the falling edge of the start bit

    // ----------- Insert your codes below --------------//



endmodule
