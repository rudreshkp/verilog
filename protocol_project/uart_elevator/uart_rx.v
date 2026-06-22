module uart_rx(
input clk,
input rst,
input rx,
input tick,

output reg [7:0] data_out,
output reg rx_done
);

reg [3:0] bit_count;
reg [7:0] shift_reg;

reg [1:0] state;

localparam IDLE  = 0;
localparam START = 1;
localparam DATA  = 2;
localparam STOP  = 3;

always @(posedge clk)
begin
    if(rst)
    begin
        state <= IDLE;
        bit_count <= 0;
        rx_done <= 0;
    end
    else
    begin
        rx_done <= 0;

        case(state)

        IDLE:
        begin
            if(rx == 0)
                state <= START;
        end

        START:
        begin
            if(tick)
            begin
                bit_count <= 0;
                state <= DATA;
            end
        end

        DATA:
        begin
            if(tick)
            begin
                shift_reg[bit_count] <= rx;

                if(bit_count == 7)
                    state <= STOP;

                bit_count <= bit_count + 1;
            end
        end

        STOP:
        begin
            if(tick)
            begin
                data_out <= shift_reg;
                rx_done <= 1;
                state <= IDLE;
            end
        end

        endcase
    end
