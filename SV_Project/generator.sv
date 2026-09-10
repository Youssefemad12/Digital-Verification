package gen_pkg;
import signals_pkg::*;

    class generator;

        mailbox #(signals) gen2drv;
        mailbox #(int)     drv2gen;
        int num_sig = 3000;
        bit done = 0;

        task gen();
            signals sig;
            int token;
            repeat (num_sig) begin
                sig = new();
                if (!sig.randomize()) begin
                    $fatal(1, "Transaction randomization failed");
                end
                $display("[GEN] write_addr=%h write_data=%p read_addr=%h",
                                sig.AWADDR, sig.WDATA, sig.ARADDR);

                gen2drv.put(sig);
                drv2gen.get(token);
            end
            done = 1;
        endtask
    endclass
endpackage
