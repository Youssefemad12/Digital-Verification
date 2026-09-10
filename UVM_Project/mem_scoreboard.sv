package mem_scoreboard_pkg;

import uvm_pkg::*;
import mem_transaction_pkg::*;

`include "uvm_macros.svh"


    class mem_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(mem_scoreboard)
        uvm_analysis_export #(mem_transaction) analysis_exp;
        uvm_tlm_analysis_fifo #(mem_transaction) fifo;
        logic [31:0] reference_memory [0:1023];
        int unsigned writes_checked;
        int unsigned reads_checked;
        int unsigned passed;
        int unsigned failed;
        int unsigned total_transactions;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            writes_checked      = 0;
            reads_checked       = 0;
            passed              = 0;
            failed              = 0;
            total_transactions  = 0;
            for (int i = 0; i < 1024; i++)
                reference_memory[i] = 32'd0;
            analysis_exp = new("analysis_exp", this);
            fifo         = new("fifo", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            `uvm_info(get_type_name(),"Inside Memory Scoreboard [Build]",UVM_LOW)
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            analysis_exp.connect(fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            mem_transaction tr;
            `uvm_info(get_type_name(),"Inside Memory Scoreboard [Run]",UVM_LOW)
            forever begin
                fifo.get(tr);
                total_transactions++;
                if (tr.mem_we === 1'b1) begin
                    writes_checked++;
                    reference_memory[tr.mem_addr] = tr.mem_wdata;
                    passed++;
                    `uvm_info(get_type_name(),$sformatf("[MEM_SCB][WRITE][PASS] addr=%0h data=%0h", tr.mem_addr,tr.mem_wdata),UVM_LOW)
                end
                else if (tr.mem_we === 1'b0) begin
                    reads_checked++;
                    if (tr.mem_rdata === reference_memory[tr.mem_addr]) begin
                        passed++;
                        `uvm_info(get_type_name(), $sformatf("[MEM_SCB][READ][PASS] addr=%0h expected=%0h actual=%0h"
                        ,tr.mem_addr
                        ,reference_memory[tr.mem_addr],
                        tr.mem_rdata),UVM_LOW)
                    end
                    else begin
                        failed++;
                        `uvm_error(get_type_name(),$sformatf("[MEM_SCB][READ][FAIL] addr=%0h expected=%0h actual=%0h"
                        ,tr.mem_addr
                        ,reference_memory[tr.mem_addr]
                        ,tr.mem_rdata))
                    end
                end
            end
        endtask

        function void extract_phase(uvm_phase phase);
            super.extract_phase(phase);

            `uvm_info(get_type_name(), "========================================",UVM_LOW)
            `uvm_info(get_type_name(),"MEMORY SCOREBOARD REPORT",UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Writes checked     : %0d",writes_checked), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("Reads checked      : %0d", reads_checked),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Passed transactions: %0d", passed), UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Failed transactions: %0d", failed),UVM_LOW)
            `uvm_info(get_type_name(),$sformatf("Total transactions : %0d",total_transactions),UVM_LOW)
            `uvm_info(get_type_name(),"========================================", UVM_LOW)

        endfunction
    endclass
endpackage
