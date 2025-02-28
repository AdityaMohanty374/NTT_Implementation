//modified for ordered inputs ordered outputs

module intt4point(
    input clk, rst,
    input [15:0] in0, in1, in2, in3,
    output reg [15:0] out0, out1, out2, out3
);
    wire [15:0] q_val = 16'd7681;
    wire [15:0] phim1 = 16'd1213;
    wire [15:0] phim2 = 16'd4298;
    wire [15:0] phim3 = 16'd5756;
    wire [15:0] temp0, temp1, temp2, temp3;
    wire [15:0] y0, y1, y2, y3;

    //first stage
    gsbf u0(.in_up(in0), .in_down(in2), .twf(phim1), .q(q_val), .out_up(temp0), .out_down(temp1));//bit reversed
    gsbf u1(.in_up(in1), .in_down(in3), .twf(phim3), .q(q_val), .out_up(temp2), .out_down(temp3));//order output

    //second stage
    gsbf u2(.in_up(temp0), .in_down(temp2), .twf(phim2), .q(q_val), .out_up(y0), .out_down(y2));
    gsbf u3(.in_up(temp1), .in_down(temp3), .twf(phim2), .q(q_val), .out_up(y1), .out_down(y3));

    always @(posedge clk) begin
      if (rst) begin
        out0 <= 0;
        out1 <= 0;
        out2 <= 0;
        out3 <= 0;
      end else begin
        out0 <= y0 >> 2; //n_inv = 0.25
        out1 <= y1 >> 2; //equivalent to div by 4
        out2 <= y2 >> 2; //normal bit order output
        out3 <= y3 >> 2; 
      end
    end
endmodule

module gsbf(
  input [15:0] in_up, in_down, twf, q,
  output [15:0] out_up, out_down
);
  wire [15:0] temp;
  modadd ma(.a(in_up), .b(in_down), .q(q), .y(out_up));
  modsub ms(.a(in_up), .b(in_down), .q(q), .y(temp));
  modmul mm(.a(temp), .b(twf), .q(q), .y(out_down));
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
