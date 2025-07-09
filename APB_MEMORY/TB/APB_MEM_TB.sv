module Top_APB_FIFO();

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

APB_TOP_FIFO DUT (clock,
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
	@(posedge clock);
    new_data <= 1'b1;
    enable_clock <= 1'b1;
    data  <= $urandom_range(0,32);
    addr  <= i;
    wr <= 1'b1;
    @(posedge data_ready);
    end
    /// READ 
	repeat(3)	 @(posedge clock);
	for(int j = 0; j <= 5; j++)
    begin
	 @(posedge clock);
     new_data <= 1'b1;
     enable_clock <= 1'b1;
     addr <= j;
     wr <= 1'b0;
     @(posedge data_ready);
	 	 end 
repeat(delay)	 @(posedge clock);
		 $finish;
end


initial begin
	$dumpfile("top.vpd");
	$dumpvars(0,Top_APB_FIFO);
//	#1000 $finish;
end

endmodule
