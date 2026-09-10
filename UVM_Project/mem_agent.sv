package mem_agent_pkg;
`include"uvm_macros.svh"
import uvm_pkg::*;
import mem_monitor_pkg::*;

    class mem_agent extends uvm_agent;

        `uvm_component_utils(mem_agent)


        mem_monitor   mon;

            function new (string name = "mem_agent", uvm_component parent);
                super.new(name,parent);
            endfunction

            function void build_phase( uvm_phase phase);
                super.build_phase(phase);
                `uvm_info(get_type_name(), "Inside Agent [Build]", UVM_LOW)
                mon = mem_monitor::type_id::create("mon", this);
            endfunction

    endclass
endpackage
