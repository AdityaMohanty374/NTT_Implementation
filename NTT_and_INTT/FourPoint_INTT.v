module FourPoint_INTT(
    input clk,
    input reset,
    input [16:0] in0,  //Individual input points, each 8 bits wide
    input [16:0] in1,
    input [16:0] in2,
    input [16:0] in3,
    output reg [16:0] out0,  //Individual output points, each 8 bits wide
    output reg [16:0] out1,
    output reg [16:0] out2,
    output reg [16:0] out3
);

    // Modulus and primitive root
    parameter q = 7681;
    parameter phi_m = 1213;
    parameter phi_m2 = 4298;
    parameter phi_m3 = 5756; 
    parameter n_inv = 0.25; //n = 4

    // Internal registers
    reg [16:0] x0, x1, x2, x3;
    reg [16:0] y0, y1, y2, y3;
    reg [16:0] w1, w2, w3;
    reg [16:0] temp0, temp1, temp2, temp3;

    // Function for modular addition
    function [16:0] mod_add;
        input [16:0] a, b;
        begin
            mod_add = (a + b) % q;
        end
    endfunction

    // Function for modular subtraction
    function [16:0] mod_sub;
        input [16:0] a, b;
        begin
            mod_sub = (a >= b) ? (a - b) : (q + a - b);
        end
    endfunction

    // Function for modular multiplication
    function [16:0] mod_mul;
        input [16:0] a, b;
        begin
            mod_mul = (a * b) % q;
        end
    endfunction

    // Butterfly operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x0 <= 0;
            x1 <= 0;
            x2 <= 0;
            x3 <= 0;
            y0 <= 0;
            y1 <= 0;
            y2 <= 0;
            y3 <= 0;
            out0 <= 0;
            out1 <= 0;
            out2 <= 0;
            out3 <= 0;
        end else begin
            // Load input values
            x0 <= in0;
            x1 <= in1;
            x2 <= in2;
            x3 <= in3;
            
            // Precompute powers of omega
            w1 <= phi_m;
            w2 <= phi_m2;
            w3 <= phi_m3;
            
            // First stage of butterfly
            temp0 <= mod_add(x0, x1)%q;
            temp1 <= mod_mul(mod_sub(x0, x1), phi_m)%q;
            temp2 <= mod_add(x2, x3)%q;
            temp3 <= mod_mul(mod_sub(x2, x3), phi_m3)%q;
            
            
            
            // Second stage of butterfly
            y0 <= mod_add(temp0, temp2);
            y1 <= mod_add(temp1, temp3);
            y2 <= mod_mul(mod_sub(temp0, temp2), phi_m2);
            y3 <= mod_mul(mod_sub(temp1, temp3), phi_m2);
            
            // Store output values
            out0 <= y0*n_inv;
            out1 <= y1*n_inv;
            out2 <= y2*n_inv;
            out3 <= y3*n_inv;
        end
    end
endmodule