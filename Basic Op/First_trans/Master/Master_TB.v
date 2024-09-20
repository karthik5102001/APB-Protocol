
module TB_APB_Master_1;
reg Pclk = 0 ,Presetn = 1;
reg [3:0] Addr;
reg [7:0] datain;
reg wr;
reg newd;
reg [7:0] PRdata;
reg Pready;

wire Psel,Penable,Pslverr;
wire [3:0]  Paddr;
wire [7:0] PWdata;
wire Pwrite;
wire [7:0] dataout;

APB_Master_1 DUT (Pclk,Presetn,Addr,datain,wr,newd,PRdata,Pready,Psel,Penable,Pslverr,Paddr,PWdata,Pwrite,dataout);

always #10 Pclk <= ~Pclk;


initial begin 
	Presetn = 1'b0;
	repeat (5) @(posedge Pclk);
	Presetn = 1'b1;

	newd = 1'b1;
	wr = 1'b1;
	Addr = 4;
	datain = 12;
	PRdata = 10;
	repeat(2)@(posedge Pclk);
	Pready = 1'b1;
	@(posedge Pclk);


	newd = 1'b1;
	Addr = 9;
	datain = 255;
	wr = 1;
	@(posedge Pclk);
	Pready = 1'b0;
	repeat (5) @(posedge Pclk);
	Pready = 1'b1;
	@(posedge Pclk);	


	newd = 1'b1;
	Addr = 5;
	datain = 127;
	wr = 0;
	@(posedge Pclk);
	Pready = 1'b1;
	@(posedge Pclk);
	newd = 0;
	@(posedge Pclk);
end

initial begin
		#1000 $finish;
end

endmodule
