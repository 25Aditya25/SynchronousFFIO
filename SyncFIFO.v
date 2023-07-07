module SyncFIFO
(input [7:0]data_in,
input w_en,
input r_en,
input clk,
output reg [7:0]data_out,
output full,
output empty);




//Eight entry queue with 8bit entries
reg [7:0] FIFOreg [0:7];

//Write and read pointers
reg [2:0] w_ptr;
reg [2:0] r_ptr;

//Overflow bits for detecting if queue is empty of full
reg w_ovf;
reg r_ovf;  

//empty and full registers
reg full_reg;
reg empty_reg;

//Always block for writing
always@(posedge clk)
begin
	if(w_en)
	begin
		if(full_reg!=1'b1) //check if queue is not full
		begin
			FIFOreg[w_ptr]=data_in;
			{w_ovf,w_ptr}={w_ovf,w_ptr}+1'b1;
			
		end
	end
end

//Always block for reading
always@(posedge clk)
begin
	if(r_en)
	begin
		if(empty_reg!=1'b1) //check if queue is not full
		begin
			data_out=FIFOreg[r_ptr];
			{r_ovf,r_ptr}={r_ovf,r_ptr}+1'b1;
			
		end
	end
end

always@(posedge clk)
begin
	full_reg = (w_ptr==r_ptr) && (w_ovf!=r_ovf);
	empty_reg = (w_ptr==r_ptr) && (w_ovf==r_ovf);
end

//Condition for queue empty
assign full = full_reg; 
assign empty = empty_reg; 

//Initial block
initial
begin
	{w_ovf,w_ptr}<=4'd0;
	{r_ovf,r_ptr}<=4'd0;
	full_reg<=1'b0;
	empty_reg<=1'b0;
end
endmodule