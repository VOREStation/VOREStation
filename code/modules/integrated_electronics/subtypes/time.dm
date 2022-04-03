/obj/item/integrated_circuit/time
	name = "time circuit"
	desc = "Now you can build your own clock!"
	complexity = 2
	inputs = list()
	outputs = list()
	category_text = "Time"

/obj/item/integrated_circuit/time/delay
	name = "delay circuit"
	desc = "This sends a pulse signal out after a delay defined in tenths of a second, critical for ensuring proper \
	control flow in a complex machine. This circuit's delay can be customized, between 1/10th of a second to one hour. \
	The delay is updated upon receiving a pulse."
	extended_desc = "The delay is defined in tenths of a second. For instance, 4 will be a delay of 0.4 seconds, or 15 for 1.5 seconds."
	icon_state = "delay"
	inputs = list("delay time" = IC_PINTYPE_NUMBER)
	activators = list("incoming"= IC_PINTYPE_PULSE_IN,"outgoing" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 2
	var/delay = 20

/obj/item/integrated_circuit/time/delay/do_work()
	var/delay_input = get_pin_data(IC_INPUT, 1)
	if(delay_input && isnum(delay_input) )
		var/new_delay = clamp(delay_input, 1, 1 HOUR)
		delay = new_delay

	addtimer(CALLBACK(src, .proc/activate_pin, 2), delay)

/obj/item/integrated_circuit/time/ticker
	name = "ticker circuit"
	desc = "This circuit sends an automatic pulse every given interval, defined in tenths of a second."
	extended_desc ="This circuit sends an automatic pulse every given interval, defined in tenths of a second. \
	For example, setting the time pin to 4 will send a pulse every 0.4 seconds, or 15 for every 1.5 seconds.<br>\
	The power consumption will scale based on how fast this ticks. Also, note that most components have a short \
	internal cooldown when activated."
	icon_state = "tick-f"
	complexity = 10
	inputs = list("enable ticking" = IC_PINTYPE_BOOLEAN, "delay time" = IC_PINTYPE_NUMBER)
	activators = list("outgoing pulse" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 5
	var/delay = 2 SECONDS
	var/next_fire = 0
	var/is_running = FALSE
	// Power consumption scales based on how fast it ticks.
	// This, plus the fact it ticks more often will increase consumption non-linearly,
	// and the circuit cooldown and will hopefully discourage stupidly fast ticking machines.
	var/max_power_draw = 500

/obj/item/integrated_circuit/time/ticker/on_data_written()
	var/delay_input = get_pin_data(IC_INPUT, 2)
	if(delay_input && isnum(delay_input) )
		var/new_delay = clamp(delay_input, 1, 1 HOUR)
		delay = new_delay
		power_draw_per_use = CEILING((max_power_draw / delay) / delay, 1)

	var/do_tick = get_pin_data(IC_INPUT, 1)
	if(do_tick && !is_running)
		is_running = TRUE
		tick()
	else if(!do_tick && is_running)
		is_running = FALSE


/obj/item/integrated_circuit/time/ticker/proc/tick()
	if(is_running && check_power())
		addtimer(CALLBACK(src, .proc/tick), delay)
		if(world.time > next_fire)
			next_fire = world.time + delay
			activate_pin(1)

/obj/item/integrated_circuit/time/clock
	name = "integrated clock"
	desc = "Tells you what the local time is, specific to your station or planet."
	icon_state = "clock"
	inputs = list()
	outputs = list(
		"time" = IC_PINTYPE_STRING,
		"hours" = IC_PINTYPE_NUMBER,
		"minutes" = IC_PINTYPE_NUMBER,
		"seconds" = IC_PINTYPE_NUMBER
		)
	activators = list("get time" = IC_PINTYPE_PULSE_IN, "on time got" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	power_draw_per_use = 4

/obj/item/integrated_circuit/time/clock/do_work()
	set_pin_data(IC_OUTPUT, 1, time2text(station_time_in_ds, "hh:mm:ss") )
	set_pin_data(IC_OUTPUT, 2, text2num(time2text(station_time_in_ds, "hh") ) )
	set_pin_data(IC_OUTPUT, 3, text2num(time2text(station_time_in_ds, "mm") ) )
	set_pin_data(IC_OUTPUT, 4, text2num(time2text(station_time_in_ds, "ss") ) )

	push_data()
	activate_pin(2)
