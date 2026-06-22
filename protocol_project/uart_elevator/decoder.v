module decoder(
input [7:0] rx_data,
input rx_done,

output reg call_valid,
output reg [1:0] floor
);

always @(*)
begin
    call_valid = 0;
    floor = 0;

    if(rx_done)
    begin
        case(rx_data)

        8'd48:
        begin
            floor = 0;
            call_valid = 1;
        end

        8'd49:
        begin
            floor = 1;
            call_valid = 1;
        end

        8'd50:
        begin
            floor = 2;
            call_valid = 1;
        end

        endcase
    end
end

endmodule
