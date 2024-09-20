
module APB_Master_1
(
input Pclk,Presetn,
input [3:0] Addr,
input [7:0] datain,
input wr,
input newd,
input [7:0] PRdata,
input Pready,

output reg Psel,Penable,Pslverr,
output reg [3:0]  Paddr,
output reg [7:0] PWdata,
output reg Pwrite,
output [7:0] dataout
);

localparam [1:0] idle = 0, Setup = 1, Enable = 2;
reg [1:0] state, nstate;

///////--------Reset Decoder 

always @(posedge Pclk, negedge Presetn)
begin
	if(Presetn == 1'b0)
		begin
			state <= idle;
		end
	else 
		begin
			state <= nstate;
		end
end

always @*
begin
	case(state)	
		idle : begin
				if(newd == 1'b0) 
					begin
					nstate = idle; 
					end
				else 
					begin
					nstate = Setup;
					end
			end
		Setup : begin			/////----- First Cycle
				nstate = Enable;
			end
		Enable : begin		        /////----- Secone Cycle
				if(newd == 1'b1)
					begin
					if(Pready == 1'b1)
						begin
						    nstate = Setup;
						end
					else
						begin
						    nstate = Enable;
						end
					end
				else begin
					  nstate = idle;
					end
			end
		default : begin
				nstate = idle;
			  end
		endcase
end

///////---------Address Decoder

always @(posedge Pclk,negedge Presetn)
begin
	if(Presetn == 1'b0)
		begin
			Psel <= 1'b0;
		end
	 else if(nstate == idle)
		begin
			Psel <= 1'b0;
		end
	else if((nstate == Enable) || (nstate== Setup))
		begin
			Psel <= 1'b1;
		end
	else begin
			Psel <= 1'b0;
	     end
end


///////--------Output Logic

always @(posedge Pclk, negedge Presetn)
begin
	if(Presetn == 1'b0)
		begin
			Penable <= 1'b0;
			Paddr <= 4'h0;
			PWdata <= 8'h00;
			Pwrite <= 1'b0;
		end
	else if (nstate == idle)
		begin
			Penable <= 1'b0;
			Paddr <= 4'h0;
			PWdata <= 8'h00;
			Pwrite <= 1'b0;
		end
	else if (nstate == Setup)
		begin
			Penable <= 1'b0;
			Paddr <= Addr;
			Pwrite <= wr;
				if(wr == 1'b1)
					begin
					   PWdata <= datain;
					end
		end
	else if (nstate == Enable)
		begin
			Penable <= 1'b1;
		end

end


//////---------Data Out Logic

assign dataout = ((Psel == 1'b1) && (Penable == 1'b1) && (wr == 1'b0)) ? PRdata : 8'h00;


endmodule