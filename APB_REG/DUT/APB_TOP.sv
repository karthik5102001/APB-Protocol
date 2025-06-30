module APB_TB (
    input clock,
    input reset,
    input new_data,
    input [31:0] data,
    input [31:0] addr,
    input wr,
    input enable_clock,
    output [31:0] data_out
);

reg clock;
reg reset;
reg new_data;
reg [31:0] data;
reg [31:0] addr;
reg wr;
reg enable_clock;
reg [31:0] data_out;

wire pclk,preset_n,psel,penable;
wire [31:0] pwdata;
wire [31:0] paddr;
wire pwrite;
wire pslverr;
wire [31:0] prdata;
wire pready;

APB_Master MASTER (clock, reset, new_data, data, addr, wr,  
                   enable_clock, data_out, pclk,preset_n,
                   psel,penable, pwdata, paddr, pwrite,
                   pslverr, prdata, pready );
                  
                  
APB_Slave_Reg SLAVE (pclk, preset_n, psel, penable, pwdata, paddr, pwrite,
                     pslverr, prdata, pready );    
                                   

endmodule 