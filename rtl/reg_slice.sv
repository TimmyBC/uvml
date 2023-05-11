module reg_slice(
        clk,
        rst,    
        
        s_data,
        s_valid,
        s_ready,
        
        m_data,
        m_valid,
        m_ready
    );
    
    parameter    DATA_WIDTH          = 8;

    input                           clk;
    input                           rst;
    
    input        [DATA_WIDTH-1:0]   s_data;
    input                           s_valid;
    output logic                    s_ready;
        
    output logic [DATA_WIDTH-1:0]   m_data;
    output logic                    m_valid;
    input                           m_ready;
   

    logic        [DATA_WIDTH-1:0]   data;

    always_ff@(posedge clk) begin
        if (rst) begin
            s_ready     <= '0;
            m_valid     <= '0;
        end
        else begin
            m_valid     <= s_valid | (m_valid & ~s_ready) | (m_valid & s_ready & ~m_ready);
            s_ready     <= m_ready | ~m_valid | (s_ready & ~s_valid);
        end
    end

    always_ff@(posedge clk) begin
        if (m_ready | ~m_valid) begin 
            m_data      <= (s_ready) ? s_data : data;
        end
        
        if (s_ready) begin
            data        <= s_data;
        end
    end
    
endmodule
