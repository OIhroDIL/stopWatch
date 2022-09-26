##module key_ctl
##(
##input   rst,clk,
##input   pls1k,		// 1kHz Pulse
##input   key0,		// Start & Stop
##input   key1,		// Clear
##input	[3:0] enc,
##output	reg buzz,
##output 	reg cnt_en,cnt_clr
##);

restart

add_force rst -radix hex {1 0ns} {0 1ps} {1 100ns}
add_force clk -radix hex {0 0ns} {1 50ns} -repeat_every 100ns 

add_force pls1k -radix hex {0 0ns} {1 500us} -repeat_every 1000us 

add_force enc -radix hex 1

add_force key0 1
add_force key1 1

run 10ms

# Start/Stop Button Push for Count Start
add_force key0 0
run 30ms

add_force key0 1
run 50ms

# Start/Stop Button Push for Count Stop(Pause)
add_force key0 0
run 30ms

add_force key0 1
run 50ms
