module memory_tb #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,
    parameter DEPTH = 1024
)();
// Testbench signals
    bit clk;
    bit rst_n;

    logic mem_en;
    logic mem_we;
    logic [ADDR_WIDTH-1:0] mem_addr;
    logic [DATA_WIDTH-1:0] mem_wdata;
    logic [DATA_WIDTH-1:0] mem_rdata;

    localparam int TEST_CASES = 100;
    integer PASSED_TESTS = 0;
    integer FAILED_TESTS = 0;
// DUT

    axi_memory #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .mem_en(mem_en),
        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata)
    );
// Storing Elements
    logic read_valid[TEST_CASES];
    //Inputs
    logic [ADDR_WIDTH-1:0] addr_arr[TEST_CASES];
    logic [DATA_WIDTH-1:0] data_arr[TEST_CASES];
    logic                  en_arr[TEST_CASES];
    logic                  we_arr[TEST_CASES];
    // Output
    logic [DATA_WIDTH-1:0] act_out[TEST_CASES];
    logic [DATA_WIDTH-1:0] exp_out[TEST_CASES];
    // Memory
    logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];

class random;
    rand logic [ADDR_WIDTH-1:0] addr;
    rand logic [DATA_WIDTH-1:0] data;

    constraint addr_c { addr < DEPTH; }

endclass
// Clock generation
always #5 clk = ~clk;


// Initial Block
initial begin
    initialize();
    gen();
    drive();
    check();
    $display("Total Passed Tests: %0d", PASSED_TESTS);
    $display("Total Failed Tests: %0d", FAILED_TESTS);
    $stop;
end

//Tasks

task initialize;
    for (int i = 0; i < DEPTH; i++) begin
        memory[i] = 0;
    end
    rst_n = 0;
    clk = 0;
    mem_en = 0;
    mem_we = 0;
    mem_wdata = 0;
    mem_addr = 0;
    @(negedge clk);
    rst_n = 1;
endtask



task gen;
    random r1;
    integer i;
for (int i = 0; i < TEST_CASES; i = i + 2) begin
    r1 = new();

    if (r1.randomize()) begin
        // Write
        en_arr[i]   = 1'b1;
        we_arr[i]   = 1'b1;
        addr_arr[i] = r1.addr;
        data_arr[i] = r1.data;
    $display("Test case %0d: en=%b, we=%b, addr=%0d, data=%0d"
             ,i, en_arr[i], we_arr[i], addr_arr[i], data_arr[i]);

        // Read
        en_arr[i+1]   = 1'b1;
        we_arr[i+1]   = 1'b0;
        addr_arr[i+1] = r1.addr;
        data_arr[i+1] = '0;
        $display("Test case %0d: en=%b, we=%b, addr=%0d, data=%0d"
                 ,i+1, en_arr[i+1], we_arr[i+1], addr_arr[i+1], data_arr[i+1]);

    end
end
endtask

task drive;
    integer i;

    for (i = 0; i < TEST_CASES; i++) begin
        @(negedge clk);
        mem_en    = en_arr[i];
        mem_we    = we_arr[i];
        mem_addr  = addr_arr[i];
        mem_wdata = data_arr[i];

        read_valid[i] = en_arr[i] && !we_arr[i];

        if (read_valid[i]) begin
            exp_out[i] = memory[addr_arr[i]];
        end

        @(posedge clk);
        if (en_arr[i] && we_arr[i]) begin
            memory[addr_arr[i]] = data_arr[i];
        end

        @(negedge clk);
        if (read_valid[i]) begin
            act_out[i] = mem_rdata;
        end

        mem_en = 1'b0;
        mem_we = 1'b0;

    end
endtask


task check;
    integer i;

    for (i = 0; i < TEST_CASES; i++) begin

        if (read_valid[i]) begin
            if (act_out[i] !== exp_out[i]) begin
                $display("Read test %0d failed: expected %0d, got %0d, address %0d",
                          i, exp_out[i], act_out[i], addr_arr[i]);
                FAILED_TESTS = FAILED_TESTS + 1;
            end
            else begin
                $display("Read test %0d passed: expected %0d, got %0d, address %0d",
                         i, exp_out[i], act_out[i], addr_arr[i]);
                PASSED_TESTS = PASSED_TESTS + 1;
            end
        end
        else begin
            $display("Write test %0d: wrote %0d to address %0d",
                      i, data_arr[i], addr_arr[i]);
            PASSED_TESTS = PASSED_TESTS + 1;
        end

    end
endtask

endmodule
