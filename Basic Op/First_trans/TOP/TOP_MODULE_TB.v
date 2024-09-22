module TOP_TB;

reg Clk = 0 ,Reset = 0 ,Write,newd;
reg [7:0]  Data_in;
reg [3:0] Addr;
wire [7:0] Data_out;
integer i;

TOP_MODULE DUT ( Clk, Reset, Write, newd, Data_in, Addr, Data_out );


always #10 Clk = ~Clk;

initial begin
Reset = 0;
repeat(5) @(posedge Clk);
Reset = 1;
newd = 1;

for( i = 0; i < 10; i = i + 1)
	begin
		Data_in = $urandom;
		Addr = $urandom;
		Write = 1;	
		@(posedge DUT.M1.Pready);	
	end

i = 0;

for (i = 0; i <10 ; i = i + 1)
	begin
		Data_in = 0;
		Addr = $urandom;
		Write = 0;
		@(posedge DUT.M1.Pready);
	end
newd = 0;
end

initial begin
#2000 $finish;
end


endmodule
