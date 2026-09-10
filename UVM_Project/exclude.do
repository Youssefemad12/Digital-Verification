coverage exclude -src axi4.v -code s -line 187 208 249-250 279
coverage exclude -src axi4.v -code b -line 170-172 186 201-208 234 248 265 279
coverage exclude -src axi4.v -code e -line 64-70
coverage exclude -src axi4.v -code c -line 151-256 265
coverage exclude -du axi4 -ft write_state W_ADDR->W_IDLE W_DATA->W_IDLE 
coverage exclude -du axi4 -ft read_state R_ADDR->R_IDLE R_WAIT->R_IDLE 
coverage exclude -scope /top/dut -togglenode {ARADDR[0]} {ARADDR[1]} {ARADDR[12]} {ARADDR[13]} {ARADDR[14]} {ARADDR[15]} ARESETn {ARSIZE[0]} {ARSIZE[2]} {AWADDR[0]}
coverage exclude -scope /top/dut -togglenode {AWADDR[1]} {AWADDR[12]} {AWADDR[13]} {AWADDR[14]} {AWADDR[15]} {AWSIZE[0]} {AWSIZE[2]} BRESP(1) BRESP(0) RRESP
coverage exclude -scope /top/dut -togglenode WLAST WREADY mem_rdata_reg read_addr(15) read_addr(14) read_addr(13) read_addr(12) read_addr(1) read_addr(0) {read_addr_incr[0]}
coverage exclude -scope /top/dut -togglenode {read_addr_incr[1]} {read_addr_incr[2]} {read_addr_incr[3]} {read_addr_incr[4]} {read_addr_incr[5]} {read_addr_incr[6]} {read_addr_incr[7]} {read_addr_incr[8]} {read_addr_incr[9]} {read_addr_incr[10]}
coverage exclude -scope /top/dut -togglenode {read_addr_incr[11]} {read_addr_incr[12]} {read_addr_incr[13]} {read_addr_incr[14]} {read_addr_incr[15]} read_addr_valid read_boundary_cross read_size read_state(2) write_addr
coverage exclude -scope /top/dut -togglenode {write_addr_incr[0]} {write_addr_incr[1]} {write_addr_incr[2]} {write_addr_incr[3]} {write_addr_incr[4]} {write_addr_incr[5]} {write_addr_incr[6]} {write_addr_incr[7]} {write_addr_incr[8]} {write_addr_incr[9]}
coverage exclude -scope /top/dut -togglenode {write_addr_incr[10]} {write_addr_incr[11]} {write_addr_incr[12]} {write_addr_incr[13]} {write_addr_incr[14]} {write_addr_incr[15]} write_addr_valid write_boundary_cross write_size write_state(2)
