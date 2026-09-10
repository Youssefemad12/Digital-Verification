package axi4_env_pkg;
import uvm_pkg::*;
import axi4_agent_pkg::*;
import axi4_scoreboard_pkg::*;
import axi4_coverage_pkg::*;
import common_cfg_pkg::*;
import mem_agent_pkg::*;
import mem_scoreboard_pkg::*;
`include "uvm_macros.svh"

    class axi4_env extends uvm_env;
        `uvm_component_utils(axi4_env)
        axi4_agent      agt;
        axi4_scoreboard scb;
        axi4_cov        cov;
        mem_agent      mem_agt;
        mem_scoreboard  mem_scb;
        common_cfg m_cfg;

        function new (string name , uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            agt = axi4_agent::type_id::create("agt",this);
            scb = axi4_scoreboard::type_id::create("scb",this);
            cov = axi4_cov::type_id::create("cov",this);
            mem_agt = mem_agent::type_id::create("mem_agt",this);
            mem_scb = mem_scoreboard::type_id::create("mem_scb",this);

            `uvm_info(get_type_name(), "Inside Env [Build]", UVM_LOW)

            uvm_config_db #(common_cfg)::get(this,"", "m_cfg",m_cfg);

        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            agt.mon.a_port.connect(scb.analysis_exp);
            agt.mon.a_port.connect(cov.analysis_exp);
            mem_agt.mon.a_port.connect(mem_scb.analysis_exp);
            `uvm_info(get_type_name(), "Inside Env [Connect]", UVM_LOW)
        endfunction
    endclass
endpackage
