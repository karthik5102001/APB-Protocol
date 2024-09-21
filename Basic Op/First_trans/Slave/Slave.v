
module APB_Slave 
(
input Pclk,
input Presetn,
input [3:0] Paddr,
input Psel,
input Penable,
input [7:0] Pwdata,
input Pwrite,

output reg [7:0] Prdata,
output reg Pready
);

localparam [1:0] idle = 0, write = 1, read = 2;
reg [7:0] mem [0:15];
reg [1:0] state,nstate;

always @(posedge Pclk, negedge Presetn)
begin
	if(Presetn == 1'b0)
		begin
	         state <= idle;
		end
	else 
		  state <= nstate;
end

always@*
begin
	case(state)
		 idle : begin
			Prdata = 8'h00;
			Pready = 1'b0;
			if(Psel == 1'b1 && Pwrite == 1'b1)
				nstate = write;
			else if (Psel == 1'b1 && Pwrite == 1'b0)
				nstate = read;
			else 
				nstate = idle;
			end

		write : begin
			if(Psel == 1'b1 && Penable == 1'b1)
				begin
				Pready = 1'b1;
				mem[Paddr] = Pwdata;
				state = idle;
				end
			else 
				begin
				nstate = idle;	
				end
			end
	
		read : begin
			if(Psel == 1'b1 && Penable == 1'b1)
				begin
				Pready = 1'b1;
				Prdata = mem[Paddr];
				nstate = idle;
				end
			else
				begin	
				nstate = idle;
				end

			end
	        default : nstate = idle;
	endcase
end

endmodule