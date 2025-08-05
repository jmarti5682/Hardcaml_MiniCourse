module nexys_a7_100t (
    clock_100,
    switches,
    leds
);

    input clock_100;
    input [15:0] switches;
    output [15:0] leds;

    wire _51;
    wire [3:0] _50;
    wire _49;
    wire _47;
    wire _44;
    wire _42;
    wire _40;
    reg [3:0] _45;
    wire _38;
    wire _36;
    wire _34;
    wire _30;
    wire _28;
    wire _26;
    wire _23;
    wire _21;
    wire _19;
    wire [3:0] _18;
    reg [3:0] _24;
    wire [3:0] _25;
    reg [3:0] _31;
    wire _16;
    wire _14;
    wire _12;
    wire _9;
    wire _7;
    wire _5;
    wire [3:0] _4;
    reg [3:0] _10;
    wire [3:0] _11;
    reg [3:0] _17;
    wire [3:0] _32;
    wire [3:0] _33;
    reg [3:0] _39;
    wire [3:0] _46;
    reg [3:0] _52;
    wire [15:0] _53;
    assign _51 = switches[2:2];
    assign _50 = 4'b0000;
    assign _49 = switches[1:1];
    assign _47 = switches[0:0];
    assign _44 = switches[2:2];
    assign _42 = switches[1:1];
    assign _40 = switches[0:0];
    always @(posedge clock_100 or posedge _40) begin
        if (_40)
            _45 <= _50;
        else
            if (_42)
                _45 <= _50;
            else
                if (_44)
                    _45 <= _31;
    end
    assign _38 = switches[2:2];
    assign _36 = switches[1:1];
    assign _34 = switches[0:0];
    assign _30 = switches[2:2];
    assign _28 = switches[1:1];
    assign _26 = switches[0:0];
    assign _23 = switches[2:2];
    assign _21 = switches[1:1];
    assign _19 = switches[0:0];
    assign _18 = switches[6:3];
    always @(posedge clock_100 or posedge _19) begin
        if (_19)
            _24 <= _50;
        else
            if (_21)
                _24 <= _50;
            else
                if (_23)
                    _24 <= _18;
    end
    assign _25 = _24 & _10;
    always @(posedge clock_100 or posedge _26) begin
        if (_26)
            _31 <= _50;
        else
            if (_28)
                _31 <= _50;
            else
                if (_30)
                    _31 <= _25;
    end
    assign _16 = switches[2:2];
    assign _14 = switches[1:1];
    assign _12 = switches[0:0];
    assign _9 = switches[2:2];
    assign _7 = switches[1:1];
    assign _5 = switches[0:0];
    assign _4 = switches[10:7];
    always @(posedge clock_100 or posedge _5) begin
        if (_5)
            _10 <= _50;
        else
            if (_7)
                _10 <= _50;
            else
                if (_9)
                    _10 <= _4;
    end
    assign _11 = ~ _10;
    always @(posedge clock_100 or posedge _12) begin
        if (_12)
            _17 <= _50;
        else
            if (_14)
                _17 <= _50;
            else
                if (_16)
                    _17 <= _11;
    end
    assign _32 = _17 & _31;
    assign _33 = ~ _32;
    always @(posedge clock_100 or posedge _34) begin
        if (_34)
            _39 <= _50;
        else
            if (_36)
                _39 <= _50;
            else
                if (_38)
                    _39 <= _33;
    end
    assign _46 = _39 ^ _45;
    always @(posedge clock_100 or posedge _47) begin
        if (_47)
            _52 <= _50;
        else
            if (_49)
                _52 <= _50;
            else
                if (_51)
                    _52 <= _46;
    end
    assign _53 = { _52,
                   _39,
                   _17,
                   _31 };
    assign leds = _53;

endmodule
module nexys_a7_100t_top
(
  input [15:0] switches,
  input clock_100,
  input reset_n,
  output [15:0] leds
);

  nexys_a7_100t _5
  (
    .switches(switches), 
    .clock_100(clock_100), 
    .leds(leds)
  );
endmodule
