`timescale 1ns/1ps

module apb_slave_tb();

    reg pclk;
    reg presetn;
    reg [7:0] paddr;
    reg pwrite;
    reg psel;
    reg penable;
    reg [31:0] pwdata;
    wire [31:0] prdata;
    wire pready;

    reg [7:0] error_addr = 8'bx;
    reg pslverr;
    reg [31:0] memory [0:256];
    reg [1:0] state;

    apb_slave dut(.*);

    initial
    begin
        $dumpfile("apb.vcd");
        $dumpvars(0, apb_slave_tb);
        pclk = 0;
        presetn = 0;
        forever #10 pclk = ~pclk;
    end

    initial
    begin
        psel = 0;
        penable = 0;
        pwrite = 0;
        paddr = 0;
    end

    initial
    begin
    repeat(10)
    begin
        paddr = $random;
        pwdata = $random;

        @(posedge pclk)
            presetn = 1;
        @(posedge pclk);
            presetn = 0;
            psel = 1;
            pwrite = 1;
        @(posedge pclk);
            penable = 1;
        @(posedge pclk);
        @(posedge pclk);
            presetn = 1;
            psel = 0;
            penable = 0;
            pwrite = 0;
        @(posedge pclk);
            presetn = 0;
            psel = 1;
        @(posedge pclk);
            penable = 1;
        @(posedge pclk);
            psel = 1;
            pwrite = 1;
        @(posedge pclk);
            penable = 1;
            paddr = error_addr;
        @(posedge pclk);

    end

    #200 $finish;
    end
endmodule
