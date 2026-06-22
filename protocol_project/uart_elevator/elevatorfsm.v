module elevatorfsm
#(
    parameter MOVE_TICKS = 100000000,   // 2 sec @ 50 MHz
    parameter DOOR_TICKS = 150000000    // 3 sec @ 50 MHz
)
(
    input clk,
    input rst,

    input call_valid,
    input [1:0] call_floor,

    input door_obstruction,
    input emergency_stop,

    output reg [1:0] current_floor,
    output reg motor_up,
    output reg motor_down,
    output reg door_open,

    output [2:0] state_dbg
);

localparam S_IDLE      = 3'd0;
localparam S_MOVE_UP   = 3'd1;
localparam S_MOVE_DOWN = 3'd2;
localparam S_DOOR_OPEN = 3'd3;
localparam S_EMERGENCY = 3'd4;

reg [2:0] state;
reg [2:0] next_state;

reg [1:0] target_floor;
reg [1:0] safe_floor;

reg [31:0] timer;

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
        current_floor <= 0;
        target_floor  <= 0;
        safe_floor    <= 0;
        timer         <= 0;
    end
    else
    begin
        case(state)

        S_IDLE:
        begin
            timer <= 0;

            if(call_valid)
                target_floor <= call_floor;
        end

        S_MOVE_UP:
        begin
            if(timer < MOVE_TICKS-1)
                timer <= timer + 1;
            else
            begin
                timer <= 0;

                if(current_floor < 2)
                    current_floor <= current_floor + 1;
            end
        end

        S_MOVE_DOWN:
        begin
            if(timer < MOVE_TICKS-1)
                timer <= timer + 1;
            else
            begin
                timer <= 0;

                if(current_floor > 0)
                    current_floor <= current_floor - 1;
            end
        end

        S_DOOR_OPEN:
        begin
            if(!door_obstruction)
            begin
                if(timer < DOOR_TICKS-1)
                    timer <= timer + 1;
                else
                    timer <= 0;
            end
        end

        S_EMERGENCY:
        begin
            timer <= 0;

            if(current_floor == 0)
                safe_floor <= 0;
            else if(current_floor == 1)
                safe_floor <= 1;
            else
                safe_floor <= 2;
        end

        default:
            timer <= 0;

        endcase
    end
end

always @(*)
begin
    next_state = state;

    case(state)

    S_IDLE:
    begin
        if(emergency_stop)
            next_state = S_EMERGENCY;

        else if(call_valid)
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
        if(emergency_stop)
            next_state = S_EMERGENCY;

        else if((current_floor == target_floor) &&
                (timer == 0))
            next_state = S_DOOR_OPEN;
    end

    S_MOVE_DOWN:
    begin
        if(emergency_stop)
            next_state = S_EMERGENCY;

        else if((current_floor == target_floor) &&
                (timer == 0))
            next_state = S_DOOR_OPEN;
    end

    S_DOOR_OPEN:
    begin
        if(emergency_stop)
            next_state = S_EMERGENCY;

        else if((timer == 0) && !door_obstruction)
            next_state = S_IDLE;
    end

    S_EMERGENCY:
    begin
        if(!emergency_stop)
            next_state = S_IDLE;
    end

    default:
        next_state = S_IDLE;

    endcase
end

always @(*)
begin
    motor_up   = 0;
    motor_down = 0;
    door_open  = 0;

    case(state)

    S_MOVE_UP:
        motor_up = 1;

    S_MOVE_DOWN:
        motor_down = 1;

    S_DOOR_OPEN:
        door_open = 1;

    default:
    begin
        motor_up   = 0;
        motor_down = 0;
        door_open  = 0;
    end

    endcase
end

endmodule
