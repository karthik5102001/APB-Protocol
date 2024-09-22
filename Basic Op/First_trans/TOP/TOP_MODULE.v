

module TOP_MODULE
(
input Clk,Reset,Write,newd,
input [7:0]  Data_in,
input [3:0] Addr,
output [7:0] Data_out
);

wire Psel,Penable,Pwrite,Pready;
wire [7:0] PWdata,PRdata;
wire [3:0] Paddr;

APB_Master_1 M1 (
.Pclk(Clk),
.Presetn(Reset),
.Addr(Addr),
.datain(Data_in),
.wr(Write),
.newd(newd),
.PRdata(PRdata),
.Pready(Pready),
.Psel(Psel),
.Penable(Penable),
.Paddr(Paddr),
.PWdata(PWdata),
.Pwrite(Pwrite),
.dataout(Data_out)
);

APB_Slave S1 (
.Pclk(Clk),
.Presetn(Reset),
.Paddr(Paddr),
.Psel(Psel),
.Penable(Penable),
.Pwdata(PWdata),
.Pwrite(Pwrite),

.Prdata(PRdata),
.Pready(Pready)
);



endmodule