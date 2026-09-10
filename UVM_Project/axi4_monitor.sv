package axi4_monitor_pkg;
`include"uvm_macros.svh"
import uvm_pkg::*;
import common_cfg_pkg::*;
import axi4_transaction_pkg::*;



    class axi4_monitor extends uvm_monitor;

        `uvm_component_utils(axi4_monitor)

        virtual axi4_if axi_if;
        common_cfg m_cfg;
        uvm_analysis_port #(axi4_transaction) a_port;


            function new (string name = "axi4_monitor", uvm_component parent);
                super.new(name,parent);
            endfunction

            function void build_phase( uvm_phase phase);
                super.build_phase(phase);

                if (!uvm_config_db #(virtual axi4_if)::get(this,"","vif", axi_if))
                `uvm_fatal(get_type_name(), " Falied to get interface")

                if (!uvm_config_db #(common_cfg)::get(this, "", "m_cfg", m_cfg))
                `uvm_fatal(get_type_name(), "Failed to get common_cfg")

                a_port = new("a_port", this);

                `uvm_info(get_type_name(), "Inside Monitor [Build]", UVM_LOW)
            endfunction

            task run_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "Inside Monitor [Run]", UVM_LOW)
            forever begin
                monitor();
                end
            endtask

            task monitor_write();
            axi4_transaction tr;
            while (axi_if.ARESETn !== 1'b1)
            @(posedge axi_if.ACLK);
            forever begin
                tr = new();
                tr.operation = WRITE_OP;
                do begin
                    @(posedge axi_if.ACLK);
                end while (!(
                    (axi_if.ARESETn === 1'b1) &&
                    (axi_if.AWVALID === 1'b1) &&
                    (axi_if.AWREADY === 1'b1)
                    ));
                tr.AWADDR = axi_if.AWADDR;
                tr.AWLEN  = axi_if.AWLEN;
                tr.AWSIZE = axi_if.AWSIZE;
                tr.WDATA = new[tr.AWLEN + 1];
                for (int i = 0 ; i < tr.AWLEN + 1; i++) begin
                    do begin
                        @(posedge axi_if.ACLK);
                    end while (!(
                        (axi_if.ARESETn === 1'b1) &&
                        (axi_if.WVALID === 1'b1) &&
                        (axi_if.WREADY === 1'b1)
                    ));
                     tr.WDATA[i] = axi_if.WDATA;
                     if (i == tr.AWLEN)
                        tr.WLAST = axi_if.WLAST;
                end
                tr.WLAST = axi_if.WLAST;
                do begin
                    @(posedge axi_if.ACLK);
                end while (!(
                    (axi_if.ARESETn === 1'b1) &&
                    (axi_if.BVALID === 1'b1) &&
                    (axi_if.BREADY === 1'b1)
                ));
                tr.BRESP = axi_if.BRESP;
                `uvm_info(get_type_name(), $sformatf("[MON][WRITE] addr=%h data=%p last=%b resp=%b \n",
                           tr.AWADDR, tr.WDATA, tr.WLAST, tr.BRESP) , UVM_LOW);
                a_port.write(tr);
            end
        endtask

        task monitor_read();
            axi4_transaction tr;

            while (axi_if.ARESETn !== 1'b1)
            @(posedge axi_if.ACLK);

            forever begin
                tr = new();
                tr.operation = READ_OP;
                do begin
                    @(posedge axi_if.ACLK);
                end while (!(
                    (axi_if.ARESETn === 1'b1) &&
                    (axi_if.ARVALID === 1'b1) &&
                    (axi_if.ARREADY === 1'b1)
                ));

                tr.ARADDR = axi_if.ARADDR;
                tr.ARLEN  = axi_if.ARLEN;
                tr.ARSIZE = axi_if.ARSIZE;

                tr.RDATA = new[tr.ARLEN + 1];
                for (int i = 0 ; i < tr.ARLEN + 1; i++) begin
                    do begin
                        @(posedge axi_if.ACLK);
                    end while (!(
                        (axi_if.ARESETn === 1'b1) &&
                        (axi_if.RVALID === 1'b1) &&
                        (axi_if.RREADY === 1'b1)
                    ));
                     tr.RDATA[i] = axi_if.RDATA;
                     tr.RRESP = axi_if.RRESP;

                     if (i == tr.ARLEN)
                        tr.RLAST = axi_if.RLAST;
                end
                `uvm_info(get_type_name(), $sformatf("[MON][READ] addr=%h len=%0d data=%p last=%b resp=%b",
                        tr.ARADDR,
                        tr.ARLEN,
                        tr.RDATA,
                        tr.RLAST,
                        tr.RRESP), UVM_LOW);
                a_port.write(tr);
            end
        endtask

        task monitor();
            fork
                monitor_write();
                monitor_read();
            join
        endtask
    endclass
endpackage
