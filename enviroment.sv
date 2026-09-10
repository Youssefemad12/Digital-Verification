package env_pkg;
import monitor_pkg::*;
import driver::*;
import scb_pkg::*;
import signals_pkg::*;
import gen_pkg::*;

    class enviroment;
        generator gen;
        driver drv;
        monitor mon;
        scoreboard scb;
        virtual axi4_if.master  axi_if;
        virtual axi4_if.monitor axi_mon;
        mailbox #(signals) gen2drv;
        mailbox #(int)     drv2gen;
        mailbox #(signals) mon2scb;
        task run_env();
            gen2drv = new(1);
            drv2gen = new(1);
            mon2scb = new();
            gen = new();
            drv = new();
            mon = new();
            scb = new();
            gen.gen2drv = gen2drv;
            gen.drv2gen = drv2gen;
            drv.gen2drv = gen2drv;
            drv.drv2gen = drv2gen;
            mon.mon2scb = mon2scb;
            scb.mon2scb = mon2scb;
            drv.axi_if = axi_if;
            mon.axi_if = axi_mon;
            fork : components
                gen.gen();
                drv.drive();
                mon.monitor();
                scb.scoreboard();
            join_none
            wait (gen.done == 1'b1);
            wait (scb.total_transactions == (2 * gen.num_sig));
            scb.report();
            $stop;
        endtask
    endclass
endpackage
