//Modular Inverse

module alg_1(
	input clk,
	input reset,
	input [16:0]a,
	input [16:0]b,
	output reg [16:0]c
);
	reg [16:0]w = 0;
	reg [16:0]q;
	reg [16:0]r;
	integer i=1;
	integer m=0;

	always@(posedge clk or posedge reset) begin
		q = a;
		r = b;
		if(reset) begin
			m <= 0;
			i <= 0;
			w <= 0;
		end else begin
			if(w==0) begin
				m <= r*i+1;
				i <= i+1;
				if(m%q==0) begin
					w <= m/q;
				end
			end
		end
		c <= w;
	end
endmodule