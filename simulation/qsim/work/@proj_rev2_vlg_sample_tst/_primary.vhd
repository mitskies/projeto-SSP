library verilog;
use verilog.vl_types.all;
entity Proj_rev2_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        pinReset        : in     vl_logic;
        pinRun          : in     vl_logic;
        pinSensor       : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end Proj_rev2_vlg_sample_tst;
