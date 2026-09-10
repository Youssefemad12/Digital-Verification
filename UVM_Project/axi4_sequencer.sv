package axi4_sequencer_pkg;
`include"uvm_macros.svh"
import uvm_pkg::*;
import axi4_transaction_pkg::*;

    class axi4_sequencer extends uvm_sequencer #(axi4_transaction);

        `uvm_component_utils(axi4_sequencer)

            function new (string name = "axi4_sequencer", uvm_component parent);
                super.new(name,parent);
            endfunction

            function void build_phase( uvm_phase phase);
                super.build_phase(phase);
                `uvm_info(get_type_name(), "Inside Sequencer [Build]", UVM_LOW)
            endfunction
    endclass
endpackage
