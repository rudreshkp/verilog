module and_gate_tb;
reg a, b;
wire y;
and_gate uut (
    .a(a),
    .b(b),
    .y(y)
);

initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0,and_gate_tb);
    $display("a b | y");
    $monitor("%b %b | %b", a, b, y);

    a = 0; b = 0;
    #10 a = 0; b = 1;
    #10 a = 1; b = 0;
    #10 a = 1; b = 1;
    #10 $finish;
end
endmodule
