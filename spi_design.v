`timescale 1ns/1ps

module spi_master #(
    parameter CLK_DIV = 4
)(
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire [7:0] tx_data,
    input  wire       miso,

    output reg        mosi,
    output reg        sclk,
    output reg        cs,
    output reg [7:0]  rx_data,
    output reg        busy,
    output reg        done
);

    // Internal registers
    reg [7:0] tx_shift;
    reg [7:0] rx_shift;
    reg [2:0] bit_count;
    reg [15:0] clk_count;

    always @(posedge clk) begin

        // -------------------------------
        // RESET
        // -------------------------------
        if (reset) begin
            mosi      <= 1'b0;
            sclk      <= 1'b0;
            cs        <= 1'b1;
            rx_data   <= 8'b0;
            busy      <= 1'b0;
            done      <= 1'b0;

            tx_shift  <= 8'b0;
            rx_shift  <= 8'b0;
            bit_count <= 3'd0;
            clk_count <= 16'd0;
        end

        else begin

            // DONE is normally LOW
            done <= 1'b0;

            // -------------------------------
            // START NEW SPI TRANSFER
            // -------------------------------
            if (start && !busy) begin

                busy      <= 1'b1;
                cs        <= 1'b0;
                sclk      <= 1'b0;

                tx_shift  <= tx_data;
                rx_shift  <= 8'b0;
                bit_count <= 3'd0;
                clk_count <= 16'd0;

                // MSB first
                mosi <= tx_data[7];
            end

            // -------------------------------
            // SPI TRANSFER
            // -------------------------------
            else if (busy) begin

                // Clock divider
                if (clk_count == CLK_DIV - 1) begin

                    clk_count <= 16'd0;

                    // ---------------------------
                    // RISING EDGE OF SCLK
                    // ---------------------------
                    if (sclk == 1'b0) begin

                        sclk <= 1'b1;

                        // Sample MISO
                        rx_shift <= {rx_shift[6:0], miso};
                    end

                    // ---------------------------
                    // FALLING EDGE OF SCLK
                    // ---------------------------
                    else begin

                        sclk <= 1'b0;

                        // Check whether 8 bits are complete
                        if (bit_count == 3'd7) begin

                            busy    <= 1'b0;
                            cs      <= 1'b1;
                            done    <= 1'b1;

                            rx_data <= rx_shift;

                            mosi <= 1'b0;
                        end

                        else begin

                            bit_count <= bit_count + 1'b1;

                            // Shift TX register
                            tx_shift <= {tx_shift[6:0], 1'b0};

                            // Send next bit
                            mosi <= tx_shift[6];
                        end
                    end
                end

                else begin
                    clk_count <= clk_count + 1'b1;
                end
            end
        end
    end

endmodule
