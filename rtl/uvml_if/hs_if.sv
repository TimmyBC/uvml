/* *** Handshake Interface ***
 * 
 * Handshake agent is written to support any hanshake interface, not limiting to 'hs_if'.  
 * Because system verilog interfaces does not support inheritance or abstraction, 
 * you are supposed to implement the below functions, if you write a new interface.
 * 
 * pure virtual function int get_data_width();
 * pure virtual function void set_valid(logic [0:0] valid, logic [DATA_WIDTH-1:0] data);
 * pure virtual function void get_valid(output logic [0:0] valid, output logic [DATA_WIDTH-1:0] data);
 * pure virtual function void set_ready(logic [0:0] ready);
 * pure virtual function void get_ready(output logic [0:0] ready);
 * 
 */


//    typedef enum {HS_IF_SYNTH, HS_IF_SIM_MASTER, HS_IF_SIM_SLAVE} HS_IF_MODE;

    
interface hs_if(
		clk,
		rst
	);
    
	parameter DATA_WIDTH = 8;
    
//	parameter HS_IF_MODE IF_MODE = HS_IF_SYNTH;
    
	input clk;
	input rst;
	
	logic [DATA_WIDTH-1:0] 	data;
	logic					valid;
	logic					ready;		//can also be used as an 'ack' signal
	
	modport master(
			output data,
			output valid,
			input  ready
		);
	
	modport slave(
			input  data,
			input  valid,
			output ready
		);
	
    
    
//    generate 
//        
//        if (IF_MODE != HS_IF_SYNTH) begin
//            function int get_data_width();
//                return DATA_WIDTH;  
//            endfunction
//        end
//        
//        if (IF_MODE ==  HS_IF_SIM_SLAVE) begin
//            function void get_valid(output logic [0:0] v, output logic [DATA_WIDTH-1:0] d);
//                v = valid;
//                d = data;
//            endfunction   
//
//            function void set_ready(logic [0:0] r);
//                    ready = r;
//            endfunction            
//        end
//        
//        if (IF_MODE ==  HS_IF_SIM_MASTER) begin
//            function void set_valid(logic [0:0] v, logic [DATA_WIDTH-1:0] d = 'x);
//                valid = v;
//                data = d;
//            endfunction
//  
//            function void get_ready(output logic [0:0] r);
//                r = ready;
//            endfunction          
//        end
//    endgenerate
    
//    function void set_valid(logic [0:0] v, logic [DATA_WIDTH-1:0] d = 'x);
//        master.valid = v;
//        data = d;
//    endfunction
//    
//    function void get_valid(output logic [0:0] v, output logic [DATA_WIDTH-1:0] d);
//        v = valid;
//        d = data;
//    endfunction
//    
//    function void set_ready(logic [0:0] r);
//        if (IF_MODE == HS_IF_SLAVE)
//            ready = r;
//    endfunction
//    
//    function void get_ready(output logic [0:0] r);
//        r = ready;
//    endfunction
    
endinterface 