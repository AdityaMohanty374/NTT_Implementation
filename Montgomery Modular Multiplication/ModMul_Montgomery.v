module Syn_Montgomery(
    input clk,
    input reset,
    input [16:0] A,
    input [16:0] B,
    input [16:0] Q,
    output reg [79:0] C // Output
);
    // Internal Registers
    reg [16:0] q_inv;
    reg [31:0] A_m, B_m;
    reg [63:0] t;
    reg [79:0] u, c_m;
    wire [16:0] r_inv, q1;

    // Parameters
    parameter k = 13;
    parameter r = 8192; // 2^13

    // Module Instantiates
    Inv_ModSyn m1(.clk(clk), .reset(reset), .a(r), .b(Q), .c(r_inv));
    Inv_ModSyn m2(.clk(clk), .reset(reset), .a(Q), .b(r), .c(q1));

    // Calculations
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A_m <= 0;
            B_m <= 0;
            t <= 0;
            u <= 0;
            c_m <= 0;
            q_inv <= 0;
        end else begin
            q_inv <= r - q1;
            A_m <= (A * r) % Q;
            B_m <= (B * r) % Q;
            t <= A_m * B_m;
            u <= (t * q_inv) % r;
            c_m <= (t + u * q) / r;

            C <= (c_m * r_inv) % Q;
        end
    end
endmodule
