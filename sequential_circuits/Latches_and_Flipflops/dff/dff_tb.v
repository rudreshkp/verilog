`timescale 1ns/1ps

module dff_tb;

reg clk;
reg rst;
reg d;
wire q;

dff uut (
    .clk(clk),
    .rst(rst),
    .d(d),
    .q(q)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    $dumpfile("dff.vcd");
    $dumpvars(0, dff_tb);

    rst = 1; d = 0;  
    #10;

    rst = 0; d = 1; 
    #10;

    d = 0;        
    #10;

    d = 1;        
    #10;

    rst = 1;      
    #10;

    rst = 0; d = 1;
    #10;

    $finish;
end

initial begin
    $monitor("Time=%0t clk=%b rst=%b d=%b q=%b",
             $time, clk, rst, d, q);
end

endmodule
