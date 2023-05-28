`default_nettype none

module sram_sdp(
      clk,
      inf
    );
    
    parameter RAM_STYLE = "auto";   //"block", "distributed", "registers", "ultra"
    parameter REG_STAGES = 0;       //0, 1   
    
    input logic             clk;
    ram_if.slave            inf;      

    (* ram_style = RAM_STYLE *)  reg [inf.DATA_WIDTH-1:0] mem[inf.DEPTH];
  
    logic [inf.DATA_WIDTH-1:0]  dout0;
    logic [inf.DATA_WIDTH-1:0]  dout1;
    logic                       dval0;
    logic                       dval1;

    initial begin
        for (int i=0; i<inf.DEPTH; i++)
            mem[i] = '0;
    end
    
    generate
        if (REG_STAGES == 1) begin
            assign inf.doutb = dout1;
            assign inf.dvalb = dval1;
        end
        else begin 
            assign inf.doutb = dout0;
            assign inf.dvalb = dval0;
        end
    endgenerate
    
    always@(posedge clk) begin
        if (inf.wea)
            mem[inf.addra]  <= inf.dina;

        dout0 <= mem[inf.addrb];
        dout1 <= inf.doutb;

        dval0 <= inf.reb;
        dval1 <= dval1;
    end

endmodule
