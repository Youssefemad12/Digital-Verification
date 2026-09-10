package axi4_assertions_pkg;

    property p_reset(
        clk, rst_n,
        awready, wready, bvalid,
        arready, rvalid, rlast
    );
        @(posedge clk)
        !rst_n |-> (
            awready  &&
            !wready  &&
            !bvalid  &&
            arready  &&
            !rvalid  &&
            !rlast
        );
    endproperty

    property w_stable(clk, rst_n, wvalid, wready,wdata, wlast);
        @(posedge clk) disable iff (!rst_n)
        (wvalid && !wready)
        |=>
        (wvalid &&
         $stable(wdata) &&
         $stable(wlast));
    endproperty

    property bresp_valid(clk, rst_n,bvalid, bresp);
        @(posedge clk) disable iff (!rst_n)
        bvalid |->
        ((bresp == 2'b00) || (bresp == 2'b10));
    endproperty

    property rresp_valid(clk, rst_n,rvalid, rresp);
        @(posedge clk) disable iff (!rst_n)
        rvalid |->
        ((rresp == 2'b00) || (rresp == 2'b10));
    endproperty

    property unknown_outputs(clk, rst_n, outputs);
        @(posedge clk) disable iff (!rst_n)
        !$isunknown(outputs);
    endproperty

endpackage