/obj/machinery/power/port_gen/pacman/super/potato
	name = "nuclear reactor"
	desc = "PTTO-3, an industrial all-in-one nuclear power plant by Neo-Chernobyl GmbH. It uses uranium as a fuel source. Rated for 200 kW max safe output."
	icon_state = "potato"
	time_per_sheet = 1152 //same power output, but a 50 sheet stack will last 4 hours at max safe power
	power_gen = 40000 //watts
	max_power_output = 5
	max_safe_output = 6
	temperature_gain = 80	//how much the temperature increases per power output level, in degrees per level
	max_temperature = 450
	anchored = 1
