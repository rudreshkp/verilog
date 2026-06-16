`timescale 1ns/1ps

module tb_elevatorfsm;

reg clk;
reg rst;
reg call_valid;
reg door_obstruction;
reg emergency_stop;
reg [1:0] call_floor;

wire [1:0] current_floor;
wire motor_up;
wire motor_down;
wire door_open;
wire [2:0] state_dbg;

elevatorfsm dut
(
.clk(clk),
.rst(rst),
.call_valid(call_valid),
.door_obstruction(door_obstruction),
.emergency_stop(emergency_stop),
.call_floor(call_floor),

.current_floor(current_floor),
.motor_up(motor_up),
.motor_down(motor_down),
.door_open(door_open),
.state_dbg(state_dbg)
);

initial
begin
clk = 0;
forever #5 clk = ~clk;
end

initial
begin
$monitor("TIME=%0t STATE=%0d FLOOR=%0d UP=%b DOWN=%b DOOR=%b",
$time,
state_dbg,
current_floor,
motor_up,
motor_down,
door_open);
end

initial
begin

rst = 1;
call_valid = 0;
call_floor = 0;
door_obstruction = 0;
emergency_stop = 0;

#20;
rst = 0;

$display("\n========== TEST 1 : RESET ==========");

#20;

$display("\n========== TEST 2 : FLOOR 0 TO FLOOR 2 ==========");

call_valid = 1;
call_floor = 2;

#10;
call_valid = 0;

#120;

$display("\n========== TEST 3 : SAME FLOOR REQUEST ==========");

call_valid = 1;
call_floor = current_floor;

#10;
call_valid = 0;

#60;

$display("\n========== TEST 4 : DOOR OBSTRUCTION ==========");

call_valid = 1;
call_floor = current_floor;

#10;
call_valid = 0;

#10;

door_obstruction = 1;

#50;

door_obstruction = 0;

#60;

$display("\n========== TEST 5 : FLOOR 2 TO FLOOR 0 ==========");

call_valid = 1;
call_floor = 0;

#10;
call_valid = 0;

#120;

$display("\n========== TEST 6 : EMERGENCY FROM IDLE ==========");

emergency_stop = 1;

#40;

emergency_stop = 0;

#50;

$display("\n========== TEST 7 : FLOOR 0 TO FLOOR 2 AGAIN ==========");

call_valid = 1;
call_floor = 2;

#10;
call_valid = 0;

#120;

$display("\n========== TEST 8 : FLOOR 2 TO FLOOR 0 ==========");

call_valid = 1;
call_floor = 0;

#10;
call_valid = 0;

#120;

$display("\n========== TEST 9 : EMERGENCY DURING MOVE_UP ==========");

call_valid = 1;
call_floor = 2;

#10;
call_valid = 0;

#15;

emergency_stop = 1;

#40;

emergency_stop = 0;

#60;

$display("\n========== TEST 10 : EMERGENCY DURING MOVE_DOWN ==========");

call_valid = 1;
call_floor = 0;

#10;
call_valid = 0;

#15;

emergency_stop = 1;

#40;

emergency_stop = 0;

#60;

$display("\n========== ALL TESTS COMPLETED ==========");

$finish;

end

endmodule
