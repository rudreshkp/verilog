module encoder4to2_tb;

reg [3:0] i;
wire [1:0] y;

encoder4to2 uut(
    .i(i),
    .y(y)
);

initial begin
    $monitor("Time=%0t i=%b y=%b", $time, i, y);

    i = 4'b0001; #10;
    i = 4'b0010; #10;
    i = 4'b0100; #10;
    i = 4'b1000; #10;

    $finish;
end

endmodule
