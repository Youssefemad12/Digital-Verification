package axi4_transaction_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit {
    WRITE_OP,
    READ_OP
} operation_e;

    class axi4_transaction #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter MEMORY_DEPTH = 1024
)   extends uvm_sequence_item;

         bit                        ACLK;
         bit                        ARESETn;

    operation_e                     operation;

    rand logic  [ADDR_WIDTH-1:0]    AWADDR;
    rand logic  [7:0]               AWLEN;
    rand logic  [2:0]               AWSIZE;
         logic                      AWVALID;
         logic                      AWREAD;

    rand logic  [DATA_WIDTH-1:0]    WDATA[];
         logic                      WVALID;
         logic                      WLAST;
         logic                      WREAD;

         logic [1:0]                BRESP;
         logic                      BVALID;
         logic                      BREADY;

    rand logic  [ADDR_WIDTH-1:0]    ARADDR;
    rand logic  [7:0]               ARLEN;
    rand logic  [2:0]               ARSIZE;
         logic                      ARVALID;
         logic                      ARREADY;

         logic [DATA_WIDTH-1:0]     RDATA[];
         logic [1:0]                RRESP;
         logic                      RVALID;
         logic                      RLAST;
         logic                      RREAD;

        constraint c0 {ARSIZE == 3'd2;AWSIZE == 3'd2;}

        constraint addr_c {
            AWADDR inside {[16'h0000:16'h0FFC]};
            ARADDR inside {[16'h0000:16'h0FFC]};
            AWADDR[1:0] == 2'b00;
            ARADDR[1:0] == 2'b00;
        }

        constraint burst_c {
            (int'(AWADDR) + ((int'(AWLEN) + 1) * 4) - 1)
                <= 16'h0FFF;

            (int'(ARADDR) + ((int'(ARLEN) + 1) * 4) - 1)
                <= 16'h0FFF;
        }

        constraint wdata_size_c { WDATA.size() == AWLEN + 1;}

        `uvm_object_utils_begin(axi4_transaction)
            `uvm_field_int(ACLK, UVM_DEFAULT)
            `uvm_field_int(ARESETn, UVM_DEFAULT)
            `uvm_field_int(AWADDR, UVM_DEFAULT)
            `uvm_field_int(AWLEN, UVM_DEFAULT)
            `uvm_field_int(AWSIZE, UVM_DEFAULT)
            `uvm_field_int(AWVALID, UVM_DEFAULT)
            `uvm_field_int(AWREAD, UVM_DEFAULT)
            `uvm_field_array_int(WDATA, UVM_DEFAULT)
            `uvm_field_int(WVALID, UVM_DEFAULT)
            `uvm_field_int(WLAST, UVM_DEFAULT)
            `uvm_field_int(WREAD, UVM_DEFAULT)
            `uvm_field_int(BRESP, UVM_DEFAULT)
            `uvm_field_int(BVALID, UVM_DEFAULT)
            `uvm_field_int(BREADY, UVM_DEFAULT)
            `uvm_field_int(ARADDR, UVM_DEFAULT)
            `uvm_field_int(ARLEN, UVM_DEFAULT)
            `uvm_field_int(ARSIZE, UVM_DEFAULT)
            `uvm_field_int(ARVALID, UVM_DEFAULT)
            `uvm_field_int(ARREADY, UVM_DEFAULT)
            `uvm_field_array_int(RDATA, UVM_DEFAULT)
            `uvm_field_int(RRESP, UVM_DEFAULT)
            `uvm_field_int(RVALID, UVM_DEFAULT)
            `uvm_field_int(RLAST, UVM_DEFAULT)
            `uvm_field_int(RREAD, UVM_DEFAULT)
        `uvm_object_utils_end

        function new (string name = "axi4_transaction");
            super.new(name);
        endfunction
    endclass
endpackage
