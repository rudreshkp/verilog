module demux1to2_tb;

reg d, s;
wire y0, y1;

demux1to2 uut(
    .d(d),
    .s(s),
    .y0(y0),
    .y1(y1)
);

initial begin
    $monitor("Time=%0t d=%b s=%b y0=%b y1=%b",
              $time, d, s, y0, y1);

    d=0; s=0; #10;
    d=1; s=0; #10;
    d=0; s=1; #10;
    d=1; s=1; #10;

    $finish;
end

endmodule
