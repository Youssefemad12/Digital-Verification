package monitor_pkg;
import signals_pkg::*;

    class monitor;

        virtual axi4_if.monitor axi_if;
        mailbox #(signals) mon2scb;

        task monitor_write();
            signals tr;
            while (axi_if.ARESETn !== 1'b1)
            @(posedge axi_if.CLK);
            forever begin
                tr = new();
                tr.operation = WRITE_OP;
                do begin
                    @(posedge axi_if.CLK);
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
                        @(posedge axi_if.CLK);
                    end while (!(
                        (axi_if.ARESETn === 1'b1) &&
                        (axi_if.WVALID === 1'b1) &&
                        (axi_if.WREADY === 1'b1)
                    ));
                     tr.WDATA[i] = axi_if.WDATA;
                     if (i == tr.AWLEN)
                        tr.WLAST = axi_if.WLAST;
                end

                foreach (tr.WDATA[i]) begin
                    tr.cg.sample(tr.WDATA[i]);
                end

                tr.WLAST = axi_if.WLAST;
                do begin
                    @(posedge axi_if.CLK);
                end while (!(
                    (axi_if.ARESETn === 1'b1) &&
                    (axi_if.BVALID === 1'b1) &&
                    (axi_if.BREADY === 1'b1)
                ));

                tr.BRESP = axi_if.BRESP;
                $display("[MON][WRITE] addr=%h data=%p last=%b resp=%b \n",
                           tr.AWADDR, tr.WDATA, tr.WLAST, tr.BRESP);
                tr.cg.sample();
                mon2scb.put(tr);
            end
        endtask

        task monitor_read();
            signals tr;

            while (axi_if.ARESETn !== 1'b1)
            @(posedge axi_if.CLK);

            forever begin
                tr = new();
                tr.operation = READ_OP;
                do begin
                    @(posedge axi_if.CLK);
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
                        @(posedge axi_if.CLK);
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
                $display("[MON][READ] addr=%h len=%0d data=%p last=%b resp=%b",
                        tr.ARADDR,
                        tr.ARLEN,
                        tr.RDATA,
                        tr.RLAST,
                        tr.RRESP);
                tr.cg.sample();
                mon2scb.put(tr);
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
