/*FIFO módulo n (FIFO_WIDTH)*/
module fifo 
#(
	parameter DATA_WIDTH = 32, FIFO_WIDTH = 8
)
(
	input clk, rst, w, r,
	input signed [DATA_WIDTH - 1 : 0] data_in,
	output full, empty,
	output reg signed[DATA_WIDTH - 1 : 0] data_out
	
);


reg [FIFO_WIDTH : 0] ptr_w, ptr_r;

reg [0 : DATA_WIDTH - 1] mem [(2**FIFO_WIDTH) - 1 : 0];

assign full = (ptr_r[FIFO_WIDTH] != ptr_w[FIFO_WIDTH]) && (ptr_r[FIFO_WIDTH -1 : 0] == ptr_w[FIFO_WIDTH -1 : 0]);
assign empty = (ptr_r == ptr_w);


always @ (posedge clk)
begin
	if(w)
		mem[ptr_w[FIFO_WIDTH - 1 : 0]] <= data_in;	
end

always @ (posedge clk or posedge rst)
begin
	if(rst)
		ptr_w <= {FIFO_WIDTH + 1{1'b0}};
	else
	begin
		if(w)
			ptr_w <= ptr_w + {{FIFO_WIDTH - 1{1'b0}},{1'b1}};
	end
		
end

//Saída registrada
always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		ptr_r <= {FIFO_WIDTH + 1{1'b0}};
		data_out <= {DATA_WIDTH {1'b0}};
	end
	else
	begin
		if(r)
		begin
			data_out <= mem[ptr_r[FIFO_WIDTH - 1 : 0]];
			ptr_r <= ptr_r + {{FIFO_WIDTH - 1{1'b0}},{1'b1}};
		end
	end
end




endmodule
