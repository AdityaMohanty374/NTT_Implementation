module ModMul_Montgomery(
	input clk,
	input reset,
	input [16:0]A,
	input [16:0]B,
	input [16:0]Q,
	output reg [79:0]C
);
	//Internal Registers
	reg [16:0]q, q_inv;
	reg [31:0] A_m, B_m;
	reg [63:0]t;
	reg [79:0]u, c_m;
	wire [16:0]r_inv, q1;

	initial begin
		q=Q;
	end

	//Parameters
	parameter k = 13;
	parameter r = 2**13;

	//Module Instantiates
	alg_1 t1( .clk(clk), .reset(reset), .a(r), .b(q), .c(r_inv));
	
	alg_1 t2( .clk(clk), .reset(reset), .a(q), .b(r), .c(q1));
	
	
	always @(posedge clk or posedge reset) begin
		if(reset) begin
			A_m <= 0;
			B_m <= 0;
			t <= 0;
			u <= 0;
			c_m <= 0;
			q_inv <= 0;
		end else begin
			q_inv <= r-q1;
			A_m <= (A*r)%q;
			B_m <= (B*r)%q;
			t <= A_m*B_m;
			u <= (t*q_inv)%r;
			c_m <= (t+u*q)/r;
			

			C <= (c_m*r_inv)%q;
		end
	end
endmodule
	