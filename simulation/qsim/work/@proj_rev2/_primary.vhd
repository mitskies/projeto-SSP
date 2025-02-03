library verilog;
use verilog.vl_types.all;
entity Proj_rev2 is
    port(
        clk             : in     vl_logic;
        pinSensor       : in     vl_logic;
        pinRun          : in     vl_logic;
        pinReset        : in     vl_logic;
        pinMotor        : out    vl_logic;
        pinBuzzer       : out    vl_logic;
        pinledVerde     : out    vl_logic;
        pinledAmarelo   : out    vl_logic;
        pinledVermelho  : out    vl_logic
    );
end Proj_rev2;
