`timescale 1ns/1ps

module matrix_mul_top #(
    parameter DATA_WIDTH = 16,
    parameter ACC_WIDTH  = 32
)(
    input  wire clk,
    input  wire rst,
    input  wire start,

    input  wire [DATA_WIDTH-1:0] a00, a01, a10, a11,
    input  wire [DATA_WIDTH-1:0] b00, b01, b10, b11,

    output reg  [ACC_WIDTH-1:0]  c00, c01, c10, c11,
    output reg  done
);

    // FSM states
    localparam IDLE      = 3'd0,
               CLEAR     = 3'd1,
               MAC_START = 3'd2,
               MAC_WAIT  = 3'd3,
               STORE     = 3'd4,
               NEXT      = 3'd5;

    reg [2:0] state;

    reg i, j, k;

    reg mac_start;
    wire mac_done;
    wire [ACC_WIDTH-1:0] mac_result;

    reg [DATA_WIDTH-1:0] mac_a, mac_b;

    mac_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) mac (
        .clk(clk),
        .rst(rst),
        .start(mac_start),
        .a(mac_a),
        .b(mac_b),
        .result(mac_result),
        .done(mac_done)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            i <= 0; j <= 0; k <= 0;
            mac_start <= 0;
            done <= 0;
            c00 <= 0; c01 <= 0; c10 <= 0; c11 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        i <= 0; j <= 0; k <= 0;
                        state <= CLEAR;
                    end
                end

                CLEAR: begin
                    mac_start <= 0;
                    state <= MAC_START;
                end

                MAC_START: begin
                    mac_start <= 1;
                    state <= MAC_WAIT;
                end

                MAC_WAIT: begin
                    mac_start <= 0;
                    if (mac_done) begin
                        if (k == 0) begin
                            k <= 1;
                            state <= MAC_START;
                        end else begin
                            k <= 0;
                            state <= STORE;
                        end
                    end
                end

                STORE: begin
                    if (i == 0 && j == 0) c00 <= mac_result;
                    if (i == 0 && j == 1) c01 <= mac_result;
                    if (i == 1 && j == 0) c10 <= mac_result;
                    if (i == 1 && j == 1) c11 <= mac_result;
                    state <= NEXT;
                end

                NEXT: begin
                    if (j == 0) begin
                        j <= 1;
                        state <= CLEAR;
                    end else if (i == 0) begin
                        j <= 0;
                        i <= 1;
                        state <= CLEAR;
                    end else begin
                        done <= 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    always @(*) begin
        if (i == 0 && k == 0) mac_a = a00;
        else if (i == 0 && k == 1) mac_a = a01;
        else if (i == 1 && k == 0) mac_a = a10;
        else mac_a = a11;

        if (j == 0 && k == 0) mac_b = b00;
        else if (j == 0 && k == 1) mac_b = b10;
        else if (j == 1 && k == 0) mac_b = b01;
        else mac_b = b11;
    end

endmodule

