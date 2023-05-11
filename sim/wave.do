onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group m /tb_axis/m_axis_if/clk
add wave -noupdate -expand -group m /tb_axis/m_axis_if/rst
add wave -noupdate -expand -group m /tb_axis/m_axis_if/data
add wave -noupdate -expand -group m /tb_axis/m_axis_if/keep
add wave -noupdate -expand -group m /tb_axis/m_axis_if/last
add wave -noupdate -expand -group m /tb_axis/m_axis_if/user
add wave -noupdate -expand -group m /tb_axis/m_axis_if/valid
add wave -noupdate -expand -group m /tb_axis/m_axis_if/ready
add wave -noupdate -expand -group s /tb_axis/s_axis_if/clk
add wave -noupdate -expand -group s /tb_axis/s_axis_if/rst
add wave -noupdate -expand -group s /tb_axis/s_axis_if/data
add wave -noupdate -expand -group s /tb_axis/s_axis_if/keep
add wave -noupdate -expand -group s /tb_axis/s_axis_if/last
add wave -noupdate -expand -group s /tb_axis/s_axis_if/user
add wave -noupdate -expand -group s /tb_axis/s_axis_if/valid
add wave -noupdate -expand -group s /tb_axis/s_axis_if/ready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {30 ns} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ns} {250 ns}
