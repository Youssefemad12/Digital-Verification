onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/axi4_vif/ACLK
add wave -noupdate /top/axi4_vif/a_reset
add wave -noupdate /top/axi4_vif/ARESETn
add wave -noupdate -expand -group Write -expand -group {Write Address} /top/axi4_vif/AWADDR
add wave -noupdate -expand -group Write -expand -group {Write Address} /top/axi4_vif/AWLEN
add wave -noupdate -expand -group Write -expand -group {Write Address} /top/axi4_vif/AWVALID
add wave -noupdate -expand -group Write -expand -group {Write Address} /top/axi4_vif/AWREADY
add wave -noupdate -expand -group Write -expand -group {Write Address} /top/axi4_vif/AWSIZE
add wave -noupdate -expand -group Write -expand -group {Write data} /top/axi4_vif/a_w_stable
add wave -noupdate -expand -group Write -expand -group {Write data} /top/axi4_vif/WDATA
add wave -noupdate -expand -group Write -expand -group {Write data} /top/axi4_vif/WLAST
add wave -noupdate -expand -group Write -expand -group {Write data} /top/axi4_vif/WREADY
add wave -noupdate -expand -group Write -expand -group {Write data} /top/axi4_vif/WVALID
add wave -noupdate -expand -group Write -expand -group {Write response} /top/axi4_vif/a_bresp_valid
add wave -noupdate -expand -group Write -expand -group {Write response} /top/axi4_vif/BREADY
add wave -noupdate -expand -group Write -expand -group {Write response} /top/axi4_vif/BRESP
add wave -noupdate -expand -group Write -expand -group {Write response} /top/axi4_vif/BVALID
add wave -noupdate -expand -group Read -group {Read Address} /top/axi4_vif/ARADDR
add wave -noupdate -expand -group Read -group {Read Address} /top/axi4_vif/ARLEN
add wave -noupdate -expand -group Read -group {Read Address} /top/axi4_vif/ARREADY
add wave -noupdate -expand -group Read -group {Read Address} /top/axi4_vif/ARSIZE
add wave -noupdate -expand -group Read -group {Read Address} /top/axi4_vif/ARVALID
add wave -noupdate -expand -group Read -group {Read Response} /top/axi4_vif/RDATA
add wave -noupdate -expand -group Read -group {Read Response} /top/axi4_vif/RLAST
add wave -noupdate -expand -group Read -group {Read Response} /top/axi4_vif/RREADY
add wave -noupdate -expand -group Read -group {Read Response} /top/axi4_vif/a_rresp_valid
add wave -noupdate -expand -group Read -group {Read Response} /top/axi4_vif/RRESP
add wave -noupdate -expand -group Read -group {Read Response} /top/axi4_vif/RVALID
add wave -noupdate /top/dut/read_state
add wave -noupdate /top/dut/write_state
add wave -noupdate /top/axi4_vif/a_no_unknown
add wave -noupdate -group Memory /top/dut/mem_inst/ADDR_WIDTH
add wave -noupdate -group Memory /top/dut/mem_inst/clk
add wave -noupdate -group Memory /top/dut/mem_inst/DATA_WIDTH
add wave -noupdate -group Memory /top/dut/mem_inst/DEPTH
add wave -noupdate -group Memory /top/dut/mem_inst/j
add wave -noupdate -group Memory /top/dut/mem_inst/mem_addr
add wave -noupdate -group Memory /top/dut/mem_inst/mem_en
add wave -noupdate -group Memory /top/dut/mem_inst/mem_rdata
add wave -noupdate -group Memory /top/dut/mem_inst/mem_wdata
add wave -noupdate -group Memory /top/dut/mem_inst/mem_we
add wave -noupdate -group Memory /top/dut/mem_inst/memory
add wave -noupdate -group Memory /top/dut/mem_inst/rst_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5982645 ns} 0}
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
WaveRestoreZoom {5982133 ns} {5983157 ns}
