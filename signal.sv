package signals_pkg;

typedef enum bit {
    WRITE_OP,
    READ_OP
} operation_e;

class signals;

    operation_e       operation;
    rand logic [15:0] AWADDR;
    rand logic [7:0]  AWLEN;
    rand logic [2:0]  AWSIZE;
    rand logic [31:0] WDATA[];
         logic        WLAST;
         logic [1:0]  BRESP;
    rand logic [15:0] ARADDR;
    rand logic [7:0]  ARLEN;
    rand logic [2:0]  ARSIZE;
         logic [31:0] RDATA[];
         logic [1:0]  RRESP;
         logic        RLAST;

    constraint address_c {
        AWADDR inside {[16'h0000:16'h0FFC]};
        ARADDR inside {[16'h0000:16'h0FFC]};
        AWADDR[1:0] == 2'b00;
        ARADDR[1:0] == 2'b00;
    }
    constraint size_c {
        AWSIZE == 3'd2;
        ARSIZE == 3'd2;
    }
    constraint wdata_size_c {
    WDATA.size() == AWLEN + 1;
    }

    covergroup cg with function sample (logic [31:0] wdata = 32'b0);
        c_AWADDR : coverpoint AWADDR {
            bins b1 = {[16'd0 : 16'd511]};
            bins b2 = {[16'd512 : 16'd1023]};
            bins b3 = {[16'd1024 : 16'd1535]};
            bins b4 = {[16'd1536 : 16'd2047]};
            bins b5 = {[16'd2048 : 16'd2559]};
            bins b6 = {[16'd2560 : 16'd3071]};
            bins b7 = {[16'd3072 : 16'd3583]};
            bins b8 = {[16'd3584 : 16'd4092]};
        }
        c_ARADDR : coverpoint ARADDR {
            bins b1 = {[16'd0 : 16'd511]};
            bins b2 = {[16'd512 : 16'd1023]};
            bins b3 = {[16'd1024 : 16'd1535]};
            bins b4 = {[16'd1536 : 16'd2047]};
            bins b5 = {[16'd2048 : 16'd2559]};
            bins b6 = {[16'd2560 : 16'd3071]};
            bins b7 = {[16'd3072 : 16'd3583]};
            bins b8 = {[16'd3584 : 16'd4092]};
        }
        c_AWLEN : coverpoint AWLEN {
            bins b0 = {8'd0};
            bins b1 = {[8'd1 : 8'd63]};
            bins b2 = {[8'd64 : 8'd127]};
            bins b3 = {[8'd128 : 8'd191]};
            bins b4 = {[8'd192 : 8'd255]};
        }
        c_ARLEN : coverpoint ARLEN {
            bins b0 = {8'd0};
            bins b1 = {[8'd1 : 8'd63]};
            bins b2 = {[8'd64 : 8'd127]};
            bins b3 = {[8'd128 : 8'd191]};
            bins b4 = {[8'd192 : 8'd255]};
        }
        c_WDATA : coverpoint wdata {
            bins b1 = {[32'h00000000 : 32'h1FFFFFFF]};
            bins b2 = {[32'h20000000 : 32'h3FFFFFFF]};
            bins b3 = {[32'h40000000 : 32'h5FFFFFFF]};
            bins b4 = {[32'h60000000 : 32'h7FFFFFFF]};
            bins b5 = {[32'h80000000 : 32'h9FFFFFFF]};
            bins b6 = {[32'hA0000000 : 32'hBFFFFFFF]};
            bins b7 = {[32'hC0000000 : 32'hDFFFFFFF]};
            bins b8 = {[32'hE0000000 : 32'hFFFFFFFF]};
        }
        c_BRESP : coverpoint BRESP {
            bins b1 = {2'b00};
            bins b2 = {2'b10};
        }
        c_RRESP : coverpoint RRESP {
            bins b1 = {2'b00};
            bins b2 = {2'b10};
        }
        c_AWSIZE : coverpoint AWSIZE {
            bins b1 = {3'd2};
        }
        c_ARSIZE : coverpoint ARSIZE {
            bins b1 = {3'd2};
        }
        croos_wire_add_len : cross c_AWADDR,c_AWLEN;
        croos_read_add_len : cross c_ARADDR,c_ARLEN;

    endgroup

    function new;
        cg = new();
    endfunction
endclass

endpackage
