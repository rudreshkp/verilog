// smart_home_automation.v

module smart_home_automation (
    rst,
    clk,
    motion_detected,
    ambient_dark,
    temp_high,
    smoke_detected,
    arm_security,
    disarm_security,
    lights_on,
    fan_on,
    alarm_on,
    hvac_on,
    security_armed
);

// Inputs
input wire clk;
input wire rst;
input wire motion_detected;
input wire ambient_dark;
input wire temp_high;
input wire smoke_detected;
input wire arm_security;
input wire disarm_security;

// Outputs
output reg lights_on;
output reg fan_on;
output reg alarm_on;
output reg hvac_on;
output reg security_armed;

// State Encoding
parameter S_IDLE       = 3'b000,
          S_OCCUPIED   = 3'b001,
          S_NIGHT      = 3'b010,
          S_COOLING    = 3'b011,
          S_AWAY_ARMED = 3'b100,
          S_ALERT      = 3'b101;

reg [2:0] present_state, next_state;

// Present State Logic
always @(posedge clk or posedge rst)
begin
    if (rst)
        present_state <= S_IDLE;
    else
        present_state <= next_state;
end

// Next State Logic
always @(*)
begin
    next_state = present_state;

    if (smoke_detected)
    begin
        next_state = S_ALERT;
    end
    else
    begin
        case (present_state)

            S_IDLE:
            begin
                if (motion_detected)
                    next_state = S_OCCUPIED;
                else
                    next_state = S_IDLE;
            end

            S_OCCUPIED:
            begin
                if (!motion_detected)
                    next_state = S_IDLE;
                else if (ambient_dark)
                    next_state = S_NIGHT;
                else if (temp_high)
                    next_state = S_COOLING;
                else if (arm_security)
                    next_state = S_AWAY_ARMED;
                else
                    next_state = S_OCCUPIED;
            end

            S_NIGHT:
            begin
                if (!ambient_dark)
                    next_state = S_OCCUPIED;
                else if (!motion_detected)
                    next_state = S_IDLE;
                else
                    next_state = S_NIGHT;
            end

            S_COOLING:
            begin
                if (!temp_high)
                    next_state = S_OCCUPIED;
                else
                    next_state = S_COOLING;
            end

            S_AWAY_ARMED:
            begin
                if (disarm_security)
                    next_state = S_IDLE;
                else if (motion_detected)
                    next_state = S_ALERT;
                else
                    next_state = S_AWAY_ARMED;
            end

            S_ALERT:
            begin
                if (!smoke_detected && disarm_security && motion_detected)
                    next_state = S_OCCUPIED;
                else if (!smoke_detected && disarm_security && !motion_detected)
                    next_state = S_IDLE;
                else
                    next_state = S_ALERT;
            end

            default:
              next_state = S_IDLE;

        endcase
    end
end

// Output Logic
always @(*)
begin
    lights_on      = 1'b0;
    fan_on         = 1'b0;
    hvac_on        = 1'b0;
    alarm_on       = 1'b0;
    security_armed = 1'b0;

    if (!rst)
    begin
        case (present_state)

            S_NIGHT:
            begin
                lights_on = 1'b1;
            end

            S_COOLING:
            begin
                fan_on  = 1'b1;
                hvac_on = 1'b1;
            end

            S_ALERT:
            begin
                alarm_on = 1'b1;
            end

            S_AWAY_ARMED:
            begin
                security_armed = 1'b1;
            end

            default:
            begin
                lights_on      = 1'b0;
                fan_on         = 1'b0;
                hvac_on        = 1'b0;
                alarm_on       = 1'b0;
                security_armed = 1'b0;
            end

        endcase
    end
end

endmodule
