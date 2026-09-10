coverage exclude -src axi4.v -code s -line 208 279

coverage exclude -src axi4.v -code b -line 170 201-208 279

coverage exclude -src axi4.v -code c -line 151-170 181-234 256

coverage exclude -du axi4 -ft write_state W_ADDR->W_IDLE W_DATA->W_IDLE 

coverage exclude -du axi4 -ft read_state R_ADDR->R_IDLE R_WAIT->R_IDLE 

coverage exclude -scope /axi_tb/dut -togglenode {ARADDR[0]} {ARADDR[1]} {ARADDR[12]} {ARADDR[13]}
 {ARADDR[14]} {ARADDR[15]} ARESETn {ARSIZE[0]} {ARSIZE[1]} {ARSIZE[2]}

coverage exclude -scope /axi_tb/dut -togglenode {AWADDR[0]} {AWADDR[1]} {AWADDR[12]} {AWADDR[13]}
 {AWADDR[14]} {AWADDR[15]} {AWSIZE[0]} {AWSIZE[1]} {AWSIZE[2]} BRESP(0)

coverage exclude -scope /axi_tb/dut -togglenode RRESP(0) RVALID WREADY WVALID mem_rdata_reg read_addr(15) read_addr(14) read_addr(13) read_addr(1) read_addr(0)

coverage exclude -scope /axi_tb/dut -togglenode {read_addr_incr[0]} {read_addr_incr[1]} {read_addr_incr[2]} {read_addr_incr[3]} 
{read_addr_incr[4]} {read_addr_incr[5]} {read_addr_incr[6]} {read_addr_incr[7]} {read_addr_incr[8]} {read_addr_incr[9]}

coverage exclude -scope /axi_tb/dut -togglenode {read_addr_incr[10]} {read_addr_incr[11]} {read_addr_incr[12]} {read_addr_incr[13]}
 {read_addr_incr[14]} {read_addr_incr[15]} read_addr_valid read_size(2) read_size(1) read_size(0)

coverage exclude -scope /axi_tb/dut -togglenode read_state(2) write_addr {write_addr_incr[0]} {write_addr_incr[1]}
 {write_addr_incr[2]} {write_addr_incr[3]} {write_addr_incr[4]} {write_addr_incr[5]} {write_addr_incr[6]} {write_addr_incr[7]}

coverage exclude -scope /axi_tb/dut -togglenode {write_addr_incr[8]} {write_addr_incr[9]} {write_addr_incr[10]}
{write_addr_incr[11]} {write_addr_incr[12]} {write_addr_incr[13]} {write_addr_incr[14]} {write_addr_incr[15]} write_boundary_cross write_size(2)

coverage exclude -scope /axi_tb/dut -togglenode write_size(1) write_size(0) write_state(2)

coverage exclude -scope /axi_tb/dut/mem_inst -togglenode j
