module ntt4point(
    input clk, rst,
    input [15:0] in0, in1, in2, in3,
    output reg [15:0] out0, out1, out2, out3
);
    wire [15:0] q_val = 16'd7681;
    wire [15:0] phi1 = 16'd1925;
    wire [15:0] phi2 = 16'd3383;
    wire [15:0] phi3 = 16'd6468;
    wire [15:0] temp0, temp1, temp2, temp3;
    wire [15:0] y0, y1, y2, y3;

    //first stage
    ctbf u0(.in_up(in0), .in_down(in2), .twf(phi2), .q(q_val), .out_up(temp0), .out_down(temp2));
    ctbf u1(.in_up(in1), .in_down(in3), .twf(phi2), .q(q_val), .out_up(temp1), .out_down(temp3));

    //second stage
    ctbf u2(.in_up(temp0), .in_down(temp1), .twf(phi1), .q(q_val), .out_up(y0), .out_down(y1));
    ctbf u3(.in_up(temp2), .in_down(temp3), .twf(phi3), .q(q_val), .out_up(y2), .out_down(y3));

    always @(posedge clk) begin
      if (rst) begin
        out0 <= 0;
        out1 <= 0;
        out2 <= 0;
        out3 <= 0;
      end else begin
        out0 <= y0;   
        out1 <= y2; //bit reversed order output
        out2 <= y1; //converting to normal order
        out3 <= y3; 
      end
    end  
endmodule

module ctbf(
  input [15:0] in_up, in_down, twf, q,
  output [15:0] out_up, out_down
);
  wire [15:0] temp;
  modmul mm(.a(in_down), .b(twf), .q(q), .y(temp));
  modadd ma(.a(in_up), .b(temp), .q(q), .y(out_up));
  modsub ms(.a(in_up), .b(temp), .q(q), .y(out_down)); 
endmodule

module modadd(
    input [15:0] a, b, q,
    output [15:0] y
);
    wire [16:0] sum;
    assign sum = a + b;
    assign y = (sum >= q) ? sum - q : sum;
endmodule

module modsub(
    input [15:0] a, b, q,
    output [15:0] y
);
    wire [16:0] qplusa;
    assign qplusa = q + a;
    assign y = (a >= b) ? (a - b) : (qplusa - b);
endmodule

module modmul(
    input [15:0] a, b, q,
    output [15:0] y
);
    wire [31:0] result;
    assign result = a * b;
    assign y = result % q;
endmodule
