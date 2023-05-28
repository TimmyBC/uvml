`default_nettype none

module ram_fifo(
    clk,
    rst,

    waddr,  
    wdata,
    wen,
    full,   //relative to xaddr only, not updated with waddr
    empty,  //relative to xaddr only, not updated with waddr
    count,  //relative to xaddr only, not updated with waddr
    xaddr,  //addr that is exposed read side. it can be ready only upto xaddr
    
    m_data,
    m_valid,
    m_ready
);

    parameter   DATA_WIDTH          = 8;
    parameter   DEPTH               = 16;
    // parameter   MAX_PKT_BEATS       = 0;

    localparam  ADDR_WIDTH          = $clog2(DEPTH);
    // localparam  PROG_FULL_THRESH    = DEPTH - MAX_PKT_BEATS;

    input  logic                    clk;
    input  logic                    rst;
    
    input  logic [ADDR_WIDTH:0]     waddr;
    input  logic [DATA_WIDTH-1:0]   wdata;
    input  logic                    wen;
    output logic                    full;
    output logic                    empty;
    // output logic                    prgfull;      
    output logic [ADDR_WIDTH:0]     count;
    input  logic [ADDR_WIDTH:0]     xaddr;

    output logic [DATA_WIDTH-1:0]   m_data;
    output logic                    m_valid;
    input  logic                    m_ready;

    logic [ADDR_WIDTH:0]    raddr;
    logic [ADDR_WIDTH:0]    diff;
    logic [DATA_WIDTH-1:0]  data;
    logic                   latch;

    ram_if#(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) ram();

    sram_sdp u_sram(
        .clk    (clk),
        .inf    (ram)
    );

    assign ram.addra    = waddr[ADDR_WIDTH-1:0];
    assign ram.addrb    = raddr[ADDR_WIDTH-1:0];
    assign ram.dina     = wdata;//s_data;
    assign ram.wea      = wen; //s_valid & s_ready;
    assign ram.reb      = m_ready & ~empty;
    assign m_valid      = ram.dvalb | latch;
    assign m_data       = (latch) ? data : ram.doutb;

    assign diff         = xaddr - raddr; //waddr - raddr;
    assign count        = diff;//[ADDR_WIDTH-1:0];
    // assign prgfull      = count >= PROG_FULL_THRESH;
    assign empty        = (count[ADDR_WIDTH-1:0] == '0) & ~diff[ADDR_WIDTH]; 
    assign full         = (count[ADDR_WIDTH-1:0] == '0) & diff[ADDR_WIDTH];

    always_ff @(posedge clk) begin
        if (rst) begin
            // waddr           <= '0;
            raddr           <= '0;
            latch           <= 1'b0;
        end
        else begin
            if (ram.dvalb) begin
                data        <= ram.doutb;
            end
            
            if (ram.dvalb & ~m_ready) begin
                latch       <= 1'b1;
            end
            else if (m_ready) begin
                latch       <= 1'b0;
            end

            // if (ram.wea) begin
            //     waddr   <= waddr + 1'b1;
            // end

            if (ram.reb) begin
                raddr   <= raddr + 1'b1;
            end
        end
    end

    // generate
    //     if (MAX_PKT_BEATS == 0) begin
    //         assign s_ready  = ~full;
    //     end
    //     else begin
    //         always_ff@(posedge clk) begin
    //             if (rst) begin
    //                 s_ready     <= 1'b0;
    //             end
    //             else begin
    //                 if (prgfull & s_valid & s_ready & slave.last) begin
    //                     s_ready <= 1'b0;
    //                 end
    //                 else if (~prgfull) begin
    //                     s_ready <= 1'b1;
    //                 end
    //             end
    //         end
    //     end
    // endgenerate

endmodule