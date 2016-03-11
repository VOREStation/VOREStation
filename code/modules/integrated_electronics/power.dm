/obj/item/integrated_circuit/power
	var/charge = 0
	var/max_charge = 0
	var/power_generated = 0

/obj/item/integrated_circuit/power/battery
	name = "micro powercell"
	desc = "An extremely small powercell, often used to power basic electronics, as a powersource or to use as a buffer."
	charge = 30
	max_charge = 30

/obj/item/integrated_circuit/power/solar
	name = "micro photovoltaic cell"
	desc = "A tiny solar cell, often used for small electornics, such as calculators."
	power_generated = 5
//photovoltaic