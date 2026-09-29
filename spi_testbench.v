`timescale 1ns/1ps

module spi_master_tb;

    // ----------------------------------------
    // Testbench signals
    // ----------------------------------------

    reg clk;
    reg reset;
    reg start;
    reg [7:0] tx_data;
    reg miso;

    wire mosi;
    wire sclk;
    wire cs;
    wire [7:0] rx_data;
    wire busy;
    wire done;


    // ----------------------------------------
    // SPI Master
    // ----------------------------------------

    spi_master #(
        .CLK_DIV(4)
    ) uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .tx_data(tx_data),
        .miso(miso),

        .mosi(mosi),
        .sclk(sclk),
        .cs(cs),
        .rx_data(rx_data),
        .busy(busy),
        .done(done)
    );


    // ----------------------------------------
    // 100 MHz System Clock
    // ----------------------------------------

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end


    // ----------------------------------------
    // SPI Slave Model
    // ----------------------------------------

    reg [7:0] slave_data;
    integer slave_bit;


    // When CS becomes LOW,
    // prepare the first MISO bit.

    always @(negedge cs) begin

        slave_bit = 7;
        miso = slave_data[slave_bit];

    end


    // Change MISO on falling edge of SCLK.
    // This corresponds to SPI Mode 0.

    always @(negedge sclk) begin

        if (!cs) begin

            if (slave_bit > 0) begin

                slave_bit = slave_bit - 1;
                miso = slave_data[slave_bit];

            end

        end

    end


    // ----------------------------------------
    // SPI Transaction Task
    // ----------------------------------------

    task spi_transaction;

        input [7:0] master_data;
        input [7:0] slave_response;

        begin

            // Set data
            tx_data    = master_data;
            slave_data = slave_response;

            // Start transfer
            start = 1'b1;

            #10;

            start = 1'b0;

            // Wait for transfer completion
            wait(done);

            #10;

            // Display result
            $display("----------------------------------------");
            $display("SPI TRANSACTION");
            $display("Master TX = %b", master_data);
            $display("Slave  TX = %b", slave_response);
            $display("Master RX = %b", rx_data);

            // Automatic verification
            if (rx_data == slave_response) begin
                $display("RESULT   = PASS");
            end
            else begin
                $display("RESULT   = FAIL");
            end

            $display("----------------------------------------");

            // Wait before next transaction
            #50;

        end

    endtask


    // ----------------------------------------
    // Main Test
    // ----------------------------------------

    initial begin

        // Initial values
        reset      = 1'b1;
        start      = 1'b0;
        tx_data    = 8'b0;
        miso       = 1'b0;
        slave_data = 8'b0;
        slave_bit  = 7;


        // -------------------------------
        // RESET
        // -------------------------------

        #20;

        reset = 1'b0;

        #20;


        // -------------------------------
        // TEST CASE 1
        // -------------------------------

        spi_transaction(
            8'b10110010,
            8'b01101001
        );


        // -------------------------------
        // TEST CASE 2
        // -------------------------------

        spi_transaction(
            8'b11001100,
            8'b00111100
        );


        // -------------------------------
        // TEST CASE 3
        // -------------------------------

        spi_transaction(
            8'b11110000,
            8'b01010101
        );


        // -------------------------------
        // FINISH
        // -------------------------------

        $display("");
        $display("========================================");
        $display("       SPI VERIFICATION COMPLETE");
        $display("========================================");

        #50;

        $finish;

    end


    // ----------------------------------------
    // VCD Waveform Dump
    // ----------------------------------------

    initial begin

        $dumpfile("spi_master.vcd");
        $dumpvars(0, spi_master_tb);

    end

endmodule
