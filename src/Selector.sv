module top(
    input logic clk, reset, s0, s1, rx3, rx4, rx5, rx6, tx2, 
    output logic tx3, tx4, tx5, tx6, rx2,
    output logic [5:0]leds);
    logic [3:0]EN_UART; 
    //generar instancias 
    decoder_select decoder(s0,s1,EN_UART);
    mux_tri mux(rx3, rx4, rx5, rx6, EN_UART, rx2);
    demux dem(tx2, EN_UART,tx3, tx4, tx5, tx6);
    leds salidas_led(s1, s0, leds); 

    

endmodule 

module triState(input logic a, select, output tri y);
    assign y = select ? a : 1'bz; 
endmodule 

module demux(input logic tx2, 
             input logic [3:0]EN_UART, 
             output logic tx3, tx4, tx5, tx6); //    

    assign tx3 = EN_UART[0] ? tx2 : 1; 
    assign tx4 = EN_UART[1] ? tx2 : 1; 
    assign tx5 = EN_UART[2] ? tx2 : 1; 
    assign tx6 = EN_UART[3] ? tx2 : 1; 


endmodule


module mux_tri(input logic rx3, rx4, rx5, rx6, 
               input logic [3:0] EN_UART, 
               output logic rx2); 

    triState mux_t3(rx3,EN_UART[0],rx2);
    triState mux_t4(rx4,EN_UART[1],rx2);
    triState mux_t5(rx5,EN_UART[2],rx2);
    triState mux_t6(rx6,EN_UART[3],rx2);
    
endmodule   

module decoder_select(input logic s0, s1, 
                      output logic [3:0]EN_UART); 
    always_comb begin 
        case ({s1,s0})
            2'b00: EN_UART = 4'b0001; //EN_UART[0]
            2'b01: EN_UART = 4'b0010; //EN_UART[1]
            2'b10: EN_UART = 4'b0100; //EN_UART[2]
            2'b11: EN_UART = 4'b1000; //EN_UART[3]
            default: EN_UART = 4'b0000;
            //en caso de no cumplir ocn todas las comb, se debe poner un default
        endcase
    end 
endmodule

module leds (input logic s1, s0, 
             output logic [5:0]leds); 
    always_comb begin 
        case({s1,s0})
            2'b00: leds <=6'b011111;
            2'b01: leds <=6'b111110; //leds con ceros 
            2'b10: leds <=6'b111101;
            2'b11: leds <=6'b011100;
        endcase
    end
endmodule


