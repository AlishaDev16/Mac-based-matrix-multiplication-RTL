`timescale 1ns/1ps

module mac_datapath #(
    parameter DATA_WIDTH = 16,
    parameter ACC_WIDTH  = 32
)(
    input  wire                   clk,
    input  wire                   rst,
    input  wire                   load_en,
    input  wire                   acc_en,
    input  wire                   clr_acc,
    input  wire [DATA_WIDTH-1:0]  a_in,
    input  wire [DATA_WIDTH-1:0]  b_in,
    output reg  [ACC_WIDTH-1:0]   acc_out
);

    wire [2*DATA_WIDTH-1:0] mult_out;

    multiplier #(
        .DATA_WIDTH(DATA_WIDTH)
    ) u_mul (
        .a(a_in),
        .b(b_in),
        .p(mult_out)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc_out <= {ACC_WIDTH{1'b0}};
        end else if (clr_acc) begin
            acc_out <= {ACC_WIDTH{1'b0}};
        end else if (acc_en) begin
            acc_out <= acc_out + mult_out;
        end
    end

endmodule


