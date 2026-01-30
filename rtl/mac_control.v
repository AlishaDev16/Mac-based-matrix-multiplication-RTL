`timescale 1ns/1ps

module mac_control (
    input  wire clk,
    input  wire rst,
    input  wire start,
    output reg  load_en,
    output reg  acc_en,
    output reg  clr_acc,
    output reg  done
);

    localparam IDLE = 2'd0,
               CALC = 2'd1,
               DONE = 2'd2;

    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        load_en = 0;
        acc_en  = 0;
        clr_acc = 0;
        done    = 0;
        next_state = state;

        case (state)
            IDLE: begin
                clr_acc = 1;
                if (start)
                    next_state = CALC;
            end

            CALC: begin
                acc_en = 1;
                next_state = DONE;
            end

            DONE: begin
                done = 1;
                if (!start)
                    next_state = IDLE;
            end
        endcase
    end

endmodule

