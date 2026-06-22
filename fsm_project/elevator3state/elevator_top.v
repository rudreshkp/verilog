module elevator_top
(
input clk,
input [4:0] sw,
input [4:0] pb,

output [7:0] led
);

wire clk_1hz;

wire rst_db;
wire call_valid_db;
wire obstruction_db;
wire emergency_db;

wire [1:0] current_floor;
wire motor_up;
wire motor_down;
wire door_open;
wire [2:0] state_dbg;


clock_divider u1
(
.clk(clk),
.rst(pb[0]),
.clk_1hz(clk_1hz)
);


debouncer u2
(
.clk(clk),
.btn(pb[0]),
.btn_db(rst_db)
);

debouncer u3
(
.clk(clk),
.btn(sw[2]),
.btn_db(call_valid_db)
);

debouncer u4
(
.clk(clk),
.btn(sw[3]),
.btn_db(obstruction_db)
);

debouncer u5
(
.clk(clk),
.btn(sw[4]),
.btn_db(emergency_db)
);


elevatorfsm
#(
.MOVE_TICKS(2),
.DOOR_TICKS(3)
)
dut
(
.clk(clk_1hz),
.rst(rst_db),
.call_valid(call_valid_db),
.door_obstruction(obstruction_db),
.emergency_stop(emergency_db),
.call_floor(sw[1:0]),

.current_floor(current_floor),
.motor_up(motor_up),
.motor_down(motor_down),
.door_open(door_open),
.state_dbg(state_dbg)
);


assign led[0] = current_floor[0];
assign led[1] = current_floor[1];

assign led[2] = motor_up;
assign led[3] = motor_down;

assign led[4] = door_open;

assign led[5] = state_dbg[0];
assign led[6] = state_dbg[1];
assign led[7] = state_dbg[2];

endmodule
