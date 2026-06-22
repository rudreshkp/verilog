module clock_divider
(
input clk,
input rst,
output reg clk_1hz
);

reg [25:0] count;

always @(posedge clk)
begin

if(rst)
begin
count <= 0;
clk_1hz <= 0;
end

else
begin

if(count == 24999999)
begin
count <= 0;
clk_1hz <= ~clk_1hz;
end

else
count <= count + 1;

end

end

endmodule
