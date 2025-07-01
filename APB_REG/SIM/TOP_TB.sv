module Top_APB_reg();

parameter delay = 10;

reg clock;
reg reset;
reg new_data;
reg [31:0] data;
reg [31:0] addr;
reg wr;
reg enable_clock;
reg [31:0] data_out;
reg data_ready;

APB_TB DUT (clock,
 reset,
new_data,
 data,
 addr,
 wr,
 enable_clock, 
 data_ready,
 data_out);

always #(delay) clock = ~clock;

initial begin
    clock = 1'b0;
    reset = 1'b1;
    #(delay);
    @(posedge clock);
    reset = 1'b0;
    
    @(posedge clock);
    
    for(int i = 0; i <= 5; i ++)
    begin
    new_data <= 1'b1;
    enable_clock <= 1'b1;
    data  <= $urandom_range(0,32);
    addr  <= 32'h0;
    wr <= 1'b1;
    @(posedge data_ready);
    end
    /// READ 
     new_data <= 1'b1;
     enable_clock <= 1'b1;
     addr <= 32'h0;
     wr <= 1'b0;
     @(posedge data_ready);
        
end

endmodule
