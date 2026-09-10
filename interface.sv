interface axi4_if (input bit CLK);
    logic         ARESETn;
    logic [15:0]  AWADDR;
    logic [7:0]   AWLEN;
    logic [2:0]   AWSIZE;
    logic         AWVALID;
    logic         AWREADY;
    logic [31:0]  WDATA;
    logic         WLAST;
    logic         WVALID;
    logic         WREADY;
    logic [1:0]   BRESP;
    logic         BVALID;
    logic         BREADY;
    logic [15:0]  ARADDR;
    logic [7:0]   ARLEN;
    logic [2:0]   ARSIZE;
    logic         ARVALID;
    logic         ARREADY;
    logic [31:0]  RDATA;
    logic [1:0]   RRESP;
    logic         RLAST;
    logic         RVALID;
    logic         RREADY;



modport master (input CLK,
                input ARESETn,
                output AWADDR,
                output AWLEN,
                output AWSIZE,
                output AWVALID,
                input  AWREADY,
                output WDATA,
                output WLAST,
                output WVALID,
                input  WREADY,
                input  BRESP,
                input  BVALID,
                output BREADY,
                output ARADDR,
                output ARLEN,
                output ARSIZE,
                output ARVALID,
                input  ARREADY,
                input  RDATA,
                input  RRESP,
                input  RLAST,
                input  RVALID,
                output RREADY);

modport slave (input CLK,
               input ARESETn,
               input  AWADDR,
               input  AWLEN,
               input  AWSIZE,
               input  AWVALID,
               output AWREADY,
               input  WDATA,
               input  WLAST,
               input  WVALID,
               output WREADY,
               output BRESP,
               output BVALID,
               input  BREADY,
               input  ARADDR,
               input  ARLEN,
               input  ARSIZE,
               input  ARVALID,
               output ARREADY,
               output RDATA,
               output RRESP,
               output RLAST,
               output RVALID,
               input  RREADY);

modport monitor (input CLK,
                 input ARESETn,
                 input  AWADDR,
                 input  AWLEN,
                 input  AWSIZE,
                 input  AWVALID,
                 input  AWREADY,
                 input  WDATA,
                 input  WLAST,
                 input  WVALID,
                 input  WREADY,
                 input  BRESP,
                 input  BVALID,
                 input  BREADY,
                 input  ARADDR,
                 input  ARLEN,
                 input  ARSIZE,
                 input  ARVALID,
                 input  ARREADY,
                 input  RDATA,
                 input  RRESP,
                 input  RLAST,
                 input  RVALID,
                 input  RREADY);


endinterface
