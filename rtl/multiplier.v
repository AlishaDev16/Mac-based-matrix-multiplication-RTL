`timescale 1ns/1ps

module multiplier #(
    parameter DATA_WIDTH = 16
)(
    input  wire [DATA_WIDTH-1:0] a,
    input  wire [DATA_WIDTH-1:0] b,
    output wire [2*DATA_WIDTH-1:0] p
);

    assign p = a * b;

endmodule

