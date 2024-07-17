module Inv_ModSyn(
    input clk,
    input reset,
    input [16:0] a,
    input [16:0] b,
    output reg [16:0] c // Output
);
    // Internal Registers
    reg [16:0] w;
    reg [16:0] q;
    reg [16:0] r;
    reg [31:0] m;
    reg [16:0] i;

    // Calculations
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= a;
            r <= b;
            m <= 0;
            i <= 1;
            w <= 0;
        end else begin
            if (w == 0) begin
                m <= r * i + 1;
                i <= i + 1;
                if (m % q == 0) begin
                    w <= m / q;
                end
            end
            c <= w;
        end
    end
endmodule
