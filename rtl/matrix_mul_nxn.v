module matrix_mul_nxn #(
    parameter N = 2,
    parameter DATA_WIDTH = 16,
    parameter ACC_WIDTH  = 32
)(
    input wire clk,
    input wire rst,
    input wire start,

    input wire [DATA_WIDTH-1:0] A [0:N-1][0:N-1],
    input wire [DATA_WIDTH-1:0] B [0:N-1][0:N-1],

    output reg [ACC_WIDTH-1:0]  C [0:N-1][0:N-1],
    output reg done
);

    integer i, j, k;

    reg mac_start;
    wire mac_done;
    reg  [DATA_WIDTH-1:0] mac_a, mac_b;
    wire [ACC_WIDTH-1:0] mac_result;

    mac_top #(DATA_WIDTH, ACC_WIDTH) mac (
        .clk(clk),
        .rst(rst),
        .start(mac_start),
        .a(mac_a),
        .b(mac_b),
        .result(mac_result),
        .done(mac_done)
    );

    reg [ACC_WIDTH-1:0] sum;
    reg busy;

    always @(posedge clk) begin
        if (rst) begin
            i <= 0; j <= 0; k <= 0;
            sum <= 0;
            done <= 0;
            mac_start <= 0;
            busy <= 0;
        end else begin
            done <= 0;
            mac_start <= 0;

            if (start && !busy) begin
                i <= 0; j <= 0; k <= 0;
                sum <= 0;
                busy <= 1;
            end

            if (busy) begin
                mac_a <= A[i][k];
                mac_b <= B[k][j];
                mac_start <= 1;

                if (mac_done) begin
                    sum <= sum + mac_result;
                    k <= k + 1;

                    if (k == N-1) begin
                        C[i][j] <= sum + mac_result;
                        sum <= 0;
                        k <= 0;
                        j <= j + 1;

                        if (j == N-1) begin
                            j <= 0;
                            i <= i + 1;
                            if (i == N-1) begin
                                done <= 1;
                                busy <= 0;
                            end
                        end
                    end
                end
            end
        end
    end

endmodule
