package axi4_sequence_pkg;
`include"uvm_macros.svh"
import uvm_pkg::*;
import axi4_transaction_pkg::*;

    class axi4_sequence extends uvm_sequence #(axi4_transaction);

        `uvm_object_utils(axi4_sequence)

            function new (string name = "axi4_sequence");
                super.new(name);
            endfunction

            task body();
                repeat (2000) begin
                    req = axi4_transaction #(.DATA_WIDTH(32),
                                            .ADDR_WIDTH (16),
                                            .MEMORY_DEPTH (1024))
                                            ::type_id::create("req");
                    start_item(req);
                    assert(req.randomize())
                    finish_item(req);
                end
            endtask
    endclass
endpackage
