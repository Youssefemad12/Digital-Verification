import axi4_pkg::*;
import mem_transaction_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top;
    axi4_if axi4_vif();
    mem_if  mem_vif();

    axi4 dut (
        .ACLK(axi4_vif.ACLK),.ARESETn(axi4_vif.ARESETn),
        .AWADDR(axi4_vif.AWADDR),.AWLEN(axi4_vif.AWLEN),
        .AWSIZE(axi4_vif.AWSIZE),.AWVALID(axi4_vif.AWVALID),
        .AWREADY(axi4_vif.AWREADY),.WDATA(axi4_vif.WDATA),
        .WLAST(axi4_vif.WLAST),.WVALID(axi4_vif.WVALID),
        .WREADY(axi4_vif.WREADY),.BRESP(axi4_vif.BRESP),
        .BVALID(axi4_vif.BVALID),.BREADY(axi4_vif.BREADY),
        .ARADDR(axi4_vif.ARADDR),.ARLEN(axi4_vif.ARLEN),
        .ARSIZE(axi4_vif.ARSIZE),.ARVALID(axi4_vif.ARVALID),
        .ARREADY(axi4_vif.ARREADY),.RDATA(axi4_vif.RDATA),
        .RRESP(axi4_vif.RRESP),.RLAST(axi4_vif.RLAST),
        .RVALID(axi4_vif.RVALID),.RREADY(axi4_vif.RREADY)
    );

    assign mem_vif.clk       = axi4_vif.ACLK;
    assign mem_vif.rst_n     = axi4_vif.ARESETn;
    assign mem_vif.mem_en    = dut.mem_en;
    assign mem_vif.mem_we    = dut.mem_we;
    assign mem_vif.mem_addr  = dut.mem_addr;
    assign mem_vif.mem_wdata = dut.mem_wdata;
    assign mem_vif.mem_rdata = dut.mem_rdata;

    always #5 axi4_vif.ACLK = ~axi4_vif.ACLK;

    initial begin
        axi4_vif.ACLK = 0;
        axi4_vif.ARESETn = 0;
        #5
        axi4_vif.ARESETn = 1;
    end

    initial begin
        uvm_config_db #(uvm_active_passive_enum)::set(null,"uvm_test_top.env.agt","is_active",UVM_ACTIVE);
        uvm_config_db #(virtual axi4_if)::set(null,"uvm_test_top.env.agt.*","vif",axi4_vif);
        uvm_config_db #(virtual mem_if)::set(null,"uvm_test_top.env.mem_agt.*","vif",mem_vif);
        run_test("axi4_test");
    end
endmodule
