interface stream_if(
        clk,
        rst
    );
    
    parameter DATA_WIDTH = 8;
    
    input clk;
    input rst;
    
    logic [DATA_WIDTH-1:0]  data;
    logic                   last;        //end of packet or last
    logic                   valid;
    logic                   ready;      
    
    modport master(
            output data,
            output valid,
            output last,
            input  ready
        );
    
    modport slave(
            input  data,
            input  valid,
            input  last,
            output ready
        );
    
endinterface
