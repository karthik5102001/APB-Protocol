module APB_Slave_Reg(
    input pclk,
    input preset_n,
    input pwrite,
    input psel,
    input penable,
    input [31:0] pwdata,
    input [31:0] paddr,
    output reg pready,
    output reg pslverr,
    output reg [31:0] prdata
    );
    
    reg [31:0] GPIO_REG = 32'h0;
    localparam GPIO_REG_ADDR = 32'h0000_0000;
    
    parameter idle = 0, check_operation = 1, write_data = 2, read_data = 3, send_ready = 4;
    reg [2:0] state = idle;
    reg [31:0] addr,wdata;
    
    always_ff @(posedge pclk or negedge preset_n)
    begin
    if(!preset_n)
    begin
    pready <= 1'b0;
    prdata <= 32'h0;
    addr <= 32'b0;
    wdata <= 32'h0;
    state <= idle;
    end
    else 
    begin
        case(state)
        idle : begin
             pready <= 1'b0;
             prdata <= 32'h0;
             addr <= 32'b0;
             wdata <= 32'h0;
        end
        check_operation : begin
            if(penable && psel && pwrite && paddr == 0)
            begin
                state <= write_data;
                addr <= paddr;
                wdata <= pwdata;
            end
            else if (penable && psel && !pwrite && paddr == 0)
                begin
               state <= read_data;
                addr <= paddr;        
                end
        end
        write_data : begin
                GPIO_REG <= wdata;
                pready <= 1'b1;
                state <= send_ready;
        end
        read_data : begin
                prdata <= GPIO_REG;
                pready <= 1'b1;
                state <= send_ready;
        end
        send_ready : begin
                pready <= 1'b0;
                state <= check_operation;
        end
        endcase
    
    end    
    end
    
    assign pslverr = ((state == write_data)&&(state == read_data)&&(pready == 1'b1)) ? 1'b1 : 1'b0;
         
endmodule