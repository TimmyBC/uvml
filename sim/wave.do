onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group inp /tb_pkt_fifo/m_axis_if/clk
add wave -noupdate -expand -group inp /tb_pkt_fifo/m_axis_if/rst
add wave -noupdate -expand -group inp /tb_pkt_fifo/m_axis_if/data
add wave -noupdate -expand -group inp /tb_pkt_fifo/m_axis_if/keep
add wave -noupdate -expand -group inp /tb_pkt_fifo/m_axis_if/last
add wave -noupdate -expand -group inp /tb_pkt_fifo/m_axis_if/user
add wave -noupdate -expand -group inp /tb_pkt_fifo/m_axis_if/valid
add wave -noupdate -expand -group inp /tb_pkt_fifo/m_axis_if/ready
add wave -noupdate -expand -group out /tb_pkt_fifo/s_axis_if/clk
add wave -noupdate -expand -group out /tb_pkt_fifo/s_axis_if/rst
add wave -noupdate -expand -group out /tb_pkt_fifo/s_axis_if/data
add wave -noupdate -expand -group out /tb_pkt_fifo/s_axis_if/keep
add wave -noupdate -expand -group out /tb_pkt_fifo/s_axis_if/last
add wave -noupdate -expand -group out /tb_pkt_fifo/s_axis_if/user
add wave -noupdate -expand -group out /tb_pkt_fifo/s_axis_if/valid
add wave -noupdate -expand -group out /tb_pkt_fifo/s_axis_if/ready
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/wen
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/wdata
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/waddr
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/xaddr
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/u_ram_fifo/ram/addra
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/u_ram_fifo/ram/dina
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/u_ram_fifo/ram/wea
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/u_ram_fifo/ram/addrb
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/u_ram_fifo/ram/reb
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/u_ram_fifo/ram/doutb
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/u_ram_fifo/ram/dvalb
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/empty
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/u_ram_fifo/raddr
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/u_ram_fifo/count
add wave -noupdate /tb_pkt_fifo/u_pkt_fifo/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18854 ns} 0} {{Cursor 2} {115 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {77 ns} {271 ns}
