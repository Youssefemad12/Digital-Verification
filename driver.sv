package driver;
import signals_pkg::*;

class driver;

    virtual axi4_if.master axi_if;
    mailbox #(signals) gen2drv;
    mailbox #(int)     drv2gen;

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
            @(posedge axi_if.CLK);
    endtask


    task write(signals sig);

        @(posedge axi_if.CLK);
        @(posedge axi_if.CLK);

        //Write addrress
        axi_if.AWADDR  <= sig.AWADDR;
        axi_if.AWLEN   <= sig.AWLEN;
        axi_if.AWSIZE  <= sig.AWSIZE;
        axi_if.AWVALID <= 1'b1;
        do begin
            @(posedge axi_if.CLK);
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
            @(posedge axi_if.CLK);
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
            @(posedge axi_if.CLK);
        end
        while (!(
            (axi_if.BVALID === 1'b1) &&
            (axi_if.BREADY === 1'b1)
        ));
        axi_if.BREADY <= 1'b0;
        @(posedge axi_if.CLK);
        @(posedge axi_if.CLK);
    endtask


    task read(signals sig);

        // Read address
        axi_if.ARADDR  <= sig.ARADDR;
        axi_if.ARLEN   <= sig.ARLEN;
        axi_if.ARSIZE  <= sig.ARSIZE;
        axi_if.ARVALID <= 1'b1;
        do begin
            @(posedge axi_if.CLK);
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
            @(posedge axi_if.CLK);
            end
            while (!(
                (axi_if.RVALID === 1'b1) &&
                (axi_if.RREADY === 1'b1)
            ));
            $display(
                "[DRV][READ] beat=%0d data=%p RLAST=%b",
                 i,
                axi_if.RDATA,
                axi_if.RLAST);
        end
        axi_if.RREADY <= 1'b0;
    endtask


    task drive();
        signals sig;
        initialize();
        forever begin
            gen2drv.get(sig);
            write(sig);
            read(sig);
            drv2gen.put(1);
        end
    endtask

endclass

endpackage
