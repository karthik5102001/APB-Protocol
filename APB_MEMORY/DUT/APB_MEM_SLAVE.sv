
module APB_Slave (
    input  wire                   pclk,       // APB clock input
    input  wire                   presetn,    // APB reset input
    input  wire                   psel,       // APB select input
    input  wire [31:0]            paddr,      // APB address input
    input  wire [31:0]            pwdata,     // APB write data input
    input  wire                   penable,    // APB enable input
    input  wire                   pwrite,     // APB write enable input
    output reg  [31:0]            prdata,     // APB read data output
    output reg                    pready,     // APB read data ready output
	output wire					  pslverr		
);

// Define parameters
parameter DEPTH = 16;  // Depth of the FIFO (number of entries)
parameter idle = 0, check_op = 1, write_data = 2, read_data =3,send_ready = 4;
reg [2:0] state = idle;
reg [31:0] addr,wdata,rdata;

// Internal FIFO memory
reg [31:0] mem [15:0];
reg [3:0] wr_ptr;   // Write pointer
reg [3:0] rd_ptr;   // Read pointer
reg [4:0] count;    // Count of valid entries in FIFO
reg [1:0] cwait = 0;
// APB FIFO control logic
always @(posedge pclk or negedge presetn) begin
    if (presetn == 0) begin
    
        for(int i = 0; i<16;i++)
        begin
        mem[i] <= 0;
        end
        
        wr_ptr <= 0;
        rd_ptr <= 0;
        count  <= 0;
        pready <= 0;
        state  <= idle;
        pready <= 0;
        prdata <= 0;
        addr   <= 0;
        wdata  <= 0;
        rdata  <= 0;
        cwait  <= 0;
        
    end else begin
        // APB write operation
        case(state)
        idle:
        begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            pready <= 0;
            prdata <= 0;
            addr   <= 0;
            wdata  <= 0;
            rdata  <= 0;
            cwait  <= 0;
            state  <= check_op;
        end
        
        check_op:
        begin
         if (penable && psel && pwrite && count != 15) // Write
         begin 
            state   <= write_data;
            addr    <= paddr;
            wdata   <= pwdata;
         end
         else if (penable && psel && !pwrite && count != 0) // Read
         begin
            state  <= read_data;
            addr   <= paddr;
         end
         else 
            state  <= check_op;
        end
        
        write_data:
        begin
            mem[addr] <= wdata;
            
            if(cwait < 2)          // Memory write latency
            begin
              state <= write_data;
              cwait <= cwait + 1;
            end
            else
            begin
               cwait <= 0;
               pready <= 1'b1;
               state <= send_ready;
               wr_ptr <= wr_ptr + 1;
               count  <= count  + 1;
            end
        end
        
        read_data : begin
            rdata <= mem[addr];
            if(cwait < 2)         // Memory read latency
            begin
              state <= read_data;
              cwait <= cwait + 1;
            end
            else
            begin
               cwait <= 0;
               state <= send_ready;
               pready <= 1'b1;
               prdata <= rdata;     // Send prdata and Pready
               rd_ptr <= rd_ptr + 1;
               count  <= count  - 1;
            end
        
        end
        
        send_ready: begin
           state  <= check_op;
           pready <= 1'b0;    
         end
     
     endcase
     
     end
        
   end  

  assign pslverr = (rd_ptr < 0 || wr_ptr > 16) ? 1'b1 : 1'b0; // if the pointer value exceed the range we will get error.
endmodule