`timescale 1ns/1ps

module tb_d_latch;

reg d;
reg en;
wire q;

d_latch uut(.d(d),.en(en),.q(q));

initial begin
 $dumpfile("dlatch.vcd");
 $dumpvars(0,tb_d_latch);

d=0;en = 0;
#10;

d=1;
#10;

en =  1;
#10;

d = 0;
#10;

d = 1;
#10;

$finish;

end

initial begin
	$monitor("Time=%0t en=%b d=%b q=%b", $time, en, d, q);
end

endmodule


