`timescale 1ns/1ps

module tb_smart_home_automation;

// Inputs
reg clk;
reg rst;
reg motion_detected;
reg ambient_dark;
reg temp_high;
reg smoke_detected;
reg arm_security;
reg disarm_security;

// Outputs
wire lights_on;
wire fan_on;
wire alarm_on;
wire hvac_on;
wire security_armed;

// DUT
smart_home_automation DUT (
    .clk(clk),
    .rst(rst),
    .motion_detected(motion_detected),
    .ambient_dark(ambient_dark),
    .temp_high(temp_high),
    .smoke_detected(smoke_detected),
    .arm_security(arm_security),
    .disarm_security(disarm_security),
    .lights_on(lights_on),
    .fan_on(fan_on),
    .alarm_on(alarm_on),
    .hvac_on(hvac_on),
    .security_armed(security_armed)
);

// Clock Generation
initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

// VCD Dump
initial
begin
    $dumpfile("smart_home_automation.vcd");
    $dumpvars(0, tb_smart_home_automation);
end

// Monitor
initial
begin
    $monitor(
        "T=%0t | State Outputs -> Light=%b Fan=%b HVAC=%b Alarm=%b Armed=%b",
        $time,
        lights_on,
        fan_on,
        hvac_on,
        alarm_on,
        security_armed
    );
end

// Test Stimulus
initial
begin
    // Reset
    rst = 1;
    motion_detected = 0;
    ambient_dark = 0;
    temp_high = 0;
    smoke_detected = 0;
    arm_security = 0;
    disarm_security = 0;

    #15 rst = 0;

    // IDLE -> OCCUPIED
    #10 motion_detected = 1;

    // OCCUPIED -> NIGHT
    #20 ambient_dark = 1;

    // NIGHT -> OCCUPIED
    #20 ambient_dark = 0;

    // OCCUPIED -> COOLING
    #20 temp_high = 1;

    // COOLING -> OCCUPIED
    #20 temp_high = 0;

    // OCCUPIED -> AWAY_ARMED
    #20 begin
        arm_security = 1;
        motion_detected = 1;
    end

    #10 arm_security = 0;

    // Return to IDLE
    #20 motion_detected = 0;

    // Arm Security Again
    #20 arm_security = 1;
    #10 arm_security = 0;

    // Intrusion -> ALERT
    #20 motion_detected = 1;

    // Clear Intrusion
    #20 begin
        disarm_security = 1;
        motion_detected = 0;
    end

    #20 disarm_security = 0;

    // Smoke Alert
    #20 smoke_detected = 1;

    #20 begin
        smoke_detected = 0;
        disarm_security = 1;
    end

    #20 disarm_security = 0;

    #50;
    $finish;
end

endmodule
