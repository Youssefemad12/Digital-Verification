package axi4_test_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

import axi4_env_pkg::*;
import axi4_sequence_pkg::*;
import common_cfg_pkg::*;

    class axi4_test extends uvm_test;

        axi4_env env;
        axi4_sequence seq;
        common_cfg m_cfg;

        `uvm_component_utils(axi4_test)

        function new (string name , uvm_component parent);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            m_cfg = new();
            uvm_config_db #(common_cfg)::set(this,"env.agt.*","m_cfg",m_cfg);

            env = axi4_env::type_id::create("env", this);
            seq = axi4_sequence::type_id::create("seq", this);

            super.build_phase(phase);
            `uvm_info(get_type_name(),"Inside test phase",UVM_LOW)
        endfunction

        task run_phase(uvm_phase phase);

            phase.raise_objection(this);
            `uvm_info(get_type_name(), "Sequence begin", UVM_LOW)
            seq.start(env.agt.sqr);
            `uvm_info(get_type_name(), "Sequence finished", UVM_LOW)
            phase.drop_objection(this);

        endtask
    endclass
endpackage
