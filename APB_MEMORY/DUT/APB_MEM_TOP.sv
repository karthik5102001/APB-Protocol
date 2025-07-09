module APB_TOP_FIFO (
    input clock,
    input reset,
    input new_data,
    input [31:0] data,
    input [31:0] addr,
    input wr,
    input enable_clock,
    output data_ready,
    output [31:0] data_out
);
/*
reg clock;
reg reset;
reg new_data;
reg [31:0] data;
reg [31:0] addr;
reg wr;
reg enable_clock;
reg [31:0] data_out;
*/
wire pclk,preset_n,psel,penable;
wire [31:0] pwdata;
wire [31:0] paddr;
wire pwrite;
wire pslverr;
wire [31:0] prdata;
wire pready;

assign data_ready = pready;

APB_Master MASTER (.clock(clock), .reset(reset), .new_data(new_data),.data(data), .addr(addr), .wr(wr),  
                   .enable_clock(enable_clock), .data_out(data_out), .pclk(pclk), .preset_n(preset_n),
                   .psel(psel), .penable(penable), .pwdata(pwdata), .paddr(paddr), .pwrite(pwrite),
                   .pslverr(pslverr), .prdata(prdata), .pready(pready) );
                  
                  
APB_Slave SLAVE (.pclk(pclk),.presetn(preset_n),.psel(psel),.paddr(paddr), .pwdata(pwdata), .penable(penable),.pwrite(pwrite),.prdata(prdata),.pready(pready),.pslverr(pslverr));    
                                   

endmodule 