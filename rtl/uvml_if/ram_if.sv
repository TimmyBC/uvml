interface ram_if();
     
    parameter DATA_WIDTH    = 8;
    parameter DEPTH         = 16;    
    
    localparam ADDR_WIDTH   = $clog2(DEPTH);
    
    logic [ADDR_WIDTH-1:0]  addra;
    logic [DATA_WIDTH-1:0]  dina;
    logic                   wea;
    logic                   rea;
    logic [DATA_WIDTH-1:0]  douta;
    logic                   dvala;

    logic [ADDR_WIDTH-1:0]  addrb;
    logic [DATA_WIDTH-1:0]  dinb;
    logic                   web;
    logic                   reb;
    logic [DATA_WIDTH-1:0]  doutb;   
    logic                   dvalb;

    modport master(
            output addra,
            output dina,
            output wea,
            output rea,
            input  douta,
            input  dvala,

            output addrb,
            output dinb,
            output web,
            output reb,
            input  doutb,
            input  dvalb
        );
    
    modport slave(
            input  addra,
            input  dina,
            input  wea,
            input  rea,
            output douta,
            output dvala,
            
            input  addrb,
            input  dinb,
            input  web,
            input  reb,
            output doutb,
            output dvalb
        );
    
endinterface
