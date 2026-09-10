interface mem_if #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,    // For 1024 locations
    parameter DEPTH = 1024
);
    logic                     clk;
    logic                     rst_n;
    logic                     mem_en;
    logic                     mem_we;
    logic [ADDR_WIDTH-1:0]    mem_addr;
    logic [DATA_WIDTH-1:0]    mem_wdata;
    logic [DATA_WIDTH-1:0]    mem_rdata;

endinterface
