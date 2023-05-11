interface axis_if(
        clk,
        rst
    );
    
    parameter DATA_WIDTH = 32;
    parameter USER_WIDTH = 2;
    
    localparam KEEP_WIDTH = DATA_WIDTH/8;
    
    input clk;
    input rst;
    
    logic [DATA_WIDTH-1:0]  data;
    logic [KEEP_WIDTH-1:0]  keep;
    logic                   last;
    logic [USER_WIDTH-1:0]  user;        
    logic                   valid;
    logic                   ready;      
    
    modport master(
            output data,
            output keep,
            output valid,
            output last,
            output user,
            input  ready
        );
    
    modport slave(
            input  data,
            input  keep,
            input  valid,
            input  last,
            input  user,
            output ready
        );
    
endinterface
