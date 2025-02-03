library verilog;
use verilog.vl_types.all;
entity Proj_rev2_vlg_check_tst is
    port(
        pinBuzzer       : in     vl_logic;
        pinledAmarelo   : in     vl_logic;
        pinledVerde     : in     vl_logic;
        pinledVermelho  : in     vl_logic;
        pinMotor        : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end Proj_rev2_vlg_check_tst;
