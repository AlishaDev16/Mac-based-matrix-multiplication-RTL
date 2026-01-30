`timescale 1ns/1ps

module tb_matrix_mul_nxn;

    parameter N = 2;
    parameter DATA_WIDTH = 16;
    parameter ACC_WIDTH  = 32;

    reg clk;
    reg rst;
    reg start;

    reg  [DATA_WIDTH-1:0] A [0:N-1][0:N-1];
    reg  [DATA_WIDTH-1:0] B [0:N-1][0:N-1];
    wire [ACC_WIDTH-1:0]  C [0:N-1][0:N-1];

    wire done;

    matrix_mul_nxn #(
        .N(N),
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A(A),
        .B(B),
        .C(C),
        .done(done)
    );

    always #5 clk = ~clk;

    integer i, j;

    initial begin
        $dumpfile("dump_matrix_nxn.vcd");
        $dumpvars(0, tb_matrix_mul_nxn);

        clk   = 0;
        rst   = 1;
        start = 0;

        A[0][0] = 1;  A[0][1] = 2;
        A[1][0] = 3;  A[1][1] = 4;

        B[0][0] = 5;  B[0][1] = 6;
        B[1][0] = 7;  B[1][1] = 8;

        #20 rst = 0;

        #10 start = 1;
        #10 start = 0;

        wait (done);

        $display("Result matrix C:");
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                $display("C[%0d][%0d] = %0d", i, j, C[i][j]);
            end
        end

        #20 $finish;
    end

endmodule
