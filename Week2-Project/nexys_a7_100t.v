module nexys_a7_100t (
    switches,
    leds
);

    input [15:0] switches;
    output [15:0] leds;

    wire _13;
    wire _12;
    wire _14;
    wire _11;
    wire _15;
    wire _7;
    wire _9;
    wire _5;
    wire _4;
    wire _6;
    wire _10;
    wire _16;
    wire [14:0] _3;
    wire [15:0] _17;
    assign _13 = 1'b1;
    assign _12 = switches[11:11];
    assign _14 = _12 ^ _13;
    assign _11 = switches[12:12];
    assign _15 = _11 & _14;
    assign _7 = switches[13:13];
    assign _9 = _7 ^ _13;
    assign _5 = switches[14:14];
    assign _4 = switches[15:15];
    assign _6 = _4 & _5;
    assign _10 = _6 | _9;
    assign _16 = _10 | _15;
    assign _3 = 15'b000000000000000;
    assign _17 = { _3,
                   _16 };
    assign leds = _17;

endmodule
module nexys_a7_100t_top
(
  input [15:0] switches,
  output [15:0] leds
);

  nexys_a7_100t _3
  (
    .switches(switches), 
    .leds(leds)
  );
endmodule
