module debouncer
(
input clk,
input btn,
output reg btn_db
);

reg [19:0] count;
reg btn_sync;

always @(posedge clk)
begin
btn_sync <= btn;

if(btn_sync == btn_db)
count <= 0;

else
begin
count <= count + 1;

if(count == 20'd999999)
btn_db <= btn_sync;
end
end

endmodule
