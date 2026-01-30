`timescale 1ns/1ps

module tb_mac;

    reg clk;
    reg rst;
    reg start;
    reg [15:0] a, b;
    wire [31:0] result;
    wire done;

    mac_top dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .result(result),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        a = 0;
        b = 0;

        #20 rst = 0;

        a = 3;
        b = 4;

        #10 start = 1;
        #10 start = 0;

        wait(done);
        #20 $finish;
    end

endmodule

