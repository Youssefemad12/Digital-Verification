package mem_monitor_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
import mem_transaction_pkg::*;

class mem_monitor extends uvm_monitor;

    `uvm_component_utils(mem_monitor)

    virtual mem_if mem_vif;
    uvm_analysis_port #(mem_transaction) a_port;

    function new(string name = "mem_monitor",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db #(virtual mem_if)::get(this, "", "vif", mem_vif))
            `uvm_fatal(get_type_name(),"Failed to get memory interface")

        a_port = new("a_port", this);
    endfunction

    task run_phase(uvm_phase phase);
        mem_transaction tr;
        forever begin
            @(posedge mem_vif.clk);
            if (mem_vif.rst_n && mem_vif.mem_en) begin
                tr = mem_transaction::type_id::create("tr");
                tr.rst_n     = mem_vif.rst_n;
                tr.mem_en    = mem_vif.mem_en;
                tr.mem_we    = mem_vif.mem_we;
                tr.mem_addr  = mem_vif.mem_addr;
                tr.mem_wdata = mem_vif.mem_wdata;
                if (!mem_vif.mem_we) begin
                    @(posedge mem_vif.clk);
                    tr.mem_rdata = mem_vif.mem_rdata;
                end
                a_port.write(tr);
            end
        end
    endtask
endclass

endpackage
