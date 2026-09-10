package axi4_driver_pkg;
`include"uvm_macros.svh"
import uvm_pkg::*;
import axi4_transaction_pkg::*;
import common_cfg_pkg::*;

    class axi4_driver extends uvm_driver #(axi4_transaction);

        `uvm_component_utils(axi4_driver)
        virtual axi4_if axi_if;
        common_cfg m_cfg;
            function new (string name = "axi4_driver", uvm_component parent);
                super.new(name,parent);
            endfunction

            function void build_phase( uvm_phase phase);
                super.build_phase(phase);
                if (!uvm_config_db #(virtual axi4_if)::get(this,"","vif",axi_if))
                `uvm_fatal(get_type_name(), "Failed to get interace")

                if (!uvm_config_db #(common_cfg)::get(this, "", "m_cfg", m_cfg))
                `uvm_fatal(get_type_name(), "Failed to get common_cfg")

                `uvm_info(get_type_name(), "Inside Driver [Build]", UVM_LOW)
            endfunction

            task run_phase(uvm_phase phase);
                forever begin
                    seq_item_port.get_next_item(req);
                    drive(req);
                    seq_item_port.item_done();
                end
            endtask

            task initialize();

                axi_if.AWADDR  = '0;
                axi_if.AWLEN   = '0;
                axi_if.AWSIZE  = '0;
                axi_if.AWVALID = 1'b0;
                axi_if.WDATA   = '0;
                axi_if.WLAST   = 1'b0;
                axi_if.WVALID  = 1'b0;
                axi_if.BREADY  = 1'b0;
                axi_if.ARADDR  = '0;
                axi_if.ARLEN   = '0;
                axi_if.ARSIZE  = '0;
                axi_if.ARVALID = 1'b0;
                axi_if.RREADY  = 1'b0;
                while (axi_if.ARESETn !== 1'b1)
                    @(posedge axi_if.ACLK);
            endtask


            task write(axi4_transaction sig);
                @(posedge axi_if.ACLK);
                @(posedge axi_if.ACLK);
                //Write addrress
                axi_if.AWADDR  <= sig.AWADDR;
                axi_if.AWLEN   <= sig.AWLEN;
                axi_if.AWSIZE  <= sig.AWSIZE;
                axi_if.AWVALID <= 1'b1;
                do begin
                    @(posedge axi_if.ACLK);
                end
                while (!(
                    (axi_if.AWREADY === 1'b1) &&
                    (axi_if.AWVALID === 1'b1)
                ));
                axi_if.AWVALID <= 1'b0;

                // Write data
                for (int i = 0 ; i < sig.AWLEN + 1 ; i++) begin
                    axi_if.WDATA  <= sig.WDATA[i];
                    axi_if.WVALID <= 1'b1;

                    if (i == sig.AWLEN)
                        axi_if.WLAST <= 1'b1;
                    else
                        axi_if.WLAST <= 1'b0;

                    do begin
                    @(posedge axi_if.ACLK);
                    end
                    while (!(
                    (axi_if.WREADY === 1'b1) &&
                    (axi_if.WVALID === 1'b1)
                    ));
                end
                axi_if.WVALID <= 1'b0;
                axi_if.WLAST  <= 1'b0;

                // Write response
                axi_if.BREADY <= 1'b1;
                do begin
                    @(posedge axi_if.ACLK);
                end
                while (!(
                    (axi_if.BVALID === 1'b1) &&
                    (axi_if.BREADY === 1'b1)
                ));
                axi_if.BREADY <= 1'b0;
                @(posedge axi_if.ACLK);
                @(posedge axi_if.ACLK);
            endtask


            task read(axi4_transaction sig);

                // Read address
                axi_if.ARADDR  <= sig.ARADDR;
                axi_if.ARLEN   <= sig.ARLEN;
                axi_if.ARSIZE  <= sig.ARSIZE;
                axi_if.ARVALID <= 1'b1;
                do begin
                    @(posedge axi_if.ACLK);
                end
                while (!(
                    (axi_if.ARREADY === 1'b1) &&
                    (axi_if.ARVALID === 1'b1)
                ));
                axi_if.ARVALID <= 1'b0;

                // Read data
                axi_if.RREADY <= 1'b1;
                for (int i = 0 ; i < sig.ARLEN + 1; i++) begin
                    do begin
                    @(posedge axi_if.ACLK);
                    end
                    while (!(
                        (axi_if.RVALID === 1'b1) &&
                        (axi_if.RREADY === 1'b1)
                    ));
                    `uvm_info(get_type_name,$sformatf(
                        "[DRV][READ] beat=%0d data=%p RLAST=%b",
                         i,
                        axi_if.RDATA,
                        axi_if.RLAST), UVM_LOW);
                end
                axi_if.RREADY <= 1'b0;
            endtask


            task drive(axi4_transaction sig);
                initialize();
                    write(sig);
                    read(sig);
            endtask
    endclass
endpackage
