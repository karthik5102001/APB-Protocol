module APB_Master(
    input clock,
    input reset,
    input new_data,
    input [31:0] data,
    input [31:0] addr,
    input wr,
    input enable_clock,
    output [31:0] data_out,
	output error,
    
    output reg pclk,preset_n,psel,penable,
    output reg [31:0] pwdata,
    output reg [31:0] paddr,
    output reg pwrite,
    input pslverr,
    input [31:0] prdata,
    input pready
);

parameter idle = 2'b00, setup = 2'b01, enable = 2'b10;
reg [1:0] state,next_state;

assign pclk = (enable_clock) ? clock : 1'b0;
// assign preset = (enable_clock) ? ~reset : 1'bz;

always_ff @(posedge clock or posedge reset)
begin
    if(reset)begin
       preset_n <= 1'b0;
       state <= idle;    
    end
    else begin
        state <= next_state;
        preset_n <= 1'b1;
    end
end
    
always_comb begin
    case(state)
        idle : begin
               if(new_data) next_state = setup;
               else      next_state = idle;
        end
        setup : begin
               next_state = enable;
        end 
        enable : begin
               if(new_data) begin
                        if(pready == 1'b1)begin
                             next_state = setup;
                            end
                       else begin
                            next_state = enable;
                       end
                   end
               else begin
                        next_state = idle;
               end
        end
        default : begin
                next_state = idle;
        end
    endcase
end    


always_ff @(posedge clock or posedge reset)
begin
    if(reset)begin
        psel <= 1'b0;
    end
    else if (next_state == idle) begin
        psel <= 1'b0;
    end
    else if(next_state == enable || next_state == setup) begin 
        psel <= 1'b1;
    end
    else begin
        psel <= 1'b0;
    end
end


always_ff @(posedge clock or posedge reset)
begin
    if(reset)begin
         penable <= 1'b0; 
		 pwdata <= 32'h0;
         pwrite <= 1'b0;
         paddr <= 32'h0;

    end
    else if(next_state == idle) begin
         penable <= 1'b0;
         pwdata <= 32'h0;
         pwrite <= 1'b0;
         paddr <= 32'h0;
    end
    else if(next_state == setup) begin
         penable <= 1'b0;
         pwdata <= data;
         paddr <= addr;
      //   pwrite <= wr;
          if(wr) pwrite <= 1'b1;
          else pwrite <= 1'b0;
    end
    else if(next_state == enable) begin
         penable <= 1'b1;
    end
    else begin
         penable <= 1'b0;
    end
end

reg error_reg;

always_comb begin
	error_reg = pslverr;
end

assign data_out = ((pready)&&(wr == 1'b0)) ? prdata : 32'h0;
assign error = (error_reg) ? 1'b1:1'b0;

endmodule