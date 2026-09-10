import axi4_assertions_pkg::*;
interface  axi4_if #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter MEMORY_DEPTH = 1024
);

    logic                      ACLK;
    logic                      ARESETn;

    logic  [ADDR_WIDTH-1:0]    AWADDR;
    logic  [7:0]               AWLEN;
    logic  [2:0]               AWSIZE;
    logic                      AWVALID;
    logic                      AWREADY;

    logic  [DATA_WIDTH-1:0]    WDATA;
    logic                      WVALID;
    logic                      WLAST;
    logic                      WREADY;

    logic [1:0]                BRESP;
    logic                      BVALID;
    logic                      BREADY;

    logic  [ADDR_WIDTH-1:0]    ARADDR;
    logic  [7:0]               ARLEN;
    logic  [2:0]               ARSIZE;
    logic                      ARVALID;
    logic                      ARREADY;

    logic [DATA_WIDTH-1:0]     RDATA;
    logic [1:0]                RRESP;
    logic                      RVALID;
    logic                      RLAST;
    logic                      RREADY;


    a_reset : assert property (
        p_reset(
            ACLK, ARESETn,
            AWREADY, WREADY, BVALID,
            ARREADY, RVALID, RLAST
        )
    );
    a_w_stable : assert property (
        w_stable(
            ACLK, ARESETn,
            WVALID, WREADY,
            WDATA, WLAST
        )
    );
    a_bresp_valid : assert property (
        bresp_valid(
            ACLK, ARESETn,
            BVALID, BRESP
        )
    );
    a_rresp_valid : assert property (
        rresp_valid(
            ACLK, ARESETn,
            RVALID, RRESP
        )
    );
    a_no_unknown : assert property (
        unknown_outputs(
            ACLK,
            ARESETn,
            {AWREADY,WREADY,BRESP,BVALID,ARREADY,RDATA,RRESP,RVALID,RLAST}
        )
    );
    w_handshake : cover property (
        @(posedge ACLK) disable iff (!ARESETn)
        WVALID && WREADY
    );
endinterface
