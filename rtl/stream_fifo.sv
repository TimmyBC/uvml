`default_nettype none

module stream_fifo(
    clk,
    rst,

    s_data, 
    s_last,     //if MAX_PKT_BEATS == 0 then s_last is optional  
    s_valid,
    s_ready,
    
    m_data,
    m_last,
    m_valid,
    m_ready
);

    parameter   DATA_WIDTH          = 8;
    parameter   DEPTH               = 16;
    parameter   RDY_BEFORE_VLD      = 0;    //1 implies m_ready is required before m_valid. 0 means first word fall through which adds another clock cycle latency.
    parameter   MAX_PKT_BEATS       = 0;    //MAX_PKT_BEATS > 0 implies, s_ready does not toggle in the middle of a packet (terminated by last), given that the number of beats in a packet is <= MAX_PKT_BEATS

    localparam  ADDR_WIDTH          = $clog2(DEPTH);
    localparam  PROG_FULL_THRESH    = DEPTH - MAX_PKT_BEATS;

    input  logic                    clk;
    input  logic                    rst;
    
    input  logic [DATA_WIDTH-1:0]   s_data;
    input  logic                    s_last;
    input  logic                    s_valid;
    output logic                    s_ready;
        
    output logic [DATA_WIDTH-1:0]   m_data;
    output logic                    m_last;
    output logic                    m_valid;
    input  logic                    m_ready;

    logic [ADDR_WIDTH:0]    waddr;
    logic                   wen;
    logic [ADDR_WIDTH:0]    count;
    logic                   empty;
    logic                   full;
    logic                   prgfull;
    logic [DATA_WIDTH:0]    o_data;
    logic                   o_valid;
    logic                   o_ready;

    initial begin
        assert(MAX_PKT_BEATS < DEPTH - 1) else $fatal(1, "%m | MAX_PKT_BEATS (%0d) < DEPTH (%0d) - 1", MAX_PKT_BEATS, DEPTH);
    end

    ram_fifo#(
        .DATA_WIDTH (DATA_WIDTH + 1),
        .DEPTH      (DEPTH)
    ) u_ram_fifo (
        .clk    (clk),
        .rst    (rst),

        .waddr  (waddr),
        .wdata  ({s_last, s_data}),
        .wen    (wen),
        .full   (full),
        .empty  (empty),
        .count  (count),
        .xaddr  (waddr),
        
        .m_data (o_data),
        .m_valid(o_valid),
        .m_ready(o_ready)
    );

    generate
        if (RDY_BEFORE_VLD == 1) begin
            assign {m_last, m_data} = o_data;
            assign m_valid          = o_valid;
            assign o_ready          = m_ready;
        end
        else begin
            reg_slice#(
                .DATA_WIDTH(DATA_WIDTH + 1)
            ) fwft_reg_slice (
                .clk    (clk),
                .rst    (rst),    
                
                .s_data (o_data),
                .s_valid(o_valid),
                .s_ready(o_ready),
                
                .m_data ({m_last, m_data}),
                .m_valid(m_valid),
                .m_ready(m_ready)
            );
        end
    endgenerate

    assign prgfull      = (count >= PROG_FULL_THRESH);
    assign wen          = s_valid & s_ready;

    always_ff @(posedge clk) begin
        if (rst) begin
            waddr           <= '0;
        end
        else begin
            if (wen) begin
                waddr   <= waddr + 1'b1;
            end
        end
    end

    generate
        if (MAX_PKT_BEATS == 0) begin
            assign s_ready  = ~full;
        end
        else begin
            always_ff@(posedge clk) begin
                if (rst) begin
                    s_ready     <= 1'b0;
                end
                else begin
                    if (prgfull & s_valid & s_ready & s_last) begin
                        s_ready <= 1'b0;
                    end
                    else if (~prgfull) begin
                        s_ready <= 1'b1;
                    end
                end
            end
        end
    endgenerate

endmodule