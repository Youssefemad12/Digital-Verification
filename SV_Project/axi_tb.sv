import signals_pkg::*;
import gen_pkg::*;
import driver::*;
import monitor_pkg::*;
import scb_pkg::*;
import env_pkg::*;

module axi_tb ();

    bit clk = 1'b0;

    always #5 clk = ~clk;

    axi4_if intrf (.CLK(clk));

    axi4 dut (
        .ACLK(clk),
        .ARESETn(intrf.ARESETn),
        .AWADDR(intrf.AWADDR),
        .AWLEN(intrf.AWLEN),
        .AWSIZE(intrf.AWSIZE),
        .AWVALID(intrf.AWVALID),
        .AWREADY(intrf.AWREADY),
        .WDATA(intrf.WDATA),
        .WLAST(intrf.WLAST),
        .WVALID(intrf.WVALID),
        .WREADY(intrf.WREADY),
        .BRESP(intrf.BRESP),
        .BVALID(intrf.BVALID),
        .BREADY(intrf.BREADY),
        .ARADDR(intrf.ARADDR),
        .ARLEN(intrf.ARLEN),
        .ARSIZE(intrf.ARSIZE),
        .ARVALID(intrf.ARVALID),
        .ARREADY(intrf.ARREADY),
        .RDATA(intrf.RDATA),
        .RRESP(intrf.RRESP),
        .RLAST(intrf.RLAST),
        .RVALID(intrf.RVALID),
        .RREADY(intrf.RREADY)
    );

    enviroment env;

    initial begin
        intrf.ARESETn = 1'b0;

        repeat (3)
            @(negedge clk);

        intrf.ARESETn = 1'b1;
        @(negedge clk);

        env = new();
        env.axi_if  = intrf.master;
        env.axi_mon = intrf.monitor;
        env.run_env();
    end

endmodule
