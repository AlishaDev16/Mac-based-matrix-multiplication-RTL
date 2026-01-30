`timescale 1ns/1ps

module tb_matrix_mul;

    reg clk;
    reg rst;
    reg start;

    reg  [15:0] a00, a01, a10, a11;
    reg  [15:0] b00, b01, b10, b11;

    wire [31:0] c00, c01, c10, c11;
    wire done;

    matrix_mul_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),

        .a00(a00), .a01(a01), .a10(a10), .a11(a11),
        .b00(b00), .b01(b01), .b10(b10), .b11(b11),

        .c00(c00), .c01(c01), .c10(c10), .c11(c11),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump_matrix.vcd");
        $dumpvars(0, tb_matrix_mul);

        clk   = 0;
        rst   = 1;
        start = 0;

        a00 = 16'd1;  a01 = 16'd2;
        a10 = 16'd3;  a11 = 16'd4;

        b00 = 16'd5;  b01 = 16'd6;
        b10 = 16'd7;  b11 = 16'd8;

        #20 rst = 0;

        #10 start = 1;
        #10 start = 0;

        wait(done);

        #20 $finish;
    end

endmodule

