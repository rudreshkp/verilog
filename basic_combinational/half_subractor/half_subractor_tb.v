`timescale 1ns/1ps

module half_subtractor_tb;

reg A;
reg B;
wire Difference;
wire Borrow;

half_subtractor uut (
    .A(A),
    .B(B),
    .Difference(Difference),
    .Borrow(Borrow)
);

initial begin
    $dumpfile("half_subtractor.vcd");
    $dumpvars(0, half_subtractor_tb);

    $display("Time\tA\tB\tDifference\tBorrow");
    $monitor("%0t\t%b\t%b\t%b\t\t%b",
              $time, A, B, Difference, Borrow);

    A = 0; B = 0; #10;
    A = 0; B = 1; #10;
    A = 1; B = 0; #10;
    A = 1; B = 1; #10;

    $finish;
end

endmodule
