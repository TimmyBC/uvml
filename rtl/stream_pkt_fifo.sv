`default_nettype none

module stream_pkt_fifo(
    clk,
    rst,

    s_data, 
    s_last,    
    s_header,   
    s_drop,     //if not required always assign to 0
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
    parameter   INSERT_HEADER       = 0;

    localparam  ADDR_WIDTH          = $clog2(DEPTH);
    localparam  PROG_FULL_THRESH    = DEPTH - MAX_PKT_BEATS - 1;
    localparam  DATA_OFFSET         = INSERT_HEADER ? 1'b1 : 1'b0;

    input  logic                    clk;
    input  logic                    rst;
    
    input  logic [DATA_WIDTH-1:0]   s_data;
    input  logic                    s_last;
    input  logic [DATA_WIDTH-1:0]   s_header;
    input  logic                    s_drop;
    input  logic                    s_valid;
    output logic                    s_ready;
        
    output logic [DATA_WIDTH-1:0]   m_data;
    output logic                    m_last;
    output logic                    m_valid;
    input  logic                    m_ready;

    logic [ADDR_WIDTH:0]    waddr;      //for a given packet xaddr <= waddr < (waddr + MAX_PKT_BEATS)
    logic [ADDR_WIDTH:0]    xaddr;
    logic [ADDR_WIDTH:0]    xaddr_reg;
    logic [DATA_WIDTH:0]    wdata;
    logic [DATA_WIDTH-1:0]  header;
    logic                   wen;
    logic [ADDR_WIDTH:0]    count;
    logic                   empty;
    logic                   full;
    logic                   prgfull;
    logic [DATA_WIDTH:0]    o_data;
    logic                   o_valid;
    logic                   o_ready;

    initial begin        
        assert((MAX_PKT_BEATS > 0) && (MAX_PKT_BEATS < DEPTH - 1)) else $fatal(1, "%m | 0 < MAX_PKT_BEATS (%0d) < DEPTH (%0d) - 1", MAX_PKT_BEATS, DEPTH);
    end

    ram_fifo#(
        .DATA_WIDTH (DATA_WIDTH + 1),
        .DEPTH      (DEPTH)
    ) u_ram_fifo (
        .clk    (clk),
        .rst    (rst),

        .waddr  (waddr),
        .wdata  (wdata),
        .wen    (wen),
        .full   (full),
        .empty  (empty),
        .count  (count),
        .xaddr  (xaddr_reg),
        
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

    assign prgfull      = count >= PROG_FULL_THRESH;

    enum {ST_WAIT, ST_DATA, ST_HDR, ST_UPDT} state;

    always_ff@(posedge clk) begin
        if (rst) begin
            waddr                   <= INSERT_HEADER ? '0 : '1;
            xaddr                   <= '0;
            wen                     <= 1'b0;
            s_ready                 <= 1'b0;
            state                   <= ST_WAIT;
        end
        else begin
            case (state)
                ST_WAIT: begin             
                    wen                 <= 1'b0;       
                    if (~prgfull) begin
                        s_ready         <= 1'b1;  
                        state           <= ST_DATA;
                    end
                end
                ST_DATA: begin
                    s_ready             <= 1'b1;
                    wen                 <= 1'b0;
                    if (s_valid & s_ready) begin
                        wen             <= 1'b1;
                        waddr           <= waddr + 1'b1;
                        if (s_last) begin                            
                            s_ready     <= 1'b0;
                            if (INSERT_HEADER) begin
                                state   <= (s_drop) ? ST_UPDT : ST_HDR;
                            end
                            else begin
                                if (s_drop) begin
                                    waddr   <= xaddr - 1'b1;
                                    wen     <= 1'b0;
                                end
                                else begin
                                    xaddr   <= waddr + ADDR_WIDTH'(2);
                                end
                                state   <= ST_WAIT;
                            end
                        end
                    end
                end
                ST_HDR: begin
                    waddr               <= xaddr;
                    wen                 <= 1'b1;
                    xaddr               <= waddr + 1'b1;
                    state               <= ST_UPDT;
                end
                ST_UPDT: begin
                    wen                 <= 1'b0;
                    waddr               <= xaddr;
                    state               <= ST_WAIT;
                end
            endcase            
        end
    end

    always_ff@(posedge clk) begin
        xaddr_reg                   <= xaddr;

        if (s_valid & s_last) begin
            header                  <= s_header;
        end

        case (state)
            ST_DATA: begin
                wdata               <= {s_last, s_data};
            end
            ST_HDR: begin
                wdata               <= {1'b0, header};
            end
        endcase          
    end
endmodule
