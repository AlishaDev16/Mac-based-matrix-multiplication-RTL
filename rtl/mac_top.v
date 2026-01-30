module mac_top #(
    parameter DATA_WIDTH = 16,
    parameter ACC_WIDTH  = 32
)(
    input  wire                  clk,
    input  wire                  rst,
    input  wire                  start,
    input  wire [DATA_WIDTH-1:0] a,
    input  wire [DATA_WIDTH-1:0] b,

    output reg  [ACC_WIDTH-1:0]  result,
    output reg                   done
);

    reg [ACC_WIDTH-1:0] acc;
    reg busy;

    always @(posedge clk) begin
        if (rst) begin
            acc    <= 0;
            result <= 0;
            done   <= 0;
            busy   <= 0;
        end else begin
            done <= 0;

            if (start && !busy) begin
                acc  <= a * b;
                busy <= 1;
            end else if (busy) begin
                result <= acc;
                done   <= 1;
                busy   <= 0;
            end
        end
    end

endmodule

