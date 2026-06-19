`timescale 1ns/1ps

module srlatch_tb;
reg s;
reg r;
wire q;

srlatch uut (.s(s),.r(r),.q(q));

initial
begin 
$dumpfile("srlatch.vcd");
$dumpvars(0,srlatch_tb);

s=0; r=0;
#10;

s=1;r=0;
#10;

s=0;r=0;
#10;

s=0;r=1;
#10;

s=0;r=0;
#10;
s = 1; r = 0;
#10;
 
s = 1; r = 1;
#10;

s = 0; r = 0;
#10;

$finish;
end

initial begin
    $monitor("Time=%0t s=%b r=%b q=%b", $time, s, r, q);
end

endmodule


