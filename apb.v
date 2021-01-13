/*
    APB Slave Protocol in Verilog HDL

    Notes: Display commands are commented, but can be utilized for
           feedback in the terminal. This is useful for Linux and Mac
           where compilation and simulation are done in seperate
           environments. Additionally, this file contains the system
           commands $dumpfile and $dumpvars(). This is also related to
           Linux and Mac use cases. Specifically, these commands create
           Value Changes Dump (.vcd) file that is used to display
           simulation data in tools like Gtkwave.

           Additionally, $random is used to generate different, unique
           addresses and data in which the protocol can write and read.
           This allows the testbench to process multiple rounds of data
           and ensures the validity of the given code
*/

`timescale 1ns/1ps

module apb_slave(pclk, presetn, paddr, psel, penable, pwrite, pwdata, prdata, pready);

    input pclk;
    input presetn;
    input [7:0] paddr;
    input psel;
    input penable;
    input pwrite;
    input [31:0] pwdata;
    output reg [31:0] prdata;
    output reg pready;

    reg [7:0] error_addr = 8'bx;
    reg pslverr;
    reg [31:0] memory[255:0];
    reg [1:0] state;

    parameter IDLE = 2'b00;
    parameter SETUP = 2'b01;
    parameter ACCESS = 2'b10;

    always @(posedge pclk or negedge presetn)
    begin
        if(presetn)
        begin
            prdata <= 0;
            pslverr <= 0;
            state <= IDLE;
        end
        else
        begin
            case(state)
                IDLE:
                begin
                    prdata <= 0;
                    pready <= 0;
                    pslverr <= 0;

                    if(psel)
                    begin
                      state <= SETUP;
                    end
                end
                SETUP:
                begin
                    if(psel && pwrite)
                    begin
                        memory[paddr] <= pwdata;
                        pready <= 1;
                        //$display("WRITE occured at time %t  Written data: %d", $time, pwdata);
                    end
                    else if(psel && !pwrite)
                    begin
                        prdata <= memory[paddr];
                        pready <= 1;
                        //$display("READ occured at time %t  Read data: %d", $time, prdata);
                    end
                    state <= ACCESS;
                end
                ACCESS:
                if(psel && penable)
                begin
                    if(pwrite)
                    begin
                        prdata <= memory[paddr];
                        // $display("WRITE->READ occured at time %t  Read data: %d MEMORY: %d", $time, prdata, memory[paddr]);
                    end
                    if(paddr === error_addr)
                    begin
                        pslverr = 1;
                        if(pwrite)
                        begin
                            prdata <= 32'b0;
                        end
                        //$display("ERROR occured at time %t", $time);
                    end
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
