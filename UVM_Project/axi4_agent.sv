package axi4_agent_pkg;
`include"uvm_macros.svh"
import uvm_pkg::*;
import axi4_sequencer_pkg::*;
import axi4_driver_pkg::*;
import axi4_monitor_pkg::*;

    class axi4_agent extends uvm_agent;

        `uvm_component_utils(axi4_agent)
        uvm_active_passive_enum is_active = UVM_ACTIVE;

        axi4_sequencer sqr;
        axi4_driver    drv;
        axi4_monitor   mon;

            function new (string name = "axi4_agent", uvm_component parent);
                super.new(name,parent);
            endfunction

            function void build_phase( uvm_phase phase);
                super.build_phase(phase);
                `uvm_info(get_type_name(), "Inside Agent [Build]", UVM_LOW)


                if (!uvm_config_db #(uvm_active_passive_enum)::get(this,"", "is_active", is_active))
                `uvm_fatal(get_type_name(), "Failed to get enum")

                mon = axi4_monitor::type_id::create("mon", this);

                if (is_active == UVM_ACTIVE) begin
                    drv = axi4_driver::type_id::create("drv", this);
                    sqr = axi4_sequencer::type_id::create("sqr", this);
                end
            endfunction

            function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                if (is_active == UVM_ACTIVE) begin
                    drv.seq_item_port.connect(sqr.seq_item_export);
                end
            endfunction
    endclass
endpackage
