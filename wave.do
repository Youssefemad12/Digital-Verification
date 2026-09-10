onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axi_tb/dut/ACLK
add wave -noupdate /axi_tb/dut/ARESETn
add wave -noupdate -expand -group Write -expand -group {Address Write} -radix unsigned /axi_tb/dut/AWADDR
add wave -noupdate -expand -group Write -expand -group {Address Write} /axi_tb/dut/AWLEN
add wave -noupdate -expand -group Write -expand -group {Address Write} /axi_tb/dut/AWSIZE
add wave -noupdate -expand -group Write -expand -group {Address Write} /axi_tb/dut/AWVALID
add wave -noupdate -expand -group Write -expand -group {Address Write} /axi_tb/dut/AWREADY
add wave -noupdate -expand -group Write -expand -group {Write Channel} /axi_tb/dut/WDATA
add wave -noupdate -expand -group Write -expand -group {Write Channel} /axi_tb/dut/WVALID
add wave -noupdate -expand -group Write -expand -group {Write Channel} /axi_tb/dut/WLAST
add wave -noupdate -expand -group Write -expand -group {Write Channel} /axi_tb/dut/WREADY
add wave -noupdate -expand -group Write -expand -group {Write Response} /axi_tb/dut/BRESP
add wave -noupdate -expand -group Write -expand -group {Write Response} /axi_tb/dut/BVALID
add wave -noupdate -expand -group Write -expand -group {Write Response} /axi_tb/dut/BREADY
add wave -noupdate -group Read -group {Read Address} /axi_tb/dut/ARADDR
add wave -noupdate -group Read -group {Read Address} /axi_tb/dut/ARVALID
add wave -noupdate -group Read -group {Read Address} /axi_tb/dut/ARREADY
add wave -noupdate -group Read -group {Read Address} /axi_tb/dut/ARLEN
add wave -noupdate -group Read -group {Read Address} /axi_tb/dut/ARSIZE
add wave -noupdate -group Read -group {Read Data} /axi_tb/dut/RDATA
add wave -noupdate -group Read -group {Read Data} /axi_tb/dut/RVALID
add wave -noupdate -group Read -group {Read Data} /axi_tb/dut/RLAST
add wave -noupdate -group Read -group {Read Data} /axi_tb/dut/RREADY
add wave -noupdate -group Read /axi_tb/dut/RRESP
add wave -noupdate -group Internals -radix unsigned /axi_tb/dut/mem_addr
add wave -noupdate -group Internals /axi_tb/dut/mem_wdata
add wave -noupdate -group Internals /axi_tb/dut/mem_rdata
add wave -noupdate -group Internals -radix unsigned /axi_tb/dut/write_addr
add wave -noupdate -group Internals /axi_tb/dut/read_addr
add wave -noupdate -group Internals /axi_tb/dut/write_burst_len
add wave -noupdate -group Internals /axi_tb/dut/read_burst_len
add wave -noupdate -group Internals /axi_tb/dut/write_burst_cnt
add wave -noupdate -group Internals /axi_tb/dut/read_burst_cnt
add wave -noupdate -group Internals /axi_tb/dut/write_size
add wave -noupdate -group Internals /axi_tb/dut/read_size
add wave -noupdate -group Internals /axi_tb/dut/write_addr_incr
add wave -noupdate -group Internals /axi_tb/dut/read_addr_incr
add wave -noupdate -group Internals /axi_tb/dut/write_boundary_cross
add wave -noupdate -group Internals /axi_tb/dut/read_boundary_cross
add wave -noupdate -group Internals /axi_tb/dut/write_addr_valid
add wave -noupdate -group Internals /axi_tb/dut/read_addr_valid
add wave -noupdate -group Internals /axi_tb/dut/write_state
add wave -noupdate -group Internals /axi_tb/dut/read_state
add wave -noupdate -group Internals /axi_tb/dut/mem_rdata_reg
add wave -noupdate -group Internals /axi_tb/dut/mem_en
add wave -noupdate -group Internals /axi_tb/dut/mem_we
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/ADDR_WIDTH
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/rst_n
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/DATA_WIDTH
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/DEPTH
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/j
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/mem_addr
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/mem_en
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/mem_rdata
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/mem_wdata
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/mem_we
add wave -noupdate -expand -group Memory /axi_tb/dut/mem_inst/memory
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {33960275 ps} {33960549 ps}
