module top(
    input logic clk, reset, s0, s1, rx3, rx4, rx5, rx6, tx2, 
    output logic tx3, tx4, tx5, tx6, rx2);
    logic [3:0]EN_UART; 
    //generar instancias 
    decoder_select decoder(s0,s1,EN_UART);
    mux_tri mux(rx3, rx4, rx5, rx6, EN_UART, rx2);
    demux_tri dem(tx2, EN_UART,tx3, tx4, tx5, tx6);

endmodule 

module triState(input logic a, select, output tri y);
    assign y = select ? a : 1'bz; 
endmodule 

module demux_tri(input logic tx2, 
                 input logic [3:0]EN_UART, 
                 output tri tx3, tx4, tx5, tx6); //

    triState demux_t3(tx2, EN_UART[0],tx3);
    triState demux_t4(tx2, EN_UART[1],tx4);
    triState demux_t5(tx2, EN_UART[2],tx5);
    triState demux_t6(tx2, EN_UART[3],tx6);

endmodule

module mux_tri(input tri rx3, rx4, rx5, rx6, 
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

/*
module mux4_1(input logic a0, a1, a2, a3, s1, s2, s3, s4, output logic y); 
    buff b1(a0,s0,y)
    buff b2(a1,s1,y)
    buff b3(a2,s2,y)
    buff b4(a3,s3,y)
endmodule   
*/

