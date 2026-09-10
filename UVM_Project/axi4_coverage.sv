package axi4_coverage_pkg;
import uvm_pkg::*;
import axi4_transaction_pkg::*;
`include "uvm_macros.svh"

class axi4_cov extends uvm_component;
    `uvm_component_utils(axi4_cov)
    logic [15:0] AWADDR;
    logic [15:0] ARADDR;
    logic [7:0]  AWLEN;
    logic [7:0]  ARLEN;
    logic [1:0]  BRESP;
    logic [1:0]  RRESP;
    logic [2:0]  AWSIZE;
    logic [2:0]  ARSIZE;

    covergroup cg;
        c_AWADDR : coverpoint AWADDR {
            bins b1 = {[16'd0    : 16'd511]};
            bins b2 = {[16'd512  : 16'd1023]};
            bins b3 = {[16'd1024 : 16'd1535]};
            bins b4 = {[16'd1536 : 16'd2047]};
            bins b5 = {[16'd2048 : 16'd2559]};
            bins b6 = {[16'd2560 : 16'd3071]};
            bins b7 = {[16'd3072 : 16'd3583]};
            bins b8 = {[16'd3584 : 16'd4092]};
        }
        c_ARADDR : coverpoint ARADDR {
            bins b1 = {[16'd0    : 16'd511]};
            bins b2 = {[16'd512  : 16'd1023]};
            bins b3 = {[16'd1024 : 16'd1535]};
            bins b4 = {[16'd1536 : 16'd2047]};
            bins b5 = {[16'd2048 : 16'd2559]};
            bins b6 = {[16'd2560 : 16'd3071]};
            bins b7 = {[16'd3072 : 16'd3583]};
            bins b8 = {[16'd3584 : 16'd4092]};
        }
        c_AWLEN : coverpoint AWLEN {
            bins b0 = {8'd0};
            bins b1 = {[8'd1   : 8'd63]};
            bins b2 = {[8'd64  : 8'd127]};
            bins b3 = {[8'd128 : 8'd191]};
            bins b4 = {[8'd192 : 8'd255]};
        }
        c_ARLEN : coverpoint ARLEN {
            bins b0 = {8'd0};
            bins b1 = {[8'd1   : 8'd63]};
            bins b2 = {[8'd64  : 8'd127]};
            bins b3 = {[8'd128 : 8'd191]};
            bins b4 = {[8'd192 : 8'd255]};
        }

        c_BRESP : coverpoint BRESP {
            bins okay   = {2'b00};
            ignore_bins  slverr = {2'b10};
        }

        c_RRESP : coverpoint RRESP {
            bins okay   = {2'b00};
            ignore_bins  slverr = {2'b10};
        }

        c_AWSIZE : coverpoint AWSIZE {
            bins word = {3'd2};
        }

        c_ARSIZE : coverpoint ARSIZE {
            bins word = {3'd2};
        }

    endgroup

    uvm_analysis_export #(axi4_transaction) analysis_exp;
    uvm_tlm_analysis_fifo #(axi4_transaction) fifo;

    function new(string name, uvm_component parent);
        super.new(name,parent);
        analysis_exp = new("analysis_exp", this);
        fifo = new("fifo", this);
        cg = new();
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        analysis_exp.connect(fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        axi4_transaction tr;
        forever begin
            fifo.get(tr);
            AWADDR = tr.AWADDR;
            ARADDR = tr.ARADDR;
            AWLEN  = tr.AWLEN;
            ARLEN  = tr.ARLEN;
            BRESP  = tr.BRESP;
            RRESP  = tr.RRESP;
            AWSIZE = tr.AWSIZE;
            ARSIZE = tr.ARSIZE;
            cg.sample();
        end
    endtask
endclass
endpackage
