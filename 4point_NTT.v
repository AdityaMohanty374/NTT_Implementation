module FourPoint_NTT(
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
    parameter phi = 1925;
    parameter phi2 = 3383;
    parameter phi3 = 6468; 

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
            w1 <= phi;
            w2 <= phi2;
            w3 <= phi3;
            
            // First stage of butterfly
            temp0 <= mod_add(x0, mod_mul(x2, phi2));
            temp2 <= mod_sub(x0, mod_mul(x2, phi2));
            temp1 <= mod_add(x1, mod_mul(x3, phi2));
            temp3 <= mod_sub(x1, mod_mul(x3, phi2));
            
            
            
            // Second stage of butterfly
            y0 <= mod_add(temp0, mod_mul(temp1, phi));
            y1 <= mod_sub(temp0, mod_mul(temp1, phi));
            y2 <= mod_add(temp2, mod_mul(temp3, phi3));
            y3 <= mod_sub(temp2, mod_mul(temp3, phi3));
            
            // Store output values
            out0 <= y0;
            out1 <= y1;
            out2 <= y2;
            out3 <= y3;
        end
    end
endmodule