package axi4_scoreboard_pkg;
import uvm_pkg::*;
import axi4_transaction_pkg::*;

`include "uvm_macros.svh"

logic [31:0] reference_memory [0:1023];
    class axi4_scoreboard extends uvm_scoreboard;

        `uvm_component_utils(axi4_scoreboard)

        uvm_analysis_export #(axi4_transaction) analysis_exp;
        uvm_tlm_analysis_fifo #(axi4_transaction) fifo;

        int unsigned writes_checked;
        int unsigned reads_checked;
        int unsigned passed;
        int unsigned failed;
        int unsigned total_transactions;


        function new (string name , uvm_component parent);
            super.new(name,parent);

           for (int i = 0; i < 1024; i++)
                reference_memory[i] = 32'd0;

            writes_checked     = 0;
            reads_checked      = 0;
            passed             = 0;
            failed             = 0;
            total_transactions = 0;
            analysis_exp = new("analysis_exp", this);
            fifo = new("fifo", this);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            `uvm_info(get_type_name(), "Inside Scoreboard", UVM_LOW)
        endfunction

        function void connect_phase(uvm_phase phase);
            analysis_exp.connect(fifo.analysis_export);
        endfunction


        task run_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "Inside Monitor [Run]", UVM_LOW)
            scoreboard();
        endtask

        function void extract_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "========================================", UVM_LOW);
            `uvm_info(get_type_name(), "AXI SCOREBOARD REPORT", UVM_LOW);
            `uvm_info(get_type_name(), $sformatf("Writes checked     : %0d", writes_checked), UVM_LOW);
            `uvm_info(get_type_name(), $sformatf("Reads checked      : %0d", reads_checked), UVM_LOW);
            `uvm_info(get_type_name(), $sformatf("Passed transactions: %0d", passed), UVM_LOW);
            `uvm_info(get_type_name(), $sformatf("Failed transactions: %0d", failed), UVM_LOW);
            `uvm_info(get_type_name(), "========================================", UVM_LOW);
        endfunction

        function bit legal_write(axi4_transaction tr);

            int unsigned beats;
            int unsigned bytes_per_beat;
            int unsigned last_byte_addr;

            beats          = (tr.AWLEN) + 1;
            bytes_per_beat = 1 << tr.AWSIZE;

            last_byte_addr =
                int'(tr.AWADDR) +
                (beats * bytes_per_beat) - 1;

            return (tr.AWSIZE == 3'd2) && (tr.AWADDR[1:0] == 2'b00) && (tr.AWADDR <= 16'h0FFC) &&
                (last_byte_addr <= 16'h0FFF) && ((last_byte_addr >> 2)  < 1024);

        endfunction

        function bit legal_read(axi4_transaction tr);

            int unsigned beats;
            int unsigned bytes_per_beat;
            int unsigned last_byte_addr;

            beats          = (tr.ARLEN) + 1;
            bytes_per_beat = 1 << tr.ARSIZE;

            last_byte_addr =
                int'(tr.ARADDR) +
                (beats * bytes_per_beat) - 1;

            return (tr.ARSIZE == 3'd2) && (tr.ARADDR[1:0] == 2'b00) && (tr.ARADDR <= 16'h0FFC) &&
                   (last_byte_addr <= 16'h0FFF) && ((last_byte_addr >> 2)  < 1024);

        endfunction

        task check_write(axi4_transaction tr);

            bit transaction_pass;
            bit legal;
            bit data_count_ok;
            logic [1:0] expected_response;
            int unsigned index;
            int unsigned beats;
            writes_checked++;
            transaction_pass = 1'b1;
            beats = (tr.AWLEN) + 1;
            legal = legal_write(tr);
            expected_response =
                legal ? 2'b00 : 2'b10;
            index = tr.AWADDR >> 2;

            if (tr.BRESP !== expected_response) begin
                `uvm_error(get_type_name(), $sformatf("[SCB][WRITE] Response mismatch: addr=%h expected=%b actual=%b",tr.AWADDR,expected_response,tr.BRESP));
                transaction_pass = 1'b0;
            end

            data_count_ok = (tr.WDATA.size() == beats);

            if (!data_count_ok) begin
                `uvm_error(get_type_name(), $sformatf("[SCB][WRITE] Beat count mismatch: expected=%0d actual=%0d", beats, tr.WDATA.size()));
                transaction_pass = 1'b0;
            end

            if (legal && (tr.WLAST !== 1'b1)) begin
                `uvm_error(get_type_name(), $sformatf("[SCB][WRITE] WLAST not asserted on final beat: addr=%h len=%0d",tr.AWADDR,tr.AWLEN));
                transaction_pass = 1'b0;
            end

            if (legal && (tr.BRESP === 2'b00) && data_count_ok)
            begin
                for (int i = 0; i < beats; i++) begin
                    reference_memory[index + i] =
                        tr.WDATA[i];
                end
            end

            if (transaction_pass) begin
                passed++;
                `uvm_info(get_type_name(), $sformatf("[SCB][WRITE][PASS] addr=%h len=%0d index=%0d data=%p resp=%b", tr.AWADDR,
                    tr.AWLEN,
                    index,
                    tr.WDATA,
                    tr.BRESP), UVM_LOW);
            end
            else begin
                failed++;
            end
        endtask


        task check_read(axi4_transaction tr);

            bit transaction_pass;
            bit legal;
            bit data_count_ok;
            logic [1:0]  expected_response;
            logic [31:0] expected_data;
            int unsigned index;
            int unsigned beats;
            int unsigned beat_addr;

            reads_checked++;
            transaction_pass = 1'b1;
            beats = int'(tr.ARLEN) + 1;
            legal = legal_read(tr);
            expected_response = legal ? 2'b00 : 2'b10;
            index = tr.ARADDR >> 2;

            if (tr.RRESP !== expected_response) begin
                `uvm_error(get_type_name(), $sformatf("[SCB][READ] Response mismatch: addr=%h expected=%b actual=%b",
                    tr.ARADDR,
                    expected_response,
                    tr.RRESP));
                transaction_pass = 1'b0;
            end

            if (legal) begin
                data_count_ok = (tr.RDATA.size() == beats);
                if (!data_count_ok) begin
                    `uvm_error(get_type_name(), $sformatf("[SCB][READ] Beat count mismatch: expected=%0d actual=%0d",
                        beats,
                        tr.RDATA.size()));
                    transaction_pass = 1'b0;
                end
                else begin
                    for (int i = 0; i < beats; i++) begin
                        expected_data = reference_memory[index + i];
                        beat_addr = (tr.ARADDR) + (i << tr.ARSIZE);
                        if (tr.RDATA[i] !== expected_data) begin
                            `uvm_error(get_type_name(), $sformatf("[SCB][READ] Data mismatch: beat=%0d addr=%h expected=%p actual=%p",
                                i,
                                beat_addr,
                                expected_data,
                                tr.RDATA[i]));
                            transaction_pass = 1'b0;
                        end
                    end
                end
            end else begin
                for (int i = 0; i < tr.RDATA.size(); i++) begin
                    if (tr.RDATA[i] !== 32'd0) begin
                        `uvm_error(get_type_name(), $sformatf("[SCB][READ] Invalid read must return zero data: beat=%0d actual=%h",
                            i,
                            tr.RDATA[i]));
                        transaction_pass = 1'b0;
                    end
                end
            end

            if (tr.RLAST !== 1'b1) begin
                `uvm_error(get_type_name(), $sformatf("[SCB][READ] RLAST not asserted on final returned beat: addr=%h len=%0d",
                    tr.ARADDR,
                    tr.ARLEN));
                transaction_pass = 1'b0;
            end

            if (transaction_pass) begin
                passed++;
                `uvm_info(get_type_name(), $sformatf("[SCB][READ][PASS] addr=%h len=%0d index=%0d data=%p resp=%b",
                    tr.ARADDR,
                    tr.ARLEN,
                    index,
                    tr.RDATA,
                    tr.RRESP), UVM_LOW);
            end
            else begin
                failed++;
            end
        endtask

        task scoreboard();
            axi4_transaction actual;
            forever begin
                fifo.get(actual);
                case (actual.operation)
                    WRITE_OP: check_write(actual);
                    READ_OP : check_read(actual);
                    default : begin
                        failed++;
                        `uvm_error(get_type_name(), "[SCB] Unknown transaction operation");
                    end
                endcase

                total_transactions++;
            end
        endtask
    endclass
endpackage
