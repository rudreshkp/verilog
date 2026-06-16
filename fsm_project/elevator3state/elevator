`timescale 1ns / 1ps

module elevatorfsm
#(
parameter MOVE_TICKS = 2,
parameter DOOR_TICKS = 3
)
(
input clk,
input rst,
input call_valid,
input door_obstruction,
input emergency_stop,
input [1:0] call_floor,

output reg [1:0] current_floor,
output reg motor_up,
output reg motor_down,
output reg door_open,
output [2:0] state_dbg
);

parameter S_IDLE      = 3'd0;
parameter S_MOVE_UP   = 3'd1;
parameter S_MOVE_DOWN = 3'd2;
parameter S_DOOR_OPEN = 3'd3;
parameter S_EMERGENCY = 3'd4;

reg [2:0] state,next_state;
reg [1:0] target_floor;
reg [7:0] timer;

assign state_dbg = state;


always @(posedge clk)
begin
if(rst)
state <= S_IDLE;
else
state <= next_state;
end


always @(posedge clk)
begin

if(rst)
begin
current_floor <= 2'd0;
target_floor <= 2'd0;
timer <= 0;
end

else
begin

if(state == S_IDLE && call_valid && call_floor <= 2)
target_floor <= call_floor;


if(state != next_state)
timer <= 0;

else if(state == S_MOVE_UP)
begin

if(timer == MOVE_TICKS-1)
begin
timer <= 0;

if(current_floor < target_floor)
current_floor <= current_floor + 1;
end

else
timer <= timer + 1;

end


else if(state == S_MOVE_DOWN)
begin

if(timer == MOVE_TICKS-1)
begin
timer <= 0;

if(current_floor > target_floor)
current_floor <= current_floor - 1;
end

else
timer <= timer + 1;

end


else if(state == S_DOOR_OPEN)
begin

if(!door_obstruction && timer < DOOR_TICKS)
timer <= timer + 1;

end


else if(state == S_EMERGENCY)
begin
timer <= 0;
end

end

end


always @(*)
begin

next_state = state;

if(emergency_stop)
next_state = S_EMERGENCY;

else
begin

case(state)

S_IDLE:
begin

if(call_valid)
begin

if(call_floor > current_floor)
next_state = S_MOVE_UP;

else if(call_floor < current_floor)
next_state = S_MOVE_DOWN;

else
next_state = S_DOOR_OPEN;

end

end


S_MOVE_UP:
begin

if(current_floor == target_floor)
next_state = S_DOOR_OPEN;

end


S_MOVE_DOWN:
begin

if(current_floor == target_floor)
next_state = S_DOOR_OPEN;

end


S_DOOR_OPEN:
begin

if(timer >= DOOR_TICKS && !door_obstruction)
next_state = S_IDLE;

end


S_EMERGENCY:
begin

if(!emergency_stop)
next_state = S_IDLE;

end


default:
begin
next_state = S_IDLE;
end

endcase

end

end


always @(*)
begin

motor_up = 0;
motor_down = 0;
door_open = 0;

case(state)

S_MOVE_UP:
begin
motor_up = 1;
end


S_MOVE_DOWN:
begin
motor_down = 1;
end


S_DOOR_OPEN:
begin
door_open = 1;
end


S_EMERGENCY:
begin
door_open = 1;
end


default:
begin
motor_up = 0;
motor_down = 0;
door_open = 0;
end

endcase

end

endmodule
