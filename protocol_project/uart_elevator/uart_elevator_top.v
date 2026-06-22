module uart_elevator_top(
input clk,
input rst,
input rx,

output [1:0] current_floor,
output motor_up,
output motor_down,
output door_open
);

wire tick;

wire [7:0] rx_data;
wire rx_done;

wire call_valid;
wire [1:0] floor;

baud_gen baud(
.clk(clk),
.rst(rst),
.tick(tick)
);

uart_rx receiver(
.clk(clk),
.rst(rst),
.rx(rx),
.tick(tick),
.data_out(rx_data),
.rx_done(rx_done)
);

decoder dec(
.rx_data(rx_data),
.rx_done(rx_done),
.call_valid(call_valid),
.floor(floor)
);

elevatorfsm elev(
.clk(clk),
.rst(rst),
.call_valid(call_valid),
.call_floor(floor),
.door_obstruction(1'b0),
.emergency_stop(1'b0),
.current_floor(current_floor),
.motor_up(motor_up),
.motor_down(motor_down),
.door_open(door_open)
);

endmodule
